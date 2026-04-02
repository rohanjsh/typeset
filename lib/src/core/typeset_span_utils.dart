import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// A flattened rendered text leaf with its fully inherited styling.
final class TypesetRenderedLeaf {
  /// Creates a rendered text leaf.
  const TypesetRenderedLeaf({
    required this.text,
    required this.style,
    required this.recognizer,
  });

  /// The rendered text for this leaf.
  final String text;

  /// The effective merged style for this leaf.
  final TextStyle style;

  /// The effective recognizer for this leaf, if any.
  final GestureRecognizer? recognizer;
}

/// Returns the textual content of an [InlineSpan] subtree.
String inlineSpanPlainText(InlineSpan span) {
  if (span is! TextSpan) {
    return '';
  }

  final buffer = StringBuffer()..write(span.text ?? '');
  for (final child in span.children ?? const <InlineSpan>[]) {
    buffer.write(inlineSpanPlainText(child));
  }
  return buffer.toString();
}

/// Collects leaf [TextSpan]s from an [InlineSpan] subtree.
List<TextSpan> collectLeafTextSpans(InlineSpan span) {
  final out = <TextSpan>[];

  void visit(InlineSpan current) {
    if (current is! TextSpan) {
      return;
    }

    final text = current.text;
    final children = current.children;
    if (text != null &&
        text.isNotEmpty &&
        (children == null || children.isEmpty)) {
      out.add(current);
    }

    for (final child in children ?? const <InlineSpan>[]) {
      visit(child);
    }
  }

  visit(span);
  return out;
}

/// Collects every [TextSpan] in the subtree that has a recognizer.
List<TextSpan> collectRecognizedTextSpans(InlineSpan span) {
  final out = <TextSpan>[];

  void visit(InlineSpan current) {
    if (current is! TextSpan) {
      return;
    }

    if (current.recognizer != null) {
      out.add(current);
    }

    for (final child in current.children ?? const <InlineSpan>[]) {
      visit(child);
    }
  }

  visit(span);
  return out;
}

/// Flattens rendered text leaves while preserving inherited style and
/// recognizer.
List<TypesetRenderedLeaf> collectRenderedTextLeaves(
  Iterable<InlineSpan> spans,
) {
  final out = <TypesetRenderedLeaf>[];

  void visit(
    InlineSpan current,
    TextStyle inheritedStyle,
    GestureRecognizer? inheritedRecognizer,
  ) {
    if (current is! TextSpan) {
      return;
    }

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

/// Returns [style] with [decoration] added to any existing decoration.
TextStyle addTextDecoration(TextStyle style, TextDecoration decoration) {
  final existing = style.decoration;
  final combined = existing == null
      ? decoration
      : TextDecoration.combine([existing, decoration]);
  return style.copyWith(decoration: combined);
}

/// Appends a text leaf, coalescing adjacent compatible spans when possible.
void appendTextSpanLeaf(
  List<InlineSpan> out, {
  required String text,
  required TextStyle style,
  GestureRecognizer? recognizer,
}) {
  if (text.isEmpty) {
    return;
  }

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
