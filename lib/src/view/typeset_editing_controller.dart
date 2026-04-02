import 'package:flutter/material.dart';
import 'package:typeset/src/core/typeset_runtime.dart';
import 'package:typeset/src/core/typeset_span_utils.dart';
import 'package:typeset/src/models/typeset_config.dart';

/// A [TextEditingController] that renders TypeSet formatting while editing.
///
/// It uses the same parser and config model as `TypeSet`, while keeping the
/// raw markers visible so text can still be edited normally.
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
final class TypeSetEditingController extends TextEditingController {
  /// Creates a controller with TypeSet formatting capabilities.
  ///
  /// When [maxLiveFormattingLength] is set, live formatting is automatically
  /// disabled once the text length exceeds this threshold. The field continues
  /// to work as a normal plain-text input — no freeze, no crash. Formatting
  /// resumes automatically when the text length drops back below the limit.
  ///
  /// Defaults to [defaultMaxLiveFormattingLength] (5000 characters).
  /// Pass `null` to disable the guard entirely.
  TypeSetEditingController({
    super.text,
    this.config,
    this.maxLiveFormattingLength = defaultMaxLiveFormattingLength,
  }) {
    if (maxLiveFormattingLength != null && maxLiveFormattingLength! < 0) {
      throw ArgumentError.value(
        maxLiveFormattingLength,
        'maxLiveFormattingLength',
        'must be greater than or equal to 0',
      );
    }
  }

  /// Default character limit for live formatting (5000).
  static const int defaultMaxLiveFormattingLength = 5000;

  /// Configuration object containing styling and AutoLink settings.
  final TypeSetConfig? config;

  /// Maximum text length for live formatting.
  ///
  /// When the text exceeds this length, the controller renders plain text
  /// instead of applying formatting, preventing UI freezes on very long
  /// inputs (e.g. pasted logs or large blocks of text).
  ///
  /// Set to `null` to disable the guard entirely.
  final int? maxLiveFormattingLength;

  final TypeSetRuntimeSession _runtime = TypeSetRuntimeSession();

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (text.isEmpty) {
      _runtime.clear();
      return TextSpan(style: style);
    }

    // Large text protection: skip formatting when text exceeds the threshold.
    if (maxLiveFormattingLength != null &&
        text.length > maxLiveFormattingLength!) {
      _runtime.clear();
      return TextSpan(text: text, style: style);
    }

    final effectiveConfig = resolveTypeSetConfig(
      context,
      local: config,
    );
    final spans = _applyComposingRange(
      _runtime.render(
        inputText: text,
        config: effectiveConfig,
        showDelimiters: true,
      ),
      value: value,
      withComposing: withComposing,
    );

    return TextSpan(
      style: style,
      children: spans.isEmpty ? null : spans,
    );
  }

  @override
  void dispose() {
    _runtime.dispose();
    super.dispose();
  }

  List<InlineSpan> _applyComposingRange(
    List<InlineSpan> spans, {
    required TextEditingValue value,
    required bool withComposing,
  }) {
    final composing = value.composing;
    if (!withComposing ||
        composing.isCollapsed ||
        !value.isComposingRangeValid) {
      return spans;
    }

    final leaves = collectRenderedTextLeaves(spans);
    final composedSpans = <InlineSpan>[];
    var offset = 0;

    for (final leaf in leaves) {
      final leafStart = offset;
      final leafEnd = leafStart + leaf.text.length;
      final overlapStart =
          leafStart > composing.start ? leafStart : composing.start;
      final overlapEnd = leafEnd < composing.end ? leafEnd : composing.end;

      if (overlapStart >= overlapEnd) {
        appendTextSpanLeaf(
          composedSpans,
          text: leaf.text,
          style: leaf.style,
          recognizer: leaf.recognizer,
        );
      } else {
        final start = overlapStart - leafStart;
        final end = overlapEnd - leafStart;

        appendTextSpanLeaf(
          composedSpans,
          text: leaf.text.substring(0, start),
          style: leaf.style,
          recognizer: leaf.recognizer,
        );
        appendTextSpanLeaf(
          composedSpans,
          text: leaf.text.substring(start, end),
          style: addTextDecoration(leaf.style, TextDecoration.underline),
          recognizer: leaf.recognizer,
        );
        appendTextSpanLeaf(
          composedSpans,
          text: leaf.text.substring(end),
          style: leaf.style,
          recognizer: leaf.recognizer,
        );
      }

      offset = leafEnd;
    }

    return composedSpans;
  }
}
