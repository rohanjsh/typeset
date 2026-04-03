import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:typeset/src/renderer/span_utils.dart';

/// Test utilities for working with InlineSpan trees.

String inlineSpanPlainText(InlineSpan span) {
  if (span is! TextSpan) return '';
  final buffer = StringBuffer()..write(span.text ?? '');
  for (final child in span.children ?? const <InlineSpan>[]) {
    buffer.write(inlineSpanPlainText(child));
  }
  return buffer.toString();
}

List<TextSpan> collectLeafTextSpans(InlineSpan span) {
  final out = <TextSpan>[];
  void visit(InlineSpan current) {
    if (current is! TextSpan) return;
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

List<TextSpan> collectRecognizedTextSpans(InlineSpan span) {
  final out = <TextSpan>[];
  void visit(InlineSpan current) {
    if (current is! TextSpan) return;
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
