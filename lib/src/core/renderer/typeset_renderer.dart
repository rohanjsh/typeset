import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:typeset/src/core/typeset_ast.dart';
import 'package:typeset/src/core/typeset_span_utils.dart';
import 'package:typeset/src/models/ast/typeset_nodes.dart';
import 'package:typeset/src/models/typeset_autolink_config.dart';
import 'package:typeset/src/models/typeset_reserved.dart';
import 'package:typeset/src/models/typeset_style.dart';

/// Renders AST nodes into Flutter [InlineSpan]s.
final class TypesetRenderer {
  /// Creates a renderer for AST nodes.
  const TypesetRenderer({
    this.style,
    this.autoLinkConfig,
    this.showDelimiters = false,
    this.onLinkRecognizerCreated,
  });

  /// Styling configuration.
  final TypeSetStyle? style;

  /// AutoLink behavior configuration.
  final TypeSetAutoLinkConfig? autoLinkConfig;

  /// Whether to show formatting delimiters (editing mode).
  final bool showDelimiters;

  /// Called when a link recognizer is created during rendering.
  final void Function(GestureRecognizer recognizer)? onLinkRecognizerCreated;

  /// Renders AST nodes into Flutter [InlineSpan]s.
  List<InlineSpan> render(List<TypesetNode> nodes) {
    return _renderNodes(nodes, const TextStyle());
  }

  List<InlineSpan> _renderNodes(List<TypesetNode> nodes, TextStyle style) {
    final out = <InlineSpan>[];

    for (final node in nodes) {
      switch (node) {
        case TypesetTextNode():
          appendTextSpanLeaf(out, text: node.text, style: style);

        case TypesetCodeNode():
          final codeStyle = _applyCodeStyle(style);
          if (showDelimiters) {
            appendTextSpanLeaf(
              out,
              text: TypesetReserved.monospaceChar,
              style: _markerStyle(style),
            );
          }
          appendTextSpanLeaf(out, text: node.code, style: codeStyle);
          if (showDelimiters) {
            appendTextSpanLeaf(
              out,
              text: TypesetReserved.monospaceChar,
              style: _markerStyle(style),
            );
          }

        case TypesetStyleNode():
          final nextStyle = _applyInlineStyle(style, node.style);
          final delimiter = _delimiterForStyle(node.style);

          if (showDelimiters) {
            appendTextSpanLeaf(
              out,
              text: delimiter,
              style: _markerStyle(style),
            );
          }

          out.addAll(_renderNodes(node.children, nextStyle));

          if (showDelimiters) {
            appendTextSpanLeaf(
              out,
              text: delimiter,
              style: _markerStyle(style),
            );
          }

        case TypesetLinkNode():
          final labelText = typesetPlainText(node.label);
          final recognizer =
              autoLinkConfig?.linkRecognizerBuilder?.call(labelText, node.url);
          if (recognizer != null) {
            onLinkRecognizerCreated?.call(recognizer);
          }
          final linkBaseStyle = _applyLinkStyle(style);

          out.add(
            TextSpan(
              style: linkBaseStyle,
              recognizer: recognizer,
              children: _renderNodes(node.label, linkBaseStyle),
            ),
          );
      }
    }

    return out;
  }

  TextStyle _applyInlineStyle(TextStyle current, TypesetStyle styleType) {
    switch (styleType) {
      case TypesetStyle.bold:
        return current.merge(
          style?.boldStyle ?? const TextStyle(fontWeight: FontWeight.bold),
        );
      case TypesetStyle.italic:
        return current.merge(
          style?.italicStyle ?? const TextStyle(fontStyle: FontStyle.italic),
        );
      case TypesetStyle.underline:
        final baseStyle = style?.underlineStyle ?? const TextStyle();
        return addTextDecoration(
          current.merge(baseStyle),
          TextDecoration.underline,
        );
      case TypesetStyle.strikethrough:
        final baseStyle = style?.strikethroughStyle ?? const TextStyle();
        return addTextDecoration(
          current.merge(baseStyle),
          TextDecoration.lineThrough,
        );
    }
  }

  TextStyle _applyLinkStyle(TextStyle current) {
    const defaultLink = TextStyle(
      color: Color(0xFF0000EE),
      decoration: TextDecoration.underline,
      decorationColor: Color(0xFF0000EE),
    );

    return current.merge(style?.linkStyle ?? defaultLink);
  }

  TextStyle _applyCodeStyle(TextStyle current) {
    final base =
        style?.monospaceStyle ?? const TextStyle(fontFamily: 'Courier');
    return current.merge(base).merge(
          const TextStyle(
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            decoration: TextDecoration.none,
          ),
        );
  }

  /// Returns the delimiter string for a given style.
  String _delimiterForStyle(TypesetStyle style) {
    switch (style) {
      case TypesetStyle.bold:
        return TypesetReserved.boldChar;
      case TypesetStyle.italic:
        return TypesetReserved.italicChar;
      case TypesetStyle.underline:
        return TypesetReserved.underlineChar;
      case TypesetStyle.strikethrough:
        return TypesetReserved.strikethroughChar;
    }
  }

  /// Returns a TextStyle for markers/delimiters with the marker color.
  TextStyle _markerStyle(TextStyle current) {
    final markerColor = style?.markerColor;
    if (markerColor == null) {
      return current;
    }
    return current.merge(TextStyle(color: markerColor));
  }
}
