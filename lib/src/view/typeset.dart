import 'package:flutter/widgets.dart';
import 'package:typeset/src/core/parser/typeset_parser.dart';
import 'package:typeset/src/core/renderer/typeset_renderer.dart';
import 'package:typeset/src/core/typeset_config_provider.dart';
import 'package:typeset/src/models/typeset_config.dart';
import 'package:typeset/src/models/typeset_global_config.dart';

/// {@template typeset}
/// WhatsApp/Telegram-like text formatting.
/// {@endtemplate}
///
/// Supports: `*bold*`, `_italic_`, `__underline__`, `~strikethrough~`,
/// `` `code` ``, AutoLink URLs.
class TypeSet extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final scopedConfig = TypeSetConfigProvider.of(context);
    final effectiveConfig =
        config ?? scopedConfig ?? TypeSetGlobalConfig.instance;

    final children = TypesetRenderer(
      style: effectiveConfig.style,
      autoLinkConfig: effectiveConfig.autoLinkConfig,
    ).render(
      const TypesetParser().parse(
        inputText,
        autoLinkConfig: effectiveConfig.autoLinkConfig,
      ),
    );

    return Text.rich(
      TextSpan(
        children: children,
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
