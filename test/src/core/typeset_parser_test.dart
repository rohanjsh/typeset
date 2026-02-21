import 'package:flutter_test/flutter_test.dart';
import 'package:typeset/src/core/parser/typeset_parser.dart';
import 'package:typeset/src/models/ast/typeset_nodes.dart';
import 'package:typeset/src/models/typeset_autolink_config.dart';

void main() {
  group('TypesetParser behavior', () {
    const parser = TypesetParser();

    test('Hello *world*', () {
      final nodes = parser.parse(
        'Hello *world*',
        autoLinkConfig: TypeSetAutoLinkConfig.disabled,
      );
      expect(nodes.length, 2);
      expect(nodes[0], isA<TypesetTextNode>());
      expect((nodes[0] as TypesetTextNode).text, 'Hello ');
      final style = nodes[1] as TypesetStyleNode;
      expect(style.style, TypesetStyle.bold);
      expect((style.children.single as TypesetTextNode).text, 'world');
    });

    test('A __b _c_ d__ (nesting + precedence)', () {
      final nodes = parser.parse(
        'A __b _c_ d__',
        autoLinkConfig: TypeSetAutoLinkConfig.disabled,
      );
      expect((nodes[0] as TypesetTextNode).text, 'A ');

      final underline = nodes[1] as TypesetStyleNode;
      expect(underline.style, TypesetStyle.underline);
      expect(_plainText(underline.children), 'b c d');

      // Ensure italic node exists inside underline.
      expect(
        underline.children.whereType<TypesetStyleNode>().single.style,
        TypesetStyle.italic,
      );
    });

    test('Inline code binds strongest: Use `*literal*` here', () {
      final nodes = parser.parse(
        'Use `*literal*` here',
        autoLinkConfig: TypeSetAutoLinkConfig.disabled,
      );
      expect(_plainText(nodes), 'Use *literal* here');
      expect(nodes.whereType<TypesetCodeNode>().length, 1);
      expect(nodes.whereType<TypesetStyleNode>(), isEmpty);
    });

    test('Visit https://example.com. (autolink trims trailing .)', () {
      final nodes = parser.parse('Visit https://example.com.');
      expect(_plainText(nodes), 'Visit https://example.com.');
      final link = nodes.whereType<TypesetLinkNode>().single;
      expect(link.url, 'https://example.com');
      expect(_plainText(link.label), 'https://example.com');
    });

    test('Unclosed *bold degrades to literal', () {
      final nodes = parser.parse(
        'Unclosed *bold',
        autoLinkConfig: TypeSetAutoLinkConfig.disabled,
      );
      expect(_plainText(nodes), 'Unclosed *bold');
      expect(nodes.whereType<TypesetStyleNode>(), isEmpty);
    });

    test(r'Escaping: \* renders literal * (no bold)', () {
      final nodes = parser.parse(
        r'Hello \*world\*',
        autoLinkConfig: TypeSetAutoLinkConfig.disabled,
      );
      expect(_plainText(nodes), 'Hello *world*');
      expect(nodes.whereType<TypesetStyleNode>(), isEmpty);
    });

    test('Invalid crossing: *bold _bad* ital_ (no bold)', () {
      final nodes = parser.parse(
        '*bold _bad* ital_',
        autoLinkConfig: TypeSetAutoLinkConfig.disabled,
      );
      expect(_plainText(nodes), '*bold bad* ital');
      expect(
        nodes
            .whereType<TypesetStyleNode>()
            .any((n) => n.style == TypesetStyle.bold),
        isFalse,
      );
      expect(
        nodes
            .whereType<TypesetStyleNode>()
            .any((n) => n.style == TypesetStyle.italic),
        isTrue,
      );
    });

    test('Autolink does not run inside inline code', () {
      final nodes = parser.parse('Use `https://example.com`');
      expect(nodes.whereType<TypesetLinkNode>(), isEmpty);
      expect(_plainText(nodes), 'Use https://example.com');
    });
  });
}

String _plainText(List<TypesetNode> nodes) {
  final sb = StringBuffer();
  for (final n in nodes) {
    switch (n) {
      case TypesetTextNode():
        sb.write(n.text);
      case TypesetCodeNode():
        sb.write(n.code);
      case TypesetStyleNode():
        sb.write(_plainText(n.children));
      case TypesetLinkNode():
        sb.write(_plainText(n.label));
    }
  }
  return sb.toString();
}
