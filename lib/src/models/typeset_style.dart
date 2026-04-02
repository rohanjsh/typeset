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

  /// Creates a theme-derived style that adapts to the active [ThemeData].
  ///
  /// Links use `colorScheme.primary`, inline code uses
  /// `colorScheme.surfaceContainerHighest` as a background with
  /// `colorScheme.onSurfaceVariant` as text color, and marker color uses
  /// `colorScheme.outline`.
  ///
  /// These values act as sensible defaults that any explicit configuration
  /// (local, scoped, or global) will override through the normal merge chain.
  factory TypeSetStyle.fromTheme(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return TypeSetStyle(
      linkStyle: TextStyle(
        color: colorScheme.primary,
        decoration: TextDecoration.underline,
        decorationColor: colorScheme.primary,
      ),
      monospaceStyle: TextStyle(
        fontFamily: 'Courier',
        backgroundColor: colorScheme.surfaceContainerHighest,
        color: colorScheme.onSurfaceVariant,
      ),
      markerColor: colorScheme.outline,
    );
  }

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

  /// Creates a merged style where non-null values from [override]
  /// replace this style's values.
  TypeSetStyle merge(TypeSetStyle? override) {
    if (override == null) {
      return this;
    }

    return TypeSetStyle(
      boldStyle: override.boldStyle ?? boldStyle,
      italicStyle: override.italicStyle ?? italicStyle,
      underlineStyle: override.underlineStyle ?? underlineStyle,
      strikethroughStyle: override.strikethroughStyle ?? strikethroughStyle,
      linkStyle: override.linkStyle ?? linkStyle,
      monospaceStyle: override.monospaceStyle ?? monospaceStyle,
      markerColor: override.markerColor ?? markerColor,
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
  int get hashCode => Object.hash(
        boldStyle,
        italicStyle,
        underlineStyle,
        strikethroughStyle,
        linkStyle,
        monospaceStyle,
        markerColor,
      );
}
