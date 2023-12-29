import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';
import 'package:typeset/src/typeset.dart';

///TypeSet extension on String to use [typeset] method
extension TypeSetExtension on String {
  ///[typeset] method to format the text with different styles
  TypeSet typeset({
    TextStyle? style,
    TextAlign textAlign = TextAlign.start,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
    StrutStyle? strutStyle,
    GestureRecognizer? recognizer,
    TextStyle? linkStyle,
    TextStyle? boldStyle,
    TextStyle? monospaceStyle,
  }) {
    return TypeSet(
      this,
      style: style,
      textAlign: textAlign,
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
      recognizer: recognizer,
      linkStyle: linkStyle,
      boldStyle: boldStyle,
      monospaceStyle: monospaceStyle,
    );
  }
}
