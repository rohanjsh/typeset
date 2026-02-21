# TypeSet: Under the hood

This document explains how TypeSet parses, transforms, and renders formatted text.

## Pipeline overview

TypeSet uses a deterministic 3-stage pipeline:

1. **Parse** plain input into an AST.
2. **AutoLink pass** transforms URL-like text nodes into link nodes (optional, config-driven).
3. **Render** AST nodes into Flutter `InlineSpan`s.

The same pipeline is reused by:

- `TypeSet` (display mode)
- `TypeSetEditingController` (editing mode with marker visualization)

## 1) Parser stage

Implementation: `TypesetParser`.

### Input

A raw string with inline markers:

- `*bold*`
- `_italic_`
- `__underline__`
- `~strikethrough~`
- `` `monospace` ``
- escaped markers via `\`

### Algorithm

TypeSet uses a single left-to-right pass with a **frame stack**:

- Each open style marker pushes a frame.
- A matching marker pops and creates a `TypesetStyleNode`.
- Backticks are handled as inline code blocks (`TypesetCodeNode`) with literal content.
- Escapes are consumed before marker interpretation.
- Adjacent text fragments are coalesced to reduce node count.

### Error tolerance

The parser is intentionally permissive:

- Unclosed markers are emitted as literal text.
- Crossing delimiters are treated as text when ambiguous.

This keeps rendering stable for user-generated content.

## 2) AutoLink post-processing stage

Implementation: `typesetAutoLink`.

### Goal

Convert URL-like text in `TypesetTextNode` to `TypesetLinkNode`.

### Rules

- Detects `http://`, `https://`, and `www.` patterns.
- Normalizes `www.` to `https://...`.
- Trims trailing punctuation from URL matches.
- Validates links against `TypeSetAutoLinkConfig`:
  - `allowedSchemes`
  - optional `allowedDomains`
  - optional `customValidator`

### Safety behavior

- URLs inside existing links and inline code are not re-processed.
- If validation fails, original text is preserved.

## 3) Rendering stage

Implementation: `TypesetRenderer`.

### Mapping

- `TypesetTextNode` → plain `TextSpan`
- `TypesetCodeNode` → monospace `TextSpan`
- `TypesetStyleNode` → styled nested spans
- `TypesetLinkNode` → link-styled span, optional recognizer

### Editing mode

`TypeSetEditingController` uses renderer `showDelimiters: true` so markers stay visible while content remains styled.

### Link interaction model

- Link text can be styled without interaction.
- Tap/click is opt-in through `TypeSetAutoLinkConfig.linkRecognizerBuilder`.

## Complexity and scale characteristics

For input length $n$:

- Parse stage: approximately $O(n)$
- AutoLink stage: approximately $O(n)$ with regex scan + node rebuild
- Render stage: $O(m)$ where $m$ is AST node count

In practice, this is suitable for chat-like and feed-like message rendering.

## Configuration precedence

Effective config resolution:

1. Local `config` passed to widget/controller
2. `TypeSetConfigProvider` in widget tree
3. `TypeSetGlobalConfig.instance`
4. library defaults

This enables both simple adoption and controlled enterprise-wide behavior.
