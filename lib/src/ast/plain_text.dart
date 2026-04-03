import 'package:typeset/src/ast/nodes.dart';

/// Returns the visible plain-text representation of parsed [nodes].
String typesetPlainText(Iterable<TypesetNode> nodes) {
  final buffer = StringBuffer();

  void writeNodes(Iterable<TypesetNode> currentNodes) {
    for (final node in currentNodes) {
      switch (node) {
        case TypesetTextNode():
          buffer.write(node.text);
        case TypesetCodeNode():
          buffer.write(node.code);
        case TypesetStyleNode():
          writeNodes(node.children);
        case TypesetLinkNode():
          writeNodes(node.label);
      }
    }
  }

  writeNodes(nodes);
  return buffer.toString();
}
