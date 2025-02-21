import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:typeset/src/core/typeset_parser.dart';

/// {@template typeset}
/// WhatsApp like text formatting for you!
/// {@endtemplate}
/// Format the text with different styles, similar to whatsapp
///
/// Following is the usage:
/// Bold
/// → Hello, *World!*
///
/// Italic
/// → Hello, _World!_
///
/// Strikethrough
/// → Hello, ~World!~
///
/// Underline
/// → Hello, #World!#
///
/// Monospace
/// → Hello, `World!`
///
/// Link
/// → §google.com|https://google.com§
class TypeSet extends StatelessWidget {
  ///[inputText] is required field

  const TypeSet(
    this.inputText, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.strutStyle,
    this.linkRecognizerBuilder,
    this.linkStyle,
    this.monospaceStyle,
    this.boldStyle,
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

  ///[textScaler] is the text scale factor of the text

  final TextScaler? textScaler;

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

  ///[linkRecognizerBuilder] is the recognizer of the text
  final GestureRecognizer Function(String linkText, String url)?
      linkRecognizerBuilder;

  ///[linkStyle] is the style of the link
  final TextStyle? linkStyle;

  ///[monospaceStyle] is the style of the monospace text
  final TextStyle? monospaceStyle;

  ///[boldStyle] is the style of the bold text
  final TextStyle? boldStyle;

  @override
  Widget build(BuildContext context) {
    // Use the `RichText` widget to display the text with the correct styles
    return Text.rich(
      TextSpan(
        children: TypesetParser.parser(
          inputText: inputText,
          linkRecognizerBuilder: linkRecognizerBuilder,
          linkStyle: linkStyle,
          monospaceStyle: monospaceStyle,
          boldStyle: boldStyle,
        ),
      ),
      textAlign: textAlign,
      style: style,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      strutStyle: strutStyle,
    );
  }
}
