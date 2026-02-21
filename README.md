# TypeSet

[![pub package](https://img.shields.io/pub/v/typeset.svg)](https://pub.dev/packages/typeset)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![build status](https://img.shields.io/github/actions/workflow/status/rohanjsh/typeset/main.yaml)](https://github.com/rohanjsh/typeset/issues)

TypeSet is a Flutter text-formatting package for chat-style inline markup.

It is designed around two goals:

- **Plug-and-play adoption**: start with one widget.
- **Granular control**: tune rendering, linking, and editing behavior when needed.

## Why TypeSet

- Familiar inline formatting syntax.
- Works for backend-driven message rendering.
- Consistent API for display and editing.
- Configurable AutoLink policy for safer link handling.

## Install

```yaml
dependencies:
  typeset: ^3.0.0-beta.1
```

```bash
flutter pub get
```

> This is currently a pre-release build (`beta`). Use stable constraints for production once `3.0.0` is published.

## Quick start (plug-and-play)

```dart
import 'package:typeset/typeset.dart';

const TypeSet('Hello *world* from _TypeSet_.');
```

## Formatting syntax

| Style         | Syntax                 |
| ------------- | ---------------------- |
| Bold          | `*text*`               |
| Italic        | `_text_`               |
| Underline     | `__text__`             |
| Strikethrough | `~text~`               |
| Monospace     | `` `text` ``           |
| Escape        | `\*literal asterisk\*` |

> Note on link behavior:
>
> - Raw URLs such as `https://flutter.dev` and `www.example.com` are detected and rendered with link style when AutoLink is enabled.
> - Tap/click handling is opt-in through `TypeSetAutoLinkConfig.linkRecognizerBuilder`.
> - If no recognizer is provided, links are rendered as styled text without interaction.

## Under the hood

For parser/rendering internals and algorithm details, see [doc/UNDER_THE_HOOD.md](doc/UNDER_THE_HOOD.md).

## Custom configuration

TypeSet uses `TypeSetConfig` to centralize behavior.

```dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:typeset/typeset.dart';

final customConfig = TypeSetConfig(
  style: const TypeSetStyle(
    boldStyle: TextStyle(fontWeight: FontWeight.w900),
    italicStyle: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF6A1B9A)),
    underlineStyle: TextStyle(decorationThickness: 3),
    markerColor: Color(0xFF8D8D8D),
    linkStyle: TextStyle(
      color: Color(0xFF0B5FFF),
      decoration: TextDecoration.underline,
    ),
    monospaceStyle: TextStyle(
      fontFamily: 'Courier',
      backgroundColor: Color(0xFFEFF3FF),
    ),
  ),
  autoLinkConfig: TypeSetAutoLinkConfig(
    allowedSchemes: {'https'},
    allowedDomains: RegExp(r'^flutter\\.dev$'),
    linkRecognizerBuilder: (text, url) =>
        TapGestureRecognizer()..onTap = () {
          // Route the URL with your app's navigation/link strategy.
        },
  ),
);

TypeSet(
  'Read *docs* at https://flutter.dev',
  config: customConfig,
);
```

## Set defaults (scoped or app-wide)

TypeSet starts with `TypeSetConfig.defaults()`.

Use scoped defaults for part of the widget tree:

```dart
TypeSetConfigProvider(
  config: TypeSetConfig.defaults().copyWith(
    autoLinkConfig: TypeSetAutoLinkConfig.httpsOnly,
  ),
  child: const TypeSet('Visit https://dart.dev'),
);
```

You can also set global defaults at app startup:

```dart
TypeSetGlobalConfig.instance = TypeSetConfig.defaults();
```

`TypeSet(config: ...)` and `TypeSetEditingController(config: ...)` always allow per-usage overrides when needed.

## Editing experience

Use `TypeSetEditingController` for real-time formatted previews in `TextField`.

```dart
final controller = TypeSetEditingController(
  text: 'Use *bold* and __underline__',
  config: TypeSetConfig(
    style: const TypeSetStyle(markerColor: Color(0xFF9E9E9E)),
  ),
);
```

Add context menu actions:

```dart
TextField(
  controller: controller,
  contextMenuBuilder: (context, editableTextState) {
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: [
        ...getTypesetContextMenus(
          editableTextState: editableTextState,
          styleTypes: const [
            StyleTypeEnum.bold,
            StyleTypeEnum.italic,
            StyleTypeEnum.underline,
          ],
        ),
        ...editableTextState.contextMenuButtonItems,
      ],
    );
  },
)
```

## Migration

Version `3.0.0` includes breaking changes.

- Read [MIGRATION.md](MIGRATION.md)
- Review [CHANGELOG.md](CHANGELOG.md)

## Example app

Run the package example:

```bash
cd example
flutter run
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution and release guidelines.

## License

Apache-2.0. See [LICENSE](LICENSE).
