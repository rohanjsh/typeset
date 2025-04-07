---

<div align="center">

# ✨ TypeSet ✨
### Powerful Text Styling for Flutter

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![pub package][pub_badge]][pub_link]
![pub points][pub_points_badge]
[![build status][build_badge]][tracker]

</div>

## Transform Your Text Experience

TypeSet brings WhatsApp, Telegram-like text styling to your Flutter apps with a powerful twist. Create rich, dynamic text experiences that can be driven by your backend or controlled directly in your UI.

With TypeSet, you can seamlessly integrate **bold**, _italic_, ~~strikethrough~~, underlined text, `monospace`, hyperlinks, and even dynamic font sizing without complex widgets or convoluted styling code.

## 📱 See It In Action

<table align="center">
  <tr>
    <th>TypeSet Widget</th>
    <th>TypeSetEditingController</th>
  </tr>
  <tr>
    <td>
      <img width="346" alt="TypeSet Widget" src="https://github.com/user-attachments/assets/a0f9695d-5735-426d-9f66-5e7e991791fa">
    </td>
    <td>
      <img width="346" alt="TypeSetEditingController" src="https://github.com/user-attachments/assets/6ecc0930-c38f-4253-807c-c8fcd8fb6482">
    </td>
  </tr>
</table>

Craft the perfect user experience with text styling that feels natural to your users. TypeSet makes it easy to implement rich text features that would otherwise require complex custom solutions.

## 🚀 Getting Started

### Installation

Add TypeSet to your project by including it in your `pubspec.yaml`:

```yaml
dependencies:
  typeset: ^2.3.0  # Check pub.dev for the latest version
```

Then run:

```shell
flutter pub get
```

## 💎 Usage

TypeSet is designed to be as simple as using Flutter's built-in `Text` widget:

```dart
import 'package:typeset/typeset.dart';

// Just drop in your formatted text
TypeSet('Hello *Flutter* developers!');
```

### Text Formatting Syntax

| Style | Syntax | Result |
|-------|--------|--------|
| **Bold** | `*text*` | **text** |
| _Italic_ | `_text_` | _text_ |
| ~~Strikethrough~~ | `~text~` | ~~text~~ |
| Underline | `#text#` | <ins>text</ins> |
| `Monospace` | `` `text` `` | `text` |
| [Link](https://flutter.dev) | `§Link text\|https://url§` | [Link text](https://url) |
| Font Size | `text<size>` | Renders text at specified size |

### Advanced Examples

```dart
// Hyperlink with custom tap action
TypeSet(
  '§Visit Flutter\|https://flutter.dev§',
  linkRecognizerBuilder: (linkText, url) =>
    TapGestureRecognizer()..onTap = () {
      // Your custom action here
    },
);

// Dynamic font sizing
TypeSet('Regular text with *bigger<24>* words');

// Escape formatting characters
TypeSet('Use the ¦* symbol to show *asterisks*');
```

## 💬 Interactive Text Editing

### TypeSetEditingController

New in v2.3.0! Add WhatsApp-like styling to your text input fields with real-time formatting preview:

```dart
import 'package:typeset/typeset.dart';
import 'package:flutter/material.dart';

// Create a controller with optional styling parameters
final controller = TypeSetEditingController(
  // Initial text with formatting
  text: 'This is *bold* and _italic_',
  // Style for the formatting markers
  markerColor: Colors.grey.shade400,
  // Style for links
  linkStyle: const TextStyle(color: Colors.blue),
  // Style for bold text
  boldStyle: const TextStyle(fontWeight: FontWeight.bold),
  // Style for monospace text
  monospaceStyle: const TextStyle(fontFamily: 'Courier'),
);

// Use it with a TextField
TextField(
  controller: controller,
  maxLines: 3,
  decoration: const InputDecoration(
    border: OutlineInputBorder(),
    hintText: 'Type formatted text here...',
  ),
);
```

### Context Menu Integration

Add formatting options to the text selection context menu with `getTypesetContextMenus()`:

```dart
import 'package:typeset/typeset.dart';
import 'package:flutter/material.dart';

TextField(
  controller: TypeSetEditingController(),
  contextMenuBuilder: (context, editableTextState) {
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: [
        // Add TypeSet formatting options to the context menu
        ...getTypesetContextMenus(
          editableTextState: editableTextState,
          // Optional: specify which formatting options to include
          // styleTypes: [StyleTypeEnum.bold, StyleTypeEnum.italic],
        ),
        // Keep the default context menu items
        ...editableTextState.contextMenuButtonItems,
      ],
    );
  },
);
```

This adds formatting buttons (Bold, Italic, Strikethrough, etc.) to the text selection menu, allowing users to easily format selected text.
## ✨ Key Features

- **WhatsApp-like Formatting** - Familiar syntax that users already understand
- **Backend-driven Styling** - Update text formatting from your server without app updates
- **TypeSetEditingController** - Add rich text capabilities to input fields
- **Dynamic Font Sizing** - Adjust text size inline for emphasis or hierarchy
- **Context Menus** - Built-in support for copy/paste with formatting
- **Highly Customizable** - Style each formatting type independently
- **Lightweight** - Minimal dependencies for a smaller app footprint
- **Well-tested** - 95%+ test coverage for production reliability

## 🤝 Community & Support

- **[GitHub Issues][tracker]** - Report bugs or request features
- **[GitHub Discussions](https://github.com/rohanjsh/typeset/discussions)** - Get help and share ideas
- **[Pub.dev Documentation][pub_link]** - Detailed API documentation

### Contributing

Contributions are welcome! Check out our [contribution guidelines](https://github.com/rohanjsh/typeset/blob/main/CONTRIBUTING.md) to get started.

### Support the Project

If TypeSet has been helpful for your projects, consider:
- ⭐ Starring the repository
- 🔄 Sharing with other developers
- 💬 Providing feedback and suggestions
- 🐛 Reporting bugs and issues

## 📝 License

TypeSet is available under the [Apache License, Version 2.0](https://github.com/rohanjsh/typeset/blob/main/LICENSE).

---


[flutter_install_link]: https://docs.flutter.dev/get-started/install
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://pub.dev/packages/very_good_cli
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
[tracker]: https://github.com/rohanjsh/typeset/issues
[pub_badge]: https://img.shields.io/pub/v/typeset.svg
[pub_link]: https://pub.dev/packages/typeset
[coverage_badge]: /coverage_badge.svg
[build_badge]: https://img.shields.io/github/actions/workflow/status/rohanjsh/typeset/main.yaml
[pub_points_badge]: https://img.shields.io/pub/points/typeset
