import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:typeset/src/core/parser/typeset_parser.dart';
import 'package:typeset/src/core/renderer/typeset_renderer.dart';
import 'package:typeset/src/core/typeset_ast.dart';
import 'package:typeset/src/models/ast/typeset_nodes.dart';
import 'package:typeset/src/models/typeset_autolink_config.dart';
import 'package:typeset/src/models/typeset_style.dart';

/// A compiled TypeSet document for repeated rendering.
///
/// The parsing and AutoLink detection work happen when the document is created.
/// Rendering can then be repeated with different text styles or recognizers.
///
/// If you need different AutoLink detection rules, compile a new document.
@immutable
final class TypeSetDocument {
  TypeSetDocument._({
    required this.inputText,
    required List<TypesetNode> nodes,
    this.autoLinkConfig,
  })  : _nodes = List<TypesetNode>.unmodifiable(nodes),
        _plainText = typesetPlainText(nodes);

  /// Compiles [input] into a reusable parsed document.
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

  /// The original source text used to compile this document.
  final String inputText;

  /// The AutoLink policy used when this document was compiled.
  final TypeSetAutoLinkConfig? autoLinkConfig;

  final List<TypesetNode> _nodes;
  final String _plainText;

  /// Returns the rendered content with formatting markers removed.
  String get plainText => _plainText;

  /// Renders the compiled document into Flutter [InlineSpan]s.
  ///
  /// The document's link boundaries are fixed at compile time. Providing a
  /// [linkRecognizerBuilder] here only controls whether compiled links are
  /// interactive during rendering.
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
