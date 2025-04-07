import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:typeset/src/core/typeset_controller.dart';
import 'package:typeset/src/models/style_type_enum.dart';
import 'package:typeset/typeset.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

///[TypesetParser]
class TypesetParser {
  /// Parses the input text and generates a list of [TextSpan] objects based on
  /// different styles and formatting options.
  ///
  /// The [parser] method takes in several input parameters and returns a list
  /// of [TextSpan] objects. It uses a [TypesetController] to manipulate the
  /// input text and generate the [TextSpan] objects based on different styles
  /// and formatting options.
  ///
  /// Example Usage:
  /// ```dart
  /// final inputText = "This is *bold* and _italic_ text with a [link|https://example.com].";
  /// final spans = TypesetParser.parser(
  ///   inputText: inputText,
  ///   linkStyle: TextStyle(color: Colors.red),
  ///   recognizer: TapGestureRecognizer()..onTap = () => print("Link tapped!"),
  ///   monospaceStyle: TextStyle(fontFamily: 'Courier'),
  /// );
  /// ```
  /// The above code snippet demonstrates how to use the [parser] method to
  /// parse an input text and generate a list of [TextSpan] objects.
  /// It sets a custom link style, a tap gesture recognizer, and a
  /// monospace style. The resulting [TextSpan]s list can be used to display
  /// the formatted text in a Flutter application.
  ///
  /// Inputs:
  /// - [inputText] (required): A string represents the input text to be parsed.
  /// - [linkStyle] (optional): A [TextStyle] object represents the style
  ///   to be applied to link text.
  /// - [linkRecognizerBuilder] (optional): A [GestureRecognizer] object
  ///   representing the tap gesture recognizer for links.
  /// - [monospaceStyle] (optional): A [TextStyle] object representing
  ///   the style to be applied to monospace text.
  ///
  /// Flow:
  /// 1. The method initializes an empty list to store the generated
  ///    [TextSpan] objects.
  /// 2. It creates a [TypesetController] instance using the
  ///    provided [inputText].
  /// 3. It iterates over each object returned by the `manipulateString`
  ///    method of the [TypesetController].
  /// 4. For each object, it checks the `type` property to determine the
  ///    style of the text.
  /// 5. If the text is a link, it splits the `value` property using the
  ///    '|' separator to extract the link text and URL.
  /// 6. It creates a [TextSpan] with the appropriate style and
  ///    adds it to the list.
  /// 7. If the text is monospace, it creates a [TextSpan] with the
  ///    monospace style and adds it to the list.
  /// 8. If the text has other styles (bold, italic, strikethrough, underline),
  ///    it creates a [TextSpan] with the corresponding style and
  ///    adds it to the list.
  /// 9. Finally, it returns the list containing all the generated
  ///    [TextSpan] objects.
  ///
  /// Outputs:
  /// - A list of [TextSpan] objects representing the parsed and formatted text
  ///   based on the input parameters.
  static List<TextSpan> parser({
    required String inputText,
    TextStyle? linkStyle,
    GestureRecognizer Function(String text, String url)? linkRecognizerBuilder,
    TextStyle? monospaceStyle,
    TextStyle? boldStyle,
  }) {
    final controller = TypesetController(
      input: inputText,
    );
    final spans = <TextSpan>[];

    for (final text in controller.manipulateString()) {
      final regex = RegExp(TypesetReserved.fontSizeRegex);
      final match = regex.firstMatch(text.value);
      final justText = match?.group(1) ?? text.value;
      final fontSize =
          match == null ? null : double.tryParse(match.group(2) ?? '');

      switch (text.styleType) {
        case StyleTypeEnum.link:
          final linkData = text.value.split(TypesetReserved.linkSplitChar);
          final linkText = linkData.isNotEmpty ? linkData[0] : '';
          final url = linkData.length == 2 ? linkData[1] : '';
          spans.add(
            TextSpan(
              text: fontSize != null ? justText : linkText,
              style: linkStyle?.copyWith(
                    fontSize: fontSize,
                  ) ??
                  TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: fontSize,
                    decorationColor: Colors.blue,
                  ),
              recognizer: linkRecognizerBuilder?.call(linkText, url) ??
                  (url.isNotEmpty ? _launch(url) : null),
            ),
          );
          break;
        case StyleTypeEnum.monospace:
          spans.add(
            TextSpan(
              text: justText,
              style: monospaceStyle ??
                  const TextStyle(
                    fontFamily: 'Courier',
                  ),
            ),
          );
          break;

        case StyleTypeEnum.bold:
          spans.add(
            TextSpan(
              text: justText,
              style: boldStyle?.copyWith(
                    fontSize: fontSize,
                  ) ??
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
            ),
          );
          break;
        // ignore: no_default_cases
        default:
          spans.add(
            TextSpan(
              text: justText,
              style: TextStyle(
                fontStyle: text.styleType == StyleTypeEnum.italic
                    ? FontStyle.italic
                    : null,
                decoration: text.styleType == StyleTypeEnum.strikethrough
                    ? TextDecoration.lineThrough
                    : text.styleType == StyleTypeEnum.underline
                        ? TextDecoration.underline
                        : null,
                fontSize: fontSize,
              ),
            ),
          );
      }
    }
    return spans;
  }

  /// Creates a [TapGestureRecognizer] that launches the given URL when tapped
  ///
  /// If the URL cannot be launched, it will print a debug message
  static TapGestureRecognizer _launch(String url) {
    return TapGestureRecognizer()
      ..onTap = () async {
        final uri = Uri.tryParse(url);
        if (uri != null) {
          try {
            if (await launcher.canLaunchUrl(uri)) {
              await launcher.launchUrl(uri);
            } else {
              debugPrint('Could not launch URL: $url');
            }
          } catch (e) {
            debugPrint('Error launching URL: $e');
          }
        } else {
          debugPrint('Invalid URL: $url');
        }
      };
  }
}
