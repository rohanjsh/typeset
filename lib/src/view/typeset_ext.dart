import 'package:flutter/widgets.dart';
import 'package:typeset/src/models/typeset_config.dart';
import 'package:typeset/src/models/typeset_document.dart';
import 'package:typeset/src/view/typeset.dart';

/// TypeSet extension on String to use [typeset] method.
extension TypeSetExtension on String {
  /// Formats the string as a TypeSet widget.
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

  /// Returns the plain-text representation that TypeSet would render.
  ///
  /// Supported formatting markers are removed while visible content is kept.
  String stripFormatting() => TypeSetDocument.compile(this).plainText;
}
