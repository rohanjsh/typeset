import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:typeset/src/core/type_controller.dart';
import 'package:typeset/src/models/style_type_enum.dart';
import 'package:url_launcher/url_launcher.dart';

///[TypesetParser]
class TypesetParser {
  static const _kBoldChar = '*';

  static const _kItalicChar = '_';

  static const _kStrikeThroughChar = '~';

  static const _kUnderlineChar = '//';

  static const _kMonoSpaceChar = '`';

  static const _kLinkStartChar = '[';

  static const _kLinkEndChar = ']';

  static const _kLinkUrlSeparator = '|';

  static const _kSpace = ' ';

  static const _kEmpty = '';

  ///[parseText] this method will parse the [inputText] and
  ///return a list of [TextSpan] with the correct styles applied to it
  @Deprecated('parseText will be removed in upcoming versions, use parser')
  static List<TextSpan> parseText({
    required String inputText,
    TextStyle? linkStyle,
    GestureRecognizer? recognizer,
    TextStyle? monospaceStyle,
  }) {
    final words = inputText.split(_kSpace);
    return words.asMap().entries.map<TextSpan>(
      (entry) {
        final index = entry.key;
        final word = entry.value;

        if (_isLink(word)) {
          return _getLinkSpan(
            word: word,
            linkStyle: linkStyle,
            recognizer: recognizer,
          );
        }

        final style = _getStyle(
          word,
          monospaceStyle: monospaceStyle,
        );
        final text = _getText(word, style);
        final space = index == words.length - 1 ? _kEmpty : _kSpace;

        return TextSpan(
          text: '$text$space',
          style: style,
        );
      },
    ).toList();
  }

  //*for link
  static bool _isLink(String word) {
    return word.startsWith(_kLinkStartChar) &&
        word.endsWith(_kLinkEndChar) &&
        word.contains(_kLinkUrlSeparator) &&
        word.length > 3;
  }

  static TextSpan _getLinkSpan({
    required String word,
    TextStyle? linkStyle,
    GestureRecognizer? recognizer,
  }) {
    if (word.length < 3 || !word.startsWith('[') || !word.endsWith(']')) {
      // The word is not a valid link, return a plain text span.
      return TextSpan(text: word);
    }
    final linkParts =
        word.substring(1, word.length - 1).split(_kLinkUrlSeparator);
    final linkText = linkParts[0];
    final linkUrl = linkParts[1];

    return TextSpan(
      text: linkText,
      style: linkStyle ??
          const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
      recognizer: recognizer ??
          (TapGestureRecognizer()
            ..onTap = () async {
              if (await canLaunchUrl(
                Uri.parse(linkUrl),
              )) {
                await launchUrl(
                  Uri.parse(linkUrl),
                );
              }
            }),
    );
  }

  //* for other styles
  static TextStyle _getStyle(String word, {TextStyle? monospaceStyle}) {
    final hasBold = word.startsWith(_kBoldChar) &&
        word.endsWith(_kBoldChar) &&
        word.length > 1;
    final hasItalic = word.startsWith(_kItalicChar) &&
        word.endsWith(_kItalicChar) &&
        word.length > 1;
    final hasStrikeThrough = word.startsWith(_kStrikeThroughChar) &&
        word.endsWith(_kStrikeThroughChar) &&
        word.length > 1;
    final hasUnderline = word.startsWith(_kUnderlineChar) &&
        word.endsWith(_kUnderlineChar) &&
        word.length > 3;
    final hasMonoSpace = word.startsWith(_kMonoSpaceChar) &&
        word.endsWith(_kMonoSpaceChar) &&
        word.length > 1;

    if (hasMonoSpace) {
      return monospaceStyle ??
          GoogleFonts.sourceCodePro(
            textStyle: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          );
    }

    return TextStyle(
      fontWeight: hasBold ? FontWeight.bold : null,
      fontStyle: hasItalic ? FontStyle.italic : null,
      decoration: hasStrikeThrough
          ? TextDecoration.lineThrough
          : hasUnderline
              ? TextDecoration.underline
              : null,
    );
  }

  static String _getText(String word, TextStyle style) {
    if (style.fontWeight != null ||
        style.fontStyle != null ||
        style.decoration != null) {
      if (style.decoration == TextDecoration.underline) {
        return word.substring(2, word.length - 2);
      } else {
        return word.substring(1, word.length - 1);
      }
    } else {
      return word;
    }
  }

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
  /// - [recognizer] (optional): A [GestureRecognizer] object representing
  ///   the tap gesture recognizer for links.
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
    GestureRecognizer? recognizer,
    TextStyle? monospaceStyle,
  }) {
    final controller = TypesetController(
      input: inputText,
    );
    final spans = <TextSpan>[];

    for (final text in controller.manipulateString()) {
      final regex = RegExp(r'(.+?)<(\d+)>');
      final match = regex.firstMatch(text.value);
      final justText = match?.group(1) ?? text.value;
      final fontSize =
          match == null ? null : double.tryParse(match.group(2) ?? '');

      switch (text.type) {
        case StyleTypeEnum.link:
          final linkData = text.value.split('|');
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
              recognizer: recognizer ??
                  (TapGestureRecognizer()..onTap = () => _launchUrl(url)),
            ),
          );
          break;
        case StyleTypeEnum.monospace:
          spans.add(
            TextSpan(
              text: justText,
              style: monospaceStyle ??
                  GoogleFonts.sourceCodePro(
                    textStyle: TextStyle(fontSize: fontSize),
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
                fontWeight:
                    text.type == StyleTypeEnum.bold ? FontWeight.bold : null,
                fontStyle:
                    text.type == StyleTypeEnum.italic ? FontStyle.italic : null,
                decoration: text.type == StyleTypeEnum.strikethrough
                    ? TextDecoration.lineThrough
                    : text.type == StyleTypeEnum.underline
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

  static Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
