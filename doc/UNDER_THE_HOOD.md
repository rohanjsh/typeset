# TypeSet: Under the Hood

This document explains how TypeSet v3.0 parses, transforms, and renders formatted text.

---

## Architecture Overview

TypeSet uses a **compile-then-render** architecture with four layers:

```
Input string
    │
    ▼
┌──────────────────────────────────────────────────┐
│  1. TypesetParser          (parse → AST)         │
│  2. typesetAutoLink        (URL detection pass)  │  ← compile time
│  3. TypeSetDocument        (compiled document)   │
└──────────────────────────────────────────────────┘
    │
    ▼
┌──────────────────────────────────────────────────┐
│  4. TypesetRenderer        (AST → InlineSpans)   │  ← render time
└──────────────────────────────────────────────────┘
    │
    ▼
  Flutter Text.rich(...)
```

Parsing and AutoLink detection happen **once** at compile time. The resulting `TypeSetDocument` can then be rendered repeatedly with different styles or recognizers — useful during widget rebuilds.

### Shared pipeline

The same pipeline is reused by both public entry points:

| Entry point                | Mode    | Delimiters visible?          |
| -------------------------- | ------- | ---------------------------- |
| `TypeSet` widget           | Display | No                           |
| `TypeSetEditingController` | Editing | Yes (`showDelimiters: true`) |

---

## AST Node Types

The parser produces a tree of sealed `TypesetNode` subclasses:

| Node               | Description                                                       | Source                                            |
| ------------------ | ----------------------------------------------------------------- | ------------------------------------------------- |
| `TypesetTextNode`  | Plain text, no formatting                                         | Raw text segments                                 |
| `TypesetCodeNode`  | Inline code — content is literal, never parsed further            | `` `code` ``                                      |
| `TypesetStyleNode` | A styled span wrapping child nodes                                | `*bold*`, `_italic_`, `__underline__`, `~strike~` |
| `TypesetLinkNode`  | A detected link with a URL and a label (may contain nested nodes) | AutoLink pass                                     |

`TypesetStyle` enum values: `bold`, `italic`, `underline`, `strikethrough`.

---

## Stage 1: Parser

**Implementation:** `TypesetParser` (`lib/src/parser/parser.dart`)

### Input

A raw string with inline markers:

- `*bold*`
- `_italic_`
- `__underline__` (double underscore)
- `~strikethrough~`
- `` `monospace` ``
- `\` escape prefix (backslash before a reserved character)

### Algorithm

Single left-to-right pass with a **frame stack**:

1. Each opening delimiter pushes a `_Frame` onto the stack.
2. A matching closing delimiter pops the frame and wraps its children into a `TypesetStyleNode`.
3. Backticks are handled separately — they scan forward for a matching backtick and produce a `TypesetCodeNode` with literal content (no nested parsing).
4. `\` consumes the next character as literal text **only** if the next character is a reserved delimiter. Otherwise, the backslash is kept as-is (preserving file paths, etc.).
5. Adjacent text fragments are **coalesced** into a single `TypesetTextNode` via `appendTextNode()` to reduce node count.

### Delimiter disambiguation

- `_` followed by another `_` is read as the `__` (underline) delimiter.
- A lone `_` is read as italic.
- Delimiters must satisfy **open** and **close** boundary rules (no adjacent whitespace).
- Crossing delimiters (e.g., `*bold _italic*`) are treated as text to avoid ambiguity.

### Error tolerance

The parser is intentionally permissive:

- Unclosed markers are unwound from the stack and emitted as literal text.
- Crossing/overlapping delimiters are treated as text when ambiguous.

This keeps rendering stable for user-generated content.

---

## Stage 2: AutoLink Post-Processing

**Implementation:** `typesetAutoLink()` (`lib/src/parser/autolink_pass.dart`)

### Goal

Convert URL-like text in `TypesetTextNode` nodes to `TypesetLinkNode` nodes.

### Detection rules

- Matches `http://`, `https://`, and `www.` patterns via regex.
- Normalizes `www.` prefixes to `https://www.…`.
- Trims trailing punctuation (`.`, `,`, `!`, `?`, `:`, `"`, `>`, `;`) from URL matches.
- Handles balanced bracket/parenthesis pairs — only strips excess closing delimiters.
- Validates boundary: a URL must not be preceded by alphanumeric, `@`, `_`, `-`, `.`, or `/` characters (prevents matching mid-word).

### Validation

Each detected URL is validated against `TypeSetAutoLinkConfig`:

1. `allowedSchemes` — URL scheme must be in the set (default: `{'http', 'https'}`).
2. `allowedDomains` — Optional regex filter for the host.
3. `customValidator` — Optional `bool Function(Uri)` callback.

If any check fails, the original text is preserved (no link node is created).

### Safety behavior

- URLs inside `TypesetCodeNode` and existing `TypesetLinkNode` are **not** re-processed.
- `TypesetStyleNode` children are recursively processed — URLs inside styled text are still detected.

---

## Stage 3: Document Compilation

**Implementation:** `TypeSetDocument` (`lib/src/document.dart`)

`TypeSetDocument.compile(input)` runs Stages 1–2 and stores the resulting AST in an immutable, reusable object:

```dart
final doc = TypeSetDocument.compile(
  'Hello *world* https://flutter.dev',
  autoLinkConfig: TypeSetAutoLinkConfig.httpsOnly,
);

// Render multiple times with different styles:
doc.render(style: lightStyle);
doc.render(style: darkStyle);
```

Properties:

| Property         | Description                                                          |
| ---------------- | -------------------------------------------------------------------- |
| `inputText`      | Original source string                                               |
| `plainText`      | Text with all formatting markers stripped (via `typesetPlainText()`) |
| `autoLinkConfig` | The config used at compile time                                      |

### LRU Document Cache

**Implementation:** `TypeSetDocumentCache` (`lib/src/document_cache.dart`)

A global LRU cache avoids re-parsing identical inputs:

- Keyed by `(inputText, autoLinkConfig)` tuple.
- Default capacity: **256 entries**.
- Uses Dart's insertion-ordered `Map` for O(1) LRU promotion (remove + re-insert).
- Exposes `hits`, `misses`, and `hitRate` for diagnostics.
- Managed via `TypeSetGlobalConfig.documentCache` — set to `null` to disable caching globally.

---

## Stage 4: Rendering

**Implementation:** `TypesetRenderer` (`lib/src/renderer/renderer.dart`)

### Node → Span mapping

| AST Node           | Flutter Output             | Notes                                          |
| ------------------ | -------------------------- | ---------------------------------------------- |
| `TypesetTextNode`  | `TextSpan`                 | Plain text with inherited style                |
| `TypesetCodeNode`  | `TextSpan`                 | Monospace style, resets bold/italic/decoration |
| `TypesetStyleNode` | Nested `TextSpan`s         | Merges style override onto inherited style     |
| `TypesetLinkNode`  | `TextSpan` with recognizer | Link style + optional `GestureRecognizer`      |

### Span coalescing

Adjacent text leaves with identical style and recognizer are merged into a single `TextSpan` via `appendTextSpanLeaf()` to minimize the span tree size.

### Editing mode

When `showDelimiters: true`, the renderer inserts delimiter characters (`*`, `_`, `__`, `~`, `` ` ``) as separate spans with `markerColor` styling. The content between delimiters still receives its formatting style.

### Link interaction model

- Links are **always styled** (colored + underlined by default).
- Tap/click is **opt-in** via `TypeSetAutoLinkConfig.linkRecognizerBuilder`.
- Without a recognizer builder, links are visual-only (no interaction).
- Recognizer lifecycle is managed by `TypeSetRuntimeSession` — old recognizers are disposed on each rebuild.

---

## Runtime Session

**Implementation:** `TypeSetRuntimeSession` (`lib/src/runtime.dart`)

Manages the bridge between widgets and the compile/render pipeline:

1. **Document resolution** — checks local cache first, then global `TypeSetDocumentCache`.
2. **Recognizer lifecycle** — tracks `GestureRecognizer` instances created during rendering and disposes them on the next render or widget disposal.
3. **Config resolution** — `resolveTypeSetConfig()` merges layers in order:

```
Library defaults  →  Theme-derived style  →  Global config  →  Scoped provider  →  Local config
(lowest priority)                                                                  (highest priority)
```

Theme integration uses `TypeSetStyle.fromTheme(ThemeData)` to derive link, monospace, and marker colors from the active `ColorScheme`.

---

## Performance Design

TypeSet is designed to be the most performant inline text formatter in the Flutter ecosystem. Every layer is optimized to minimize allocations and avoid redundant work.

### Allocation strategy

| Hot path               | Technique                                                  | Effect                                                                      |
| ---------------------- | ---------------------------------------------------------- | --------------------------------------------------------------------------- |
| Parser text runs       | Batch-flushed via `substring(start, end)`                  | 1 `String` + 1 `TypesetTextNode` per contiguous text run, not per character |
| AST text nodes         | `appendTextNode()` coalesces adjacent text                 | Fewer nodes in the tree                                                     |
| Rendered spans         | `appendTextSpanLeaf()` coalesces adjacent same-style spans | Minimal `TextSpan` tree for Flutter layout                                  |
| AutoLink trailing trim | Index-based scan, 0–2 substrings at the end                | No per-iteration `String` allocation                                        |
| Document compilation   | Immutable `List.unmodifiable` + pre-computed `plainText`   | Zero re-computation on re-render                                            |

### Caching layers

| Layer                                   | Scope                  | What it avoids                                   |
| --------------------------------------- | ---------------------- | ------------------------------------------------ |
| `TypeSetRuntimeSession._cachedDocument` | Per-widget instance    | Re-compilation when input hasn't changed         |
| `TypeSetDocumentCache` (global LRU)     | Cross-widget, app-wide | Re-parsing identical messages across a chat list |
| Compile/render split                    | Architectural          | Re-parsing when only style or theme changes      |

In a typical chat list with 100 visible messages, the LRU cache means **scrolling back up triggers zero parsing** — only the render stage runs.

### Editing safeguards

- `maxLiveFormattingLength` (default: 5000 chars) disables live formatting for very large inputs to prevent frame drops.
- Composing range overlay uses pre-flattened leaves — no re-traversal of the span tree.
- `GestureRecognizer` lifecycle is managed per-render — old recognizers are disposed immediately, preventing memory leaks.

### Complexity

For input length _n_:

| Stage         | Complexity     | Notes                                                |
| ------------- | -------------- | ---------------------------------------------------- |
| Parse         | O(n)           | Single-pass, frame stack, zero backtracking          |
| AutoLink      | O(n)           | Regex scan + node rebuild                            |
| Render        | O(m)           | _m_ = AST node count                                 |
| Cache lookup  | O(1)           | Hash-based key, LRU promotion via remove + re-insert |
| Span coalesce | O(1) amortized | Constant-time check against previous span            |

### Why this is faster than alternatives

| Approach                                 | Limitation                                                | TypeSet's advantage                                |
| ---------------------------------------- | --------------------------------------------------------- | -------------------------------------------------- |
| Regex-based parsers (`simple_rich_text`) | O(n × p) where p = number of patterns; no nesting support | Single O(n) pass handles all styles + nesting      |
| CommonMark parsers (`flutter_markdown`)  | Full block-level parser overhead for inline-only use case | Purpose-built for inline formatting only           |
| Re-parse on every build                  | Redundant work on every `setState` / theme change         | Compile-then-render: parse once, render N times    |
| No caching                               | Same message parsed once per widget instance              | LRU cache shares compiled documents across widgets |

---

## File Map

```
lib/
├── typeset.dart                        # Public barrel export
└── src/
    ├── ast/
    │   ├── nodes.dart                  # TypesetNode sealed class hierarchy
    │   ├── ast_utils.dart              # appendTextNode() coalescing helper
    │   └── plain_text.dart             # typesetPlainText() extractor
    ├── parser/
    │   ├── parser.dart                 # TypesetParser (Stage 1)
    │   └── autolink_pass.dart          # typesetAutoLink() (Stage 2)
    ├── config/
    │   ├── config.dart                 # TypeSetConfig
    │   ├── style.dart                  # TypeSetStyle
    │   ├── autolink_config.dart        # TypeSetAutoLinkConfig
    │   ├── config_provider.dart        # TypeSetConfigProvider (InheritedWidget)
    │   └── global_config.dart          # TypeSetGlobalConfig singleton
    ├── renderer/
    │   ├── renderer.dart               # TypesetRenderer (Stage 4)
    │   └── span_utils.dart             # Span coalescing & leaf collection
    ├── document.dart                   # TypeSetDocument (Stage 3)
    ├── document_cache.dart             # TypeSetDocumentCache (LRU)
    ├── runtime.dart                    # TypeSetRuntimeSession + resolveTypeSetConfig()
    ├── reserved.dart                   # TypesetReserved delimiter constants
    └── widgets/
        ├── typeset.dart                # TypeSet widget
        ├── editing_controller.dart     # TypeSetEditingController
        ├── context_menus.dart          # getTypesetContextMenus()
        └── extensions.dart             # String.typeset() / String.plainText
```
