/// {@template typeset}
/// This supports the input from backend to be formatted with different formats.
/// As seen in WhatsApp, Bold, Italic, Underline
/// {@endtemplate}
import 'package:flutter/widgets.dart';
//Text style that will support bold, italic and underline
//text coming from the server
//The implementation will be same as we see on WhatsApp

//i.e.
//1. Bold Text will be wrapped in *asterisk*
//2. Italic Text will be wrapped in _underscore_
//3. Underline Text will be wrapped in ~tilde~
//4. Bold, Italic and Underline Text will be
//wrapped in *asterisk* _underscore_ ~tilde~

///Current Regex
/// The first part of the regular expression, ([*_~]), is a capture group that
/// matches any of the three characters: *, _, or ~. This means that the
/// regular expression will match any of these three characters at the
/// beginning of the string.
///
///
///
/// The second part of the regular expression, (.*?), is another capture group
/// that matches any character (except a newline) zero or more times.
/// This capture group is followed by a ?, which specifies
/// that the preceding group is non-greedy, meaning that
/// it will match as few characters as possible.
///
///
///
/// The third part of the regular expression, \1, is a back reference to the first capture group.
/// This means that the regular expression will only match if the character that
/// was matched by the first capture group appears again at the
/// end of the string.
///
///
///
/// In other words, this regular expression is used to match a string that
/// starts and ends with one of the three characters *, _, or ~, and may have
/// any other characters in between. For example, the string "*bold text*"
/// would match this regular expression, but the string "*bold text" would not.
///
///
///
///The time complexity of the code is O(n) where n is the length of the
///input text. This is because the code uses a regular expression to find all
///matches in the text, which takes O(n) time, and then iterates over the
///matches to create the list of text spans, which also takes O(n) time.
///
///
///
///
//The space complexity of the code is also O(n) because the code creates a
//new list of text spans, which has the same length as the input text.

class TypeSet extends StatelessWidget {
  ///[inputText] is required field
  ///[style] is not required and nullable

  const TypeSet({
    super.key,
    required this.inputText,
    this.style,
  });

  ///[style] is the style of the text
  final TextStyle? style;

  ///[inputText] is the text that will be formatted

  final String inputText;

  @override
  Widget build(BuildContext context) {
    // Define a regular expression that matches the
    //bold, italic, and underline markers
    final regex = RegExp(r'([*_~])(.*?)\1');

    // Split the text into separate spans based on the formatting markers
    final spans = <TextSpan>[];

    // Find all matches in the text
    final matches = regex.allMatches(
      inputText,
    );

    // Iterate over the matches
    var lastMatchEnd = 0;
    for (final match in matches) {
      // Get the text that comes before the matched text
      final prefix = inputText.substring(lastMatchEnd, match.start);
      // Add a span for the text that comes before the matched text
      if (prefix.isNotEmpty) {
        spans.add(
          TextSpan(text: prefix),
        );
      }
      // Determine the style for the matched text
      TextStyle? formattedStyle;
      switch (match.group(1)) {
        case '*':
          formattedStyle = const TextStyle(fontWeight: FontWeight.bold);
          break;
        case '_':
          formattedStyle = const TextStyle(fontStyle: FontStyle.italic);
          break;
        case '~':
          formattedStyle = const TextStyle(
            decoration: TextDecoration.underline,
          );
          break;
      }

      // Add a span for the matched text
      spans.add(
        TextSpan(
          text: match.group(2),
          style: formattedStyle,
        ),
      );
      // Update the text to remove the matched text and the formatting markers
      //from it so that we can continue searching
      //for more matches in the remaining text
      lastMatchEnd = match.end;
    }
    // Add a span for any remaining text
    if (lastMatchEnd < inputText.length) {
      spans.add(
        TextSpan(
          text: inputText.substring(
            lastMatchEnd,
          ),
        ),
      );
    }
    // Use the `RichText` widget to display the text with the correct styles
    return RichText(
      text: TextSpan(
        style: style ?? DefaultTextStyle.of(context).style,
        children: spans,
      ),
    );
  }
}
