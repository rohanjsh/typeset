import 'package:flutter/material.dart';
import 'package:typeset/src/config/config.dart';
import 'package:typeset/src/renderer/span_utils.dart';
import 'package:typeset/src/runtime.dart';

/// A [TextEditingController] that renders TypeSet formatting while editing.
/// Shows formatting markers and renders styles live in the text field.
final class TypeSetEditingController extends TextEditingController {
  /// [maxLiveFormattingLength] (default 5000) prevents UI freezes on very
  /// long inputs by disabling formatting when the text exceeds this limit.
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

  /// Default character threshold for live formatting.
  static const int defaultMaxLiveFormattingLength = 5000;

  /// Config for styling and AutoLink behavior.
  final TypeSetConfig? config;

  /// Formatting is disabled once text exceeds this limit.
  /// Set to `null` to disable entirely.
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

    if (maxLiveFormattingLength != null &&
        text.length > maxLiveFormattingLength!) {
      _runtime.clear();
      return TextSpan(text: text, style: style);
    }

    final effectiveConfig = resolveTypeSetConfig(context, local: config);
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
