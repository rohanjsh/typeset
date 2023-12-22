---

# TypeSet: Elegant Text Styling for Flutter
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![pub package][pub_badge]][pub_link]
![pub points][pub_points_badge]

Enhance your Flutter app's text presentation with TypeSet, the all-in-one solution for text styling and formatting that's as dynamic as your app needs to be. Inspired by familiar markdown formatting, TypeSet allows you to seamlessly integrate rich text features, including variable font sizes and web links, without disrupting the underlying logic of your code. With backend-driven formatting capability, WhatsApp-like ease, and additional formatting options, TypeSet offers the fluidity to make any text come alive!

## Preview of Possibilities

<img width="346" alt="Screenshot 2023-03-18 at 10 25 42" src="https://github.com/rohanjsh/typeset/assets/35066779/34c49da7-4a47-41a2-8af1-0f9d5a093689">

Craft the perfect user experience with customizable text that embraces bold, italic, strikethrough, underline, monospace, hyperlinks, and dynamic font sizes – all at your fingertips.

## Getting Started 🚀

To unleash the power of TypeSet in your Flutter application, ensure you have the Flutter SDK installed and up to date.

### Installation

In your `pubspec.yaml`, under dependencies, add the following line:

```yaml
dependencies:
  typeset: ^latest_version
```

Run the following command to install the package:

```shell
flutter packages get
```

### Usage 🌟

Utilize the TypeSet widget as easily as you would use the native `Text.rich()` in Flutter:

```dart
import 'package:typeset/typeset.dart';

// Bold Text Example
TypeSet(inputText: 'Hello, *World!*'); // Renders 'World!' in bold

// Italic Text Example
TypeSet(inputText: 'Hello, _World!_'); // Renders 'World!' in italic

// Strikethrough Text Example
TypeSet(inputText: 'Hello, ~World!~'); // Renders 'World!' with a strikethrough

// Underline Text Example
TypeSet(inputText: 'Hello #World!#'); // Renders 'World!' underlined

// Monospace Text Example
TypeSet(inputText: 'Hello, `World!`'); // Renders 'World!' in monospace

// Hyperlink Text Example
TypeSet(inputText: '§google.com|https://google.com§'); // Renders 'google.com' as a clickable link

// Dynamic Font Size Example
TypeSet(inputText: 'Hey, *Hello world<30>*'); // Renders 'Hello world' with font size 30
```

TypeSet inherits all properties of the `Text.rich()` widget, allowing for a familiar and versatile configuration experience.

## Features 🎨

- **Backend-driven formatting**: Keep your text styling logic server-side for easy updates without the need to redeploy your app.
- **Rich markdown-like formatting**: Easily implement bold, italic, strikethrough, underline, monospace, and hyperlinked text.
- **Dynamic font resizing**: Adjust text sizes on the fly for emphasis or accessibility.
- **Extensible**: Designed with openness for adding more styling options in future updates.

## We Value Your Feedback 📬

Have ideas for more features? Found a bug? Feel free to [open an issue][tracker] on our issue tracker. Your contributions make TypeSet better for everyone.

## Keep Your App's Text Styling Dynamic and Engaging with TypeSet!

---

Remember to include accurate links where necessary, like a link to the image of the demo snapshot, and the issue tracker. Also, replace the placeholder `^latest_version` with the actual latest version number of your package.


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
[build_badge]: https://img.shields.io/github/workflow/status/rohanjsh/typeset/ci.svg
[pub_points_badge]: https://img.shields.io/pub/points/typeset
