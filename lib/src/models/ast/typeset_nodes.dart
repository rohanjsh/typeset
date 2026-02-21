/// Base class for parsed nodes.
sealed class TypesetNode {
  const TypesetNode();
}

/// Plain text node.
final class TypesetTextNode extends TypesetNode {
  /// Creates a plain-text node.
  const TypesetTextNode(this.text);

  /// The literal text content.
  final String text;

  @override
  String toString() => 'Text("$text")';
}

/// Inline code node (content is literal, no parsing inside).
final class TypesetCodeNode extends TypesetNode {
  /// Creates an inline-code node.
  const TypesetCodeNode(this.code);

  /// The literal inline-code content.
  final String code;

  @override
  String toString() => 'Code("$code")';
}

/// A link node with a parsed label.
final class TypesetLinkNode extends TypesetNode {
  /// Creates a link node.
  const TypesetLinkNode({required this.url, required this.label});

  /// The link destination URL.
  final String url;

  /// The parsed label nodes (rendered as the clickable text).
  final List<TypesetNode> label;

  @override
  String toString() => 'Link(url: $url, label: $label)';
}

/// Supported inline formatting styles.
enum TypesetStyle {
  /// Bold (`*text*`).
  bold,

  /// Italic (`_text_`).
  italic,

  /// Underline (`__text__`).
  underline,

  /// Strikethrough (`~text~`).
  strikethrough,
}

/// A styled span containing child nodes.
final class TypesetStyleNode extends TypesetNode {
  /// Creates a style span node.
  const TypesetStyleNode({required this.style, required this.children});

  /// The style applied to children.
  final TypesetStyle style;

  /// The child nodes inside this styled span.
  final List<TypesetNode> children;

  @override
  String toString() => 'Style($style, $children)';
}
