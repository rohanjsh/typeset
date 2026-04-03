import 'package:flutter/widgets.dart';
import 'package:typeset/src/config/config.dart';
import 'package:typeset/src/runtime.dart';

/// Renders inline rich text with chat-style syntax.
/// Supports: `*bold*`, `_italic_`, `__underline__`, `~strikethrough~`,
/// `` `code` ``, AutoLink URLs.
final class TypeSet extends StatefulWidget {
  /// Creates a TypeSet widget.
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
    this.config,
  });

  /// Base text style applied to all rendered text.
  final TextStyle? style;

  /// The markup text to format.
  final String inputText;

  /// {@macro flutter.widgets.Text.textAlign}
  final TextAlign textAlign;

  /// {@macro flutter.widgets.Text.textDirection}
  final TextDirection? textDirection;

  /// {@macro flutter.widgets.Text.locale}
  final Locale? locale;

  /// {@macro flutter.widgets.Text.softWrap}
  final bool? softWrap;

  /// {@macro flutter.widgets.Text.overflow}
  final TextOverflow? overflow;

  /// {@macro flutter.widgets.Text.textScaler}
  final TextScaler? textScaler;

  /// {@macro flutter.widgets.Text.maxLines}
  final int? maxLines;

  /// {@macro flutter.widgets.Text.semanticsLabel}
  final String? semanticsLabel;

  /// {@macro flutter.widgets.Text.textWidthBasis}
  final TextWidthBasis? textWidthBasis;

  /// {@macro flutter.widgets.Text.textHeightBehavior}
  final TextHeightBehavior? textHeightBehavior;

  /// {@macro flutter.widgets.Text.selectionColor}
  final Color? selectionColor;

  /// {@macro flutter.widgets.Text.strutStyle}
  final StrutStyle? strutStyle;

  /// TypeSet config (style + AutoLink settings).
  final TypeSetConfig? config;

  @override
  State<TypeSet> createState() => _TypeSetState();
}

final class _TypeSetState extends State<TypeSet> {
  final TypeSetRuntimeSession _runtime = TypeSetRuntimeSession();

  @override
  Widget build(BuildContext context) {
    final effectiveConfig = resolveTypeSetConfig(
      context,
      local: widget.config,
    );
    final children = _runtime.render(
      inputText: widget.inputText,
      config: effectiveConfig,
    );

    return Text.rich(
      TextSpan(children: children),
      textAlign: widget.textAlign,
      style: widget.style,
      textDirection: widget.textDirection,
      locale: widget.locale,
      softWrap: widget.softWrap,
      overflow: widget.overflow,
      textScaler: widget.textScaler,
      maxLines: widget.maxLines,
      semanticsLabel: widget.semanticsLabel,
      textWidthBasis: widget.textWidthBasis,
      textHeightBehavior: widget.textHeightBehavior,
      selectionColor: widget.selectionColor,
      strutStyle: widget.strutStyle,
    );
  }

  @override
  void dispose() {
    _runtime.dispose();
    super.dispose();
  }
}
