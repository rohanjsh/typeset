import 'package:flutter/material.dart';
import 'package:typeset/src/core/parser/typeset_parser.dart';
import 'package:typeset/src/core/renderer/typeset_renderer.dart';
import 'package:typeset/src/core/typeset_config_provider.dart';
import 'package:typeset/src/models/typeset_config.dart';
import 'package:typeset/src/models/typeset_global_config.dart';

/// A custom [TextEditingController] for WhatsApp/Telegram-style text formatting.
///
/// Applies formatting to text as it's being edited.
///
/// Example usage:
/// ```dart
/// final controller = TypeSetEditingController();
/// TextField(controller: controller);
/// ```
///
/// Supported formatting:
/// - Bold: `*text*`
/// - Italic: `_text_`
/// - Strikethrough: `~text~`
/// - Underline: `__text__`
/// - Inline code: `` `text` ``
/// - Links: Raw URLs (https://example.com, http://example.com,
///   www.example.com)
///
/// The controller automatically renders formatted text while preserving
/// the raw text with markers for editing.
class TypeSetEditingController extends TextEditingController {
  /// Creates a controller with TypeSet formatting capabilities.
  TypeSetEditingController({
    super.text,
    this.config,
  });

  /// Configuration object containing styling and AutoLink settings.
  final TypeSetConfig? config;

  /// Core parser instance (stateless, reusable).
  static const _parser = TypesetParser();

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (text.isEmpty) {
      return TextSpan(style: style);
    }

    final scopedConfig = TypeSetConfigProvider.of(context);
    final effectiveConfig =
        config ?? scopedConfig ?? TypeSetGlobalConfig.instance;

    final nodes = _parser.parse(
      text,
      autoLinkConfig: effectiveConfig.autoLinkConfig,
    );

    final renderer = TypesetRenderer(
      style: effectiveConfig.style,
      autoLinkConfig: effectiveConfig.autoLinkConfig,
      showDelimiters: true,
    );

    final spans = renderer.render(nodes);

    return TextSpan(
      style: style,
      children: spans.isEmpty ? null : spans,
    );
  }
}
