import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

///[TypesetParser] is a class that parses a string of typeset code into
///a list of TextSpans using [parseText].
class TypesetParser {
  ///[kBoldChar] is the character that will be used to wrap bold text
  static const kBoldChar = '*';

  ///[kItalicChar] is the character that will be used to wrap italic text
  static const kItalicChar = '_';

  ///[kStrikeThroughChar] is the character that will be used
  ///to wrap strikethrough text
  static const kStrikeThroughChar = '~';

  ///[kUnderlineChar] is the character that will be used to wrap underline text
  static const kUnderlineChar = '//';

  ///[kLinkStartChar] is the character that will be used to wrap link text start
  static const kLinkStartChar = '[';

  ///[kLinkEndChar] is the character that will be used to wrap link text end
  static const kLinkEndChar = ']';

  ///[kLinkUrlSeparator] is the character that will be used to
  ///separate link text and url
  static const kLinkUrlSeparator = '|';

  ///[kSpace] is the character that will be used to separate words
  static const kSpace = ' ';

  ///[kEmpty] is the character that will be used to represent empty string
  static const kEmpty = '';

  ///[parseText] this method will parse the [inputText] and
  ///return a list of [TextSpan] with the correct styles applied to it
  static List<TextSpan> parseText(String inputText) {
    return _getWordSpans(inputText);
  }

  static List<TextSpan> _getWordSpans(String part) {
    final words = part.split(kSpace);
    return words.asMap().entries.map<TextSpan>(
      (entry) {
        final index = entry.key;
        final word = entry.value;

        if (_isLink(word)) {
          return _getLinkSpan(word);
        }

        final style = _getStyle(word);
        final text = _getText(word, style);
        final space = index == words.length - 1 ? kEmpty : kSpace;

        return TextSpan(
          text: '$text$space',
          style: style,
        );
      },
    ).toList();
  }

  static bool _isLink(String word) {
    return word.startsWith(kLinkStartChar) &&
        word.endsWith(kLinkEndChar) &&
        word.contains(kLinkUrlSeparator) &&
        word.length > 3;
  }

  static TextSpan _getLinkSpan(String word) {
    final linkParts =
        word.substring(1, word.length - 1).split(kLinkUrlSeparator);
    final linkText = linkParts[0];
    final linkUrl = linkParts[1];

    return TextSpan(
      text: '$linkText$kSpace',
      style: const TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () async {
          if (await canLaunchUrl(
            Uri.parse(linkUrl),
          )) {
            await launchUrl(
              Uri.parse(linkUrl),
            );
          }
        },
    );
  }

  static TextStyle _getStyle(String word) {
    final hasBold = word.startsWith(kBoldChar) &&
        word.endsWith(kBoldChar) &&
        word.length > 1;
    final hasItalic = word.startsWith(kItalicChar) &&
        word.endsWith(kItalicChar) &&
        word.length > 1;
    final hasStrikeThrough = word.startsWith(kStrikeThroughChar) &&
        word.endsWith(kStrikeThroughChar) &&
        word.length > 1;
    final hasUnderline = word.startsWith(kUnderlineChar) &&
        word.endsWith(kUnderlineChar) &&
        word.length > 3;

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
}
