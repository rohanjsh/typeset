/// {@template typeset}
/// WhatsApp like text formatting for you!
/// {@endtemplate}
import 'package:flutter/widgets.dart';
import 'package:typeset/src/typeset_parser.dart';
//Text style that will support bold, italic and underline
//The usage is same as we see on WhatsApp

///i.e.
//1. Bold Text will be wrapped in *asterisk*
//2. Italic Text will be wrapped in _underscore_
//3. Underline Text will be wrapped in ~tilde~
//4. Bold, Italic and Underline Text will be
//wrapped in *asterisk* _underscore_ ~tilde~
class TypeSet extends StatelessWidget {
  ///[inputText] is required field
  ///[style] is not required and nullable
  ///[textAlign] is not required and default value is [TextAlign.start]

  const TypeSet({
    super.key,
    required this.inputText,
    this.style,
    this.textAlign = TextAlign.start,
  });

  ///[style] is the style of the text
  final TextStyle? style;

  ///[inputText] is the text that will be formatted

  final String inputText;

  ///[textAlign] is the alignment of the text

  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    // Use the `RichText` widget to display the text with the correct styles
    return Text.rich(
      TextSpan(
        children: TypesetParserUtil.parseText(
          inputText,
        ),
      ),
      textAlign: textAlign,
      style: style ?? DefaultTextStyle.of(context).style,
    );
  }
}
