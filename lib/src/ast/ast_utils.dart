import 'package:typeset/src/ast/nodes.dart';

/// Appends text to [out], coalescing with the previous node if it's a
/// [TypesetTextNode].
void appendTextNode(List<TypesetNode> out, String text) {
  if (text.isEmpty) return;

  final last = out.isEmpty ? null : out.last;
  if (last is TypesetTextNode) {
    out[out.length - 1] = TypesetTextNode(last.text + text);
  } else {
    out.add(TypesetTextNode(text));
  }
}
