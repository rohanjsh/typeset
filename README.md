# TypeSet

[![License: MIT][license_badge]][license_link] 
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![pub package][pub_badge]][pub_link]
![Coverage Badge](coverage_badge.svg)

This supports the input from backend to be formatted with different formatters.
Text style that will support bold, italic and underline text coming from the server.
The implementation will be same as we see on WhatsApp.

i.e.
1. Bold Text will be wrapped in \*asterisk\*
2. Italic Text will be wrapped in \_underscore\_
3. Underline Text will be wrapped in \~tilde\~
4. Bold, Italic and Underline Text will be wrapped in \*asterisk\* \_underscore\_ \~tilt\~


### Preview
<img width="488" alt="Screenshot 2022-12-13 at 11 56 28" src="https://user-images.githubusercontent.com/35066779/207242541-c8bfd00e-0b81-47ce-9bf3-b280e3d63162.png">



## Installation 💻

**❗ In order to start using typeset you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

Add `typeset` to your `pubspec.yaml`:

```yaml
dependencies:
  typeset:
```

Install it:

```sh
flutter packages get
```

---


Usage

```dart
import 'package:typeset/typeset.dart';

TypeSet('Hello, *World!*');
// returns 'World' with bold text

TypeSet('Hello, _World_!');
// returns 'World' with italic text

TypeSet('Hello, ~World~!');
// returns 'World' with underline text

TypeSet('*Hello*, _World_ ~World~!');
// returns 'Hello' with bold text, 'World' with italic text and 'World' with underline text

//TypeSet also has a style property which can be used to style the text
TypeSet('Hello, *World!*', style: TextStyle(color: Colors.red));
// returns 'World' with bold text and red color
```


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[flutter_install_link]: https://docs.flutter.dev/get-started/install
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
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
[pub_badge]: https://img.shields.io/pub/v/very_good_performance.svg
[pub_link]: https://pub.dev/packages/typeset


