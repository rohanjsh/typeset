import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:typeset/src/ast/nodes.dart';
import 'package:typeset/src/ast/plain_text.dart';
import 'package:typeset/src/config/autolink_config.dart';
import 'package:typeset/src/config/style.dart';
import 'package:typeset/src/parser/parser.dart';
import 'package:typeset/src/renderer/renderer.dart';

/// A compiled TypeSet document for repeated rendering.
///
/// Parsing and AutoLink detection happen at compile time.
/// Rendering can then be repeated with different styles or recognizers.
@immutable
final class TypeSetDocument {
  TypeSetDocument._({
    required this.inputText,
    required List<TypesetNode> nodes,
    this.autoLinkConfig,
  })  : _nodes = List<TypesetNode>.unmodifiable(nodes),
        _plainText = typesetPlainText(nodes);

  /// Parses and compiles [input] into a renderable document.
  factory TypeSetDocument.compile(
    String input, {
    TypeSetAutoLinkConfig? autoLinkConfig,
  }) {
    return TypeSetDocument._(
      inputText: input,
      nodes: _parser.parse(input, autoLinkConfig: autoLinkConfig),
      autoLinkConfig: autoLinkConfig,
    );
  }

  static const TypesetParser _parser = TypesetParser();

  /// The original source text.
  final String inputText;

  /// The AutoLink config used at compile time.
  final TypeSetAutoLinkConfig? autoLinkConfig;
  final List<TypesetNode> _nodes;
  final String _plainText;

  /// Plain text with formatting stripped.
  String get plainText => _plainText;

  /// Renders this document into [InlineSpan]s with the given style.
  List<InlineSpan> render({
    TypeSetStyle? style,
    bool showDelimiters = false,
    GestureRecognizer Function(String linkText, String url)?
        linkRecognizerBuilder,
    void Function(GestureRecognizer recognizer)? onLinkRecognizerCreated,
  }) {
    final renderAutoLinkConfig = linkRecognizerBuilder == null
        ? autoLinkConfig
        : (autoLinkConfig ?? TypeSetAutoLinkConfig()).copyWith(
            linkRecognizerBuilder: linkRecognizerBuilder,
          );

    return TypesetRenderer(
      style: style,
      autoLinkConfig: renderAutoLinkConfig,
      showDelimiters: showDelimiters,
      onLinkRecognizerCreated: onLinkRecognizerCreated,
    ).render(_nodes);
  }
}
