import 'package:flutter/material.dart';

/// Style overrides for TypeSet formatting.
@immutable
final class TypeSetStyle {
  /// Creates a style config.
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

  /// Style applied to `*bold*` text.
  final TextStyle? boldStyle;

  /// Style applied to `_italic_` text.
  final TextStyle? italicStyle;

  /// Style applied to `__underline__` text.
  final TextStyle? underlineStyle;

  /// Style applied to `~strikethrough~` text.
  final TextStyle? strikethroughStyle;

  /// Style applied to AutoLinked URLs.
  final TextStyle? linkStyle;

  /// Style applied to `` `code` `` text.
  final TextStyle? monospaceStyle;

  /// Color for formatting markers (editing mode only).
  final Color? markerColor;

  /// Returns a copy with the given fields replaced.
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

  /// Merges [override] on top of this style.
  TypeSetStyle merge(TypeSetStyle? override) {
    if (override == null) return this;

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
