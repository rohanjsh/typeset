<div align="center">

# ✨ TypeSet

**Chat-style inline text formatting for Flutter**

[![pub package](https://img.shields.io/pub/v/typeset.svg)](https://pub.dev/packages/typeset)
![pub points](https://img.shields.io/pub/points/typeset)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![build status](https://img.shields.io/github/actions/workflow/status/rohanjsh/typeset/main.yaml)](https://github.com/rohanjsh/typeset/issues)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://github.com/rohanjsh/typeset/blob/main/LICENSE)

[Getting Started](#-getting-started) · [Usage](#-usage) · [Configuration](#%EF%B8%8F-configuration) · [Editing](#-editing) · [Migration](MIGRATION.md)

</div>

---

## 📖 Overview

TypeSet brings **WhatsApp / Telegram-style** inline formatting to Flutter with two design goals:

| Goal                 | What it means                                                       |
| -------------------- | ------------------------------------------------------------------- |
| **Plug-and-play**    | Drop in one widget — zero config needed                             |
| **Granular control** | Tune styles, AutoLink policy, and editing behavior when you need it |

### Why TypeSet?

- 🔤 Familiar `*bold*` / `_italic_` syntax users already know
- 🌐 Backend-driven — style text from your server without app updates
- 🔗 Configurable **AutoLink** with scheme & domain allowlists
- ✏️ Real-time editing preview via `TypeSetEditingController`
- 🎨 Theme-aware styles with `TypeSetStyle.fromTheme()`
- ⚡ AST-based parser with LRU document caching
- 🧪 95%+ test coverage

---

## 📱 Preview

<!-- TODO: Replace with your own demo video / GIF / screenshots -->

<div align="center">

https://github.com/user-attachments/assets/8318ffb6-662f-404c-9862-bd31cdd3fb7c
</div>

---

## 🚀 Getting Started

### Installation

```yaml
dependencies:
  typeset: ^3.0.0
```

```bash
flutter pub get
```

### Minimum Requirements

| Requirement | Version          |
| ----------- | ---------------- |
| Dart SDK    | `>=3.0.0 <4.0.0` |
| Flutter     | `>=3.10.0`       |

> **Coming from v2.x?** See the [Migration Guide](MIGRATION.md) for step-by-step upgrade instructions.

---

## 💡 Usage

### Quick Start

```dart
import 'package:typeset/typeset.dart';

// That's it — one widget, zero config
const TypeSet('Hello *world* from _TypeSet_.');
```

### Formatting Syntax

| Style                | Syntax        | Output          |
| -------------------- | ------------- | --------------- |
| **Bold**             | `*text*`      | **text**        |
| _Italic_             | `_text_`      | _text_          |
| <ins>Underline</ins> | `__text__`    | <ins>text</ins> |
| ~~Strikethrough~~    | `~text~`      | ~~text~~        |
| `Monospace`          | `` `text` ``  | `text`          |
| Escape               | `\*literal\*` | \*literal\*     |

### AutoLink (URL Detection)

Raw URLs like `https://flutter.dev` and `www.example.com` are **automatically detected** and rendered as links when AutoLink is enabled (default).

> [!NOTE]
>
> - Tap handling is **opt-in** via `TypeSetAutoLinkConfig.linkRecognizerBuilder`.
> - Without a recognizer, links are styled but not interactive.
> - AutoLink respects `allowedSchemes` and `allowedDomains` for safety.

### String Extension

```dart
// Use the .typeset() extension for inline usage
'Hello *world*'.typeset(style: myTextStyle);

// Extract plain text (markers removed)
final plain = 'Hello *world*'.plainText; // "Hello world"
```

---

## ⚙️ Configuration

TypeSet uses a layered config system with clear precedence:

```
Local config  →  Scoped provider  →  Global config  →  Library defaults
(highest priority)                                      (lowest priority)
```

### `TypeSetConfig`

Centralizes all style and AutoLink behavior:

```dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:typeset/typeset.dart';

final config = TypeSetConfig(
  style: const TypeSetStyle(
    boldStyle: TextStyle(fontWeight: FontWeight.w900),
    italicStyle: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF6A1B9A)),
    underlineStyle: TextStyle(decorationThickness: 3),
    monospaceStyle: TextStyle(fontFamily: 'Courier', backgroundColor: Color(0xFFEFF3FF)),
    linkStyle: TextStyle(color: Color(0xFF0B5FFF), decoration: TextDecoration.underline),
    markerColor: Color(0xFF8D8D8D),
  ),
  autoLinkConfig: TypeSetAutoLinkConfig(
    allowedSchemes: {'https'},
    allowedDomains: RegExp(r'^flutter\.dev$'),
    linkRecognizerBuilder: (text, url) =>
        TapGestureRecognizer()..onTap = () => launchUrl(Uri.parse(url)),
  ),
);

TypeSet('Read *docs* at https://flutter.dev', config: config);
```

### Theme-Aware Styles

```dart
// Automatically adapts to your app's ColorScheme
final style = TypeSetStyle.fromTheme(Theme.of(context));
```

<details>
<summary><strong>📋 Full <code>TypeSetStyle</code> properties</strong></summary>

| Property             | Type         | Description                                 |
| -------------------- | ------------ | ------------------------------------------- |
| `boldStyle`          | `TextStyle?` | Style for `*bold*` text                     |
| `italicStyle`        | `TextStyle?` | Style for `_italic_` text                   |
| `underlineStyle`     | `TextStyle?` | Style for `__underline__` text              |
| `strikethroughStyle` | `TextStyle?` | Style for `~strikethrough~` text            |
| `linkStyle`          | `TextStyle?` | Style for AutoLinked URLs                   |
| `monospaceStyle`     | `TextStyle?` | Style for `` `code` `` text                 |
| `markerColor`        | `Color?`     | Color for formatting markers (editing mode) |

</details>

<details>
<summary><strong>🔗 Full <code>TypeSetAutoLinkConfig</code> properties</strong></summary>

| Property                | Type                                          | Description                                        |
| ----------------------- | --------------------------------------------- | -------------------------------------------------- |
| `allowedSchemes`        | `Set<String>?`                                | Allowed URL schemes (default: `{'http', 'https'}`) |
| `allowedDomains`        | `RegExp?`                                     | Regex filter for allowed hostnames                 |
| `customValidator`       | `bool Function(Uri)?`                         | Additional URI validation callback                 |
| `linkRecognizerBuilder` | `GestureRecognizer Function(String, String)?` | Builds a recognizer for each link                  |

**Presets:**

| Preset                            | Description           |
| --------------------------------- | --------------------- |
| `TypeSetAutoLinkConfig.httpsOnly` | Only `https` links    |
| `TypeSetAutoLinkConfig.disabled`  | No AutoLink detection |

</details>

### Scoped Configuration

Apply config to a subtree using `TypeSetConfigProvider`:

```dart
TypeSetConfigProvider(
  config: TypeSetConfig.defaults().copyWith(
    autoLinkConfig: TypeSetAutoLinkConfig.httpsOnly,
  ),
  child: const TypeSet('Visit https://dart.dev'),
);
```

### Global Configuration

Set app-wide defaults at startup:

```dart
void main() {
  TypeSetGlobalConfig.current = TypeSetConfig(
    autoLinkConfig: TypeSetAutoLinkConfig.httpsOnly,
  );
  runApp(const MyApp());
}
```

> [!TIP]
> Per-widget `config:` always takes the highest priority, so you can override any default locally.

---

## ✏️ Editing

### `TypeSetEditingController`

Drop-in replacement for `TextEditingController` with live formatting preview:

```dart
final controller = TypeSetEditingController(
  text: 'Use *bold* and __underline__',
  config: TypeSetConfig(
    style: const TypeSetStyle(markerColor: Color(0xFF9E9E9E)),
  ),
);

TextField(
  controller: controller,
  maxLines: 5,
  decoration: const InputDecoration(
    border: OutlineInputBorder(),
    hintText: 'Type formatted text…',
  ),
);
```

> [!NOTE]
> Live formatting automatically disables when text exceeds `maxLiveFormattingLength` (default: 5000 chars) to prevent UI jank.

### Context Menu Integration

Add formatting buttons to the text selection toolbar:

```dart
TextField(
  controller: controller,
  contextMenuBuilder: (context, editableTextState) {
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: [
        ...getTypesetContextMenus(
          editableTextState: editableTextState,
          actions: [
            TypesetFormatAction.bold,
            TypesetFormatAction.italic,
            TypesetFormatAction.underline,
          ],
        ),
        ...editableTextState.contextMenuButtonItems,
      ],
    );
  },
);
```

<details>
<summary><strong>Available <code>TypesetFormatAction</code> values</strong></summary>

| Action          | Wraps with   |
| --------------- | ------------ |
| `bold`          | `*text*`     |
| `italic`        | `_text_`     |
| `strikethrough` | `~text~`     |
| `monospace`     | `` `text` `` |
| `underline`     | `__text__`   |

</details>

---

## 🏗️ Architecture

<details>
<summary><strong>Parser pipeline (under the hood)</strong></summary>

TypeSet uses a deterministic **3-stage pipeline**:

```
Input string  →  Parser (AST)  →  AutoLink pass  →  Renderer (InlineSpans)
```

1. **Parse** — Single left-to-right pass with a frame stack → typed AST nodes
2. **AutoLink** — Transforms URL-like text nodes into link nodes (config-driven)
3. **Render** — Maps AST nodes to Flutter `InlineSpan`s

**Performance:** ~O(n) for all stages. An LRU cache (`TypeSetDocumentCache`) avoids re-parsing identical inputs.

For full details, see [`doc/UNDER_THE_HOOD.md`](doc/UNDER_THE_HOOD.md).

</details>

---

## 🔄 Migration from v2.x

Version `3.0.0` includes breaking changes. The upgrade is straightforward — see the full guide:

👉 **[MIGRATION.md](MIGRATION.md)** — step-by-step instructions with before/after code

Quick summary of what changed:

| Area               | v2.x                                              | v3.0                                    |
| ------------------ | ------------------------------------------------- | --------------------------------------- |
| Underline syntax   | `#text#`                                          | `__text__`                              |
| Escape character   | `¦` (broken bar)                                  | `\` (backslash)                         |
| Widget styling     | Individual params (`linkStyle`, `boldStyle`, …)   | `TypeSetConfig` object                  |
| Controller styling | Individual params (`markerColor`, `linkStyle`, …) | `TypeSetConfig` object                  |
| Link syntax        | `§text\|url§` (explicit marker)                   | AutoLink detection (URLs auto-detected) |
| Context menu link  | `StyleTypeEnum.link`                              | Removed (use AutoLink instead)          |
| Font size syntax   | `text<24>`                                        | Removed                                 |
| Dependency         | `url_launcher` required                           | No external dependencies                |
| Config scope       | Per-widget only                                   | Global → Scoped → Local cascade         |

---

## 📂 Example App

```bash
cd example
flutter run
```

---

## 🤝 Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

- 🐛 [Report a bug](https://github.com/rohanjsh/typeset/issues/new)
- 💡 [Request a feature](https://github.com/rohanjsh/typeset/issues/new)
- 💬 [Discussions](https://github.com/rohanjsh/typeset/discussions)

---

## 📝 License

Apache-2.0 — see [LICENSE](LICENSE).
