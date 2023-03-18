/// {@template typeset}
/// WhatsApp like text formatting for you!
/// {@endtemplate}
import 'package:flutter/widgets.dart';
import 'package:typeset/src/typeset_parser.dart';

/// Whatsapp like formatting with some addons!!
/// (input looks like this)

/// → Hello, *World!*          <Bold>
/// → Hello, _World!_          <Italic>
/// → Hello, ~World!~         <Strikethrough>
/// → Hello, //World!//         <Underline>
/// → Hello, `World!`          <Monospace>
/// → [google.com|https://google.com]   <Link>
class TypeSet extends StatelessWidget {
  ///[inputText] is required field

  const TypeSet({
    super.key,
    required this.inputText,
    this.style,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.strutStyle,
  });

  ///[style] is the style of the text
  final TextStyle? style;

  ///[inputText] is the text that will be formatted

  final String inputText;

  ///[textAlign] is the alignment of the text

  final TextAlign textAlign;

  ///[textDirection] is the direction of the text

  final TextDirection? textDirection;

  ///[locale] is the locale of the text

  final Locale? locale;

  ///[softWrap] is the soft wrap of the text

  final bool? softWrap;

  ///[overflow] is the overflow of the text

  final TextOverflow? overflow;

  ///[textScaleFactor] is the text scale factor of the text

  final double? textScaleFactor;

  ///[maxLines] is the max lines of the text

  final int? maxLines;

  ///[semanticsLabel] is the semantics label of the text

  final String? semanticsLabel;

  ///[textWidthBasis] is the text width basis of the text

  final TextWidthBasis? textWidthBasis;

  ///[textHeightBehavior] is the text height behavior of the text

  final TextHeightBehavior? textHeightBehavior;

  ///[selectionColor] is the selection color of the text

  final Color? selectionColor;

  ///[strutStyle] is the strut style of the text

  final StrutStyle? strutStyle;

  @override
  Widget build(BuildContext context) {
    // Use the `RichText` widget to display the text with the correct styles
    return Text.rich(
      TextSpan(
        children: TypesetParser.parseText(
          inputText,
        ),
      ),
      textAlign: textAlign,
      style: style,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      strutStyle: strutStyle,
    );
  }
}
