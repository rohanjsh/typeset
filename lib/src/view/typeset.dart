import 'package:flutter/widgets.dart';
import 'package:typeset/src/core/typeset_runtime.dart';
import 'package:typeset/src/models/typeset_config.dart';

/// {@template typeset}
/// Renders inline rich text with familiar chat-style syntax.
/// {@endtemplate}
///
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

  /// Base text style applied to all text.
  final TextStyle? style;

  /// The text to format.
  final String inputText;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// Used to select a font when the same Unicode character can be
  /// rendered differently.
  final Locale? locale;

  /// Whether the text should break at soft line breaks.
  final bool? softWrap;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  /// The number of font pixels for each logical pixel.
  final TextScaler? textScaler;

  /// An optional maximum number of lines for the text to span.
  final int? maxLines;

  /// An alternative semantics label for this text.
  final String? semanticsLabel;

  /// Defines how to measure the width of the rendered text.
  final TextWidthBasis? textWidthBasis;

  /// Defines how the paragraph will apply [TextStyle.height] to the ascent
  /// of the first line and descent of the last line.
  final TextHeightBehavior? textHeightBehavior;

  /// The color used to paint the selection.
  final Color? selectionColor;

  /// The strut style to use. Strut style defines the strut, which set up
  /// a multi-line paragraph.
  final StrutStyle? strutStyle;

  /// Configuration object containing styling and AutoLink settings.
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
      TextSpan(
        children: children,
      ),
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
