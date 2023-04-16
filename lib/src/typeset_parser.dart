import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

///[TypesetParser] is a class that parses a string of typeset code into
///a list of TextSpans using [parseText].
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
  static List<TextSpan> parseText(String inputText) {
    return _getWordSpans(inputText);
  }

  static List<TextSpan> _getWordSpans(String part) {
    final words = part.split(_kSpace);
    return words.asMap().entries.map<TextSpan>(
      (entry) {
        final index = entry.key;
        final word = entry.value;

        if (_isLink(word)) {
          return _getLinkSpan(word);
        }

        final style = _getStyle(word);
        final text = _getText(word, style);
        final space = index == words.length - 1 ? _kEmpty : _kSpace;

        return TextSpan(
          text: '$text$space',
          style: style,
        );
      },
    ).toList();
  }

  static bool _isLink(String word) {
    return word.startsWith(_kLinkStartChar) &&
        word.endsWith(_kLinkEndChar) &&
        word.contains(_kLinkUrlSeparator) &&
        word.length > 3;
  }

  static TextSpan _getLinkSpan(String word) {
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
      return GoogleFonts.sourceCodePro(
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
}
