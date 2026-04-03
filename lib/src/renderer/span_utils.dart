import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// A rendered text leaf with fully inherited styling and recognizers.
final class TypesetRenderedLeaf {
  /// Creates a rendered leaf.
  const TypesetRenderedLeaf({
    required this.text,
    required this.style,
    required this.recognizer,
  });

  /// The leaf text content.
  final String text;

  /// The fully resolved style at this leaf.
  final TextStyle style;

  /// Gesture recognizer (e.g. link tap), if any.
  final GestureRecognizer? recognizer;
}

/// Flattens an InlineSpan tree into leaves with inherited styles.
List<TypesetRenderedLeaf> collectRenderedTextLeaves(
  Iterable<InlineSpan> spans,
) {
  final out = <TypesetRenderedLeaf>[];

  void visit(
    InlineSpan current,
    TextStyle inheritedStyle,
    GestureRecognizer? inheritedRecognizer,
  ) {
    if (current is! TextSpan) return;

    final effectiveStyle = inheritedStyle.merge(current.style);
    final effectiveRecognizer = current.recognizer ?? inheritedRecognizer;
    final text = current.text;
    if (text != null && text.isNotEmpty) {
      out.add(
        TypesetRenderedLeaf(
          text: text,
          style: effectiveStyle,
          recognizer: effectiveRecognizer,
        ),
      );
    }

    for (final child in current.children ?? const <InlineSpan>[]) {
      visit(child, effectiveStyle, effectiveRecognizer);
    }
  }

  for (final span in spans) {
    visit(span, const TextStyle(), null);
  }

  return out;
}

/// Merges [decoration] into the existing decoration on [style].
TextStyle addTextDecoration(TextStyle style, TextDecoration decoration) {
  final existing = style.decoration;
  final combined = existing == null
      ? decoration
      : TextDecoration.combine([existing, decoration]);
  return style.copyWith(decoration: combined);
}

/// Appends a text leaf, coalescing with the previous span if compatible.
void appendTextSpanLeaf(
  List<InlineSpan> out, {
  required String text,
  required TextStyle style,
  GestureRecognizer? recognizer,
}) {
  if (text.isEmpty) return;

  final last = out.isEmpty ? null : out.last;
  if (last is TextSpan &&
      last.children == null &&
      last.style == style &&
      identical(last.recognizer, recognizer)) {
    out[out.length - 1] = TextSpan(
      text: '${last.text ?? ''}$text',
      style: style,
      recognizer: recognizer,
    );
    return;
  }

  out.add(TextSpan(text: text, style: style, recognizer: recognizer));
}
