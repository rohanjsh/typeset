import 'package:flutter/material.dart';

/// Configuration for TypeSet formatting styles.
@immutable
final class TypeSetStyle {
  /// Creates a style configuration with optional text styles and marker color.
  const TypeSetStyle({
    this.boldStyle,
    this.italicStyle,
    this.underlineStyle,
    this.strikethroughStyle,
    this.linkStyle,
    this.monospaceStyle,
    this.markerColor,
  });

  /// Style applied to bold text (`*text*`).
  final TextStyle? boldStyle;

  /// Style applied to italic text (`_text_`).
  final TextStyle? italicStyle;

  /// Style applied to underline text (`__text__`).
  final TextStyle? underlineStyle;

  /// Style applied to strikethrough text (`~text~`).
  final TextStyle? strikethroughStyle;

  /// Style applied to links (AutoLink URLs).
  final TextStyle? linkStyle;

  /// Style applied to inline code (`` `text` ``).
  final TextStyle? monospaceStyle;

  /// Color for formatting markers/delimiters (only used in editing mode).
  final Color? markerColor;

  /// Creates a copy of this style with the given fields replaced.
  TypeSetStyle copyWith({
    TextStyle? boldStyle,
    TextStyle? italicStyle,
    TextStyle? underlineStyle,
    TextStyle? strikethroughStyle,
    TextStyle? linkStyle,
    TextStyle? monospaceStyle,
    Color? markerColor,
  }) {
    return TypeSetStyle(
      boldStyle: boldStyle ?? this.boldStyle,
      italicStyle: italicStyle ?? this.italicStyle,
      underlineStyle: underlineStyle ?? this.underlineStyle,
      strikethroughStyle: strikethroughStyle ?? this.strikethroughStyle,
      linkStyle: linkStyle ?? this.linkStyle,
      monospaceStyle: monospaceStyle ?? this.monospaceStyle,
      markerColor: markerColor ?? this.markerColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeSetStyle &&
          runtimeType == other.runtimeType &&
          boldStyle == other.boldStyle &&
          italicStyle == other.italicStyle &&
          underlineStyle == other.underlineStyle &&
          strikethroughStyle == other.strikethroughStyle &&
          linkStyle == other.linkStyle &&
          monospaceStyle == other.monospaceStyle &&
          markerColor == other.markerColor;

  @override
  int get hashCode =>
      boldStyle.hashCode ^
      italicStyle.hashCode ^
      underlineStyle.hashCode ^
      strikethroughStyle.hashCode ^
      linkStyle.hashCode ^
      monospaceStyle.hashCode ^
      markerColor.hashCode;
}
