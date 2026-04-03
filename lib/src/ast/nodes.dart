/// Base class for all parsed AST nodes.
sealed class TypesetNode {
  /// Creates a node.
  const TypesetNode();
}

/// Plain text with no formatting.
final class TypesetTextNode extends TypesetNode {
  /// Creates a text node.
  const TypesetTextNode(this.text);

  /// The raw text content.
  final String text;

  @override
  String toString() => 'Text("$text")';
}

/// Inline code — content is treated as literal, never parsed further.
final class TypesetCodeNode extends TypesetNode {
  /// Creates a code node.
  const TypesetCodeNode(this.code);

  /// The code content (sans backticks).
  final String code;

  @override
  String toString() => 'Code("$code")';
}

/// A detected link with a styled label.
final class TypesetLinkNode extends TypesetNode {
  /// Creates a link node.
  const TypesetLinkNode({required this.url, required this.label});

  /// The resolved URL.
  final String url;

  /// The visible label (may contain nested formatting).
  final List<TypesetNode> label;

  @override
  String toString() => 'Link(url: $url, label: $label)';
}

/// Supported inline formatting styles.
enum TypesetStyle {
  /// Bold formatting (`*text*`).
  bold,

  /// Italic formatting (`_text_`).
  italic,

  /// Underline formatting (`__text__`).
  underline,

  /// Strikethrough formatting (`~text~`).
  strikethrough,
}

/// A styled span wrapping child nodes.
final class TypesetStyleNode extends TypesetNode {
  /// Creates a style node.
  const TypesetStyleNode({required this.style, required this.children});

  /// The formatting style applied.
  final TypesetStyle style;

  /// The child nodes within this styled span.
  final List<TypesetNode> children;

  @override
  String toString() => 'Style($style, $children)';
}
