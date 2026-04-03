import 'package:flutter/widgets.dart';
import 'package:typeset/src/config/config.dart';
import 'package:typeset/src/document.dart';
import 'package:typeset/src/widgets/typeset.dart';

/// String extension for ergonomic TypeSet usage.
extension TypeSetExtension on String {
  /// Renders this string as a [TypeSet] widget.
  TypeSet typeset({
    Key? key,
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
    TypeSetConfig? config,
  }) {
    return TypeSet(
      this,
      key: key,
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
      config: config,
    );
  }

  /// Returns the plain-text representation with formatting markers removed.
  String get plainText => TypeSetDocument.compile(this).plainText;
}
