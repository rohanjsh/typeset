import 'package:flutter_test/flutter_test.dart';
import 'package:typeset/src/ast/nodes.dart';
import 'package:typeset/src/config/autolink_config.dart';
import 'package:typeset/src/parser/parser.dart';

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

    test('Strict flanking rejects leading inner whitespace', () {
      final nodes = parser.parse(
        'Keep * spaced* literal',
        autoLinkConfig: TypeSetAutoLinkConfig.disabled,
      );

      expect(_plainText(nodes), 'Keep * spaced* literal');
      expect(nodes.whereType<TypesetStyleNode>(), isEmpty);
    });

    test('Strict flanking rejects trailing inner whitespace', () {
      final nodes = parser.parse(
        'Keep *spaced * literal',
        autoLinkConfig: TypeSetAutoLinkConfig.disabled,
      );

      expect(_plainText(nodes), 'Keep *spaced * literal');
      expect(nodes.whereType<TypesetStyleNode>(), isEmpty);
    });

    test('Strict flanking applies to underline and strikethrough too', () {
      final nodes = parser.parse(
        'Use __underlined__ but keep __ spaced__ and ~spaced ~ literal',
        autoLinkConfig: TypeSetAutoLinkConfig.disabled,
      );

      final styles = nodes.whereType<TypesetStyleNode>().toList();
      expect(styles, hasLength(1));
      expect(styles.single.style, TypesetStyle.underline);
      expect(
        _plainText(nodes),
        'Use underlined but keep __ spaced__ and ~spaced ~ literal',
      );
    });

    test('Markers followed by whitespace do not open formatting', () {
      final nodes = parser.parse(
        '* item',
        autoLinkConfig: TypeSetAutoLinkConfig.disabled,
      );

      expect(_plainText(nodes), '* item');
      expect(nodes.whereType<TypesetStyleNode>(), isEmpty);
    });

    test('Visit https://example.com. (autolink trims trailing .)', () {
      final nodes = parser.parse('Visit https://example.com.');
      expect(_plainText(nodes), 'Visit https://example.com.');
      final link = nodes.whereType<TypesetLinkNode>().single;
      expect(link.url, 'https://example.com');
      expect(_plainText(link.label), 'https://example.com');
    });

    test('Autolink keeps ports, query strings, and fragments', () {
      final nodes = parser.parse(
        'Use https://example.com:8080/path?q=ok#section today',
      );

      final link = nodes.whereType<TypesetLinkNode>().single;
      expect(
        link.url,
        'https://example.com:8080/path?q=ok#section',
      );
      expect(
        _plainText(link.label),
        'https://example.com:8080/path?q=ok#section',
      );
    });

    test('Autolink normalizes www links to https', () {
      final nodes = parser.parse('Open www.example.com/docs now');

      final link = nodes.whereType<TypesetLinkNode>().single;
      expect(link.url, 'https://www.example.com/docs');
      expect(_plainText(link.label), 'www.example.com/docs');
    });

    test('Autolink trims trailing punctuation without losing the link', () {
      final nodes = parser.parse(
        'See https://example.com/path, https://flutter.dev! and https://dart.dev?',
      );

      final links = nodes.whereType<TypesetLinkNode>().toList();
      expect(links, hasLength(3));
      expect(links[0].url, 'https://example.com/path');
      expect(links[1].url, 'https://flutter.dev');
      expect(links[2].url, 'https://dart.dev');
      expect(
        _plainText(nodes),
        'See https://example.com/path, https://flutter.dev! and https://dart.dev?',
      );
    });

    test('Autolink keeps balanced closing parentheses inside the URL', () {
      final nodes = parser.parse(
        'Read https://example.com/api(v2) for details',
      );

      final link = nodes.whereType<TypesetLinkNode>().single;
      expect(link.url, 'https://example.com/api(v2)');
      expect(_plainText(link.label), 'https://example.com/api(v2)');
    });

    test('Autolink keeps balanced closing brackets inside the URL', () {
      final nodes = parser.parse(
        'Open https://example.com/docs[preview] today',
      );

      final link = nodes.whereType<TypesetLinkNode>().single;
      expect(link.url, 'https://example.com/docs[preview]');
      expect(_plainText(link.label), 'https://example.com/docs[preview]');
    });

    test('Autolink still trims unmatched trailing parenthesis', () {
      final nodes = parser.parse('Visit (https://example.com/path) now');

      final link = nodes.whereType<TypesetLinkNode>().single;
      expect(link.url, 'https://example.com/path');
      expect(_plainText(nodes), 'Visit (https://example.com/path) now');
    });

    test('Autolink trims excess closing brackets and punctuation', () {
      final nodes = parser.parse(
        'Read https://example.com/docs[preview]]). next',
      );

      final link = nodes.whereType<TypesetLinkNode>().single;
      expect(link.url, 'https://example.com/docs[preview]');
      expect(
        _plainText(nodes),
        'Read https://example.com/docs[preview]]). next',
      );
    });

    test('Autolink does not match URLs embedded inside larger tokens', () {
      const input =
          'Keep abchttps://example.com and user@www.example.com literal';

      final nodes = parser.parse(input);

      expect(nodes.whereType<TypesetLinkNode>(), isEmpty);
      expect(_plainText(nodes), input);
    });

    test('Autolink trims angle brackets and quotes around URLs', () {
      final nodes = parser.parse(
        'See <https://example.com> and "https://flutter.dev"',
      );

      final links = nodes.whereType<TypesetLinkNode>().toList();
      expect(links, hasLength(2));
      expect(links[0].url, 'https://example.com');
      expect(links[1].url, 'https://flutter.dev');
      expect(
        _plainText(nodes),
        'See <https://example.com> and "https://flutter.dev"',
      );
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

    test('Dangling escape at end degrades to a literal backslash', () {
      final input = 'Ends with slash ${String.fromCharCode(0x5C)}';

      final nodes = parser.parse(
        input,
        autoLinkConfig: TypeSetAutoLinkConfig.disabled,
      );

      expect(_plainText(nodes), input);
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

    test('Nested valid formatting still works with strict flanking', () {
      final nodes = parser.parse(
        'A *bold _italic_ tail*',
        autoLinkConfig: TypeSetAutoLinkConfig.disabled,
      );

      final bold = nodes.whereType<TypesetStyleNode>().single;
      expect(bold.style, TypesetStyle.bold);
      expect(_plainText(nodes), 'A bold italic tail');
      expect(
        bold.children.whereType<TypesetStyleNode>().single.style,
        TypesetStyle.italic,
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
