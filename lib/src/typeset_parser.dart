import 'package:flutter/widgets.dart';

///[TypesetParserUtil] is a class that parses a string of typeset code into
///a list of TextSpans using [parseText].
class TypesetParserUtil {
  /// Parses a string of typeset code into a list of TextSpans.
  static List<TextSpan> parseText(String inputText) {
    final parts = inputText.split('\n');
    final spans = <TextSpan>[];

    for (final part in parts) {
      final words = part.split(' ');

      final wordSpans = words.asMap().entries.map<TextSpan>((entry) {
        final index = entry.key;
        final word = entry.value;

        final hasBold =
            word.startsWith('*') && word.endsWith('*') && word.length > 1;
        final hasItalic =
            word.startsWith('_') && word.endsWith('_') && word.length > 1;
        final hasUnderline =
            word.startsWith('~') && word.endsWith('~') && word.length > 1;

        final style = TextStyle(
          fontWeight: hasBold ? FontWeight.bold : null,
          fontStyle: hasItalic ? FontStyle.italic : null,
          decoration: hasUnderline ? TextDecoration.underline : null,
        );

        final text = (hasBold || hasItalic || hasUnderline)
            ? word.substring(1, word.length - 1)
            : word;
        final space = index == words.length - 1 ? '' : ' ';
        debugPrint(
          '$text$space',
        );
        return TextSpan(
          text: '$text$space',
          style: style,
        );
      });

      spans.add(TextSpan(children: [...wordSpans], text: '\n'));
    }

    return spans;
  }
}
