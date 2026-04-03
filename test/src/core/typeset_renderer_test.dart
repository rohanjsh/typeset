import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typeset/src/parser/parser.dart';
import 'package:typeset/src/renderer/renderer.dart';
import 'package:typeset/typeset.dart';

void main() {
  group('TypesetRenderer', () {
    const parser = TypesetParser();

    test('renders bold', () {
      final nodes = parser.parse(
        'Hello *world*',
        autoLinkConfig: TypeSetAutoLinkConfig.disabled,
      );
      final spans = const TypesetRenderer().render(nodes);

      expect(spans, hasLength(2));
      expect((spans[0] as TextSpan).text, 'Hello ');
      final bold = spans[1] as TextSpan;
      expect(bold.text, 'world');
      expect(bold.style?.fontWeight, FontWeight.bold);
    });

    test('combines underline + strikethrough when nested', () {
      final nodes = parser.parse(
        'A __b ~c~ d__',
        autoLinkConfig: TypeSetAutoLinkConfig.disabled,
      );
      final spans = const TypesetRenderer().render(nodes);
      final leaves = _collectLeaves(spans);

      final c = leaves.singleWhere((s) => s.text == 'c');
      final dec = c.style?.decoration;
      expect(dec, isNotNull);
      expect(dec!.contains(TextDecoration.underline), isTrue);
      expect(dec.contains(TextDecoration.lineThrough), isTrue);
    });

    test('renders links with a single recognizer (opt-in)', () {
      var calls = 0;
      final autoLinkConfig = TypeSetAutoLinkConfig(
        linkRecognizerBuilder: (text, url) {
          calls += 1;
          return TapGestureRecognizer()..onTap = () {};
        },
      );
      final renderer = TypesetRenderer(autoLinkConfig: autoLinkConfig);

      final nodes = parser.parse('Visit https://example.com');
      final spans = renderer.render(nodes);
      expect(calls, 1);

      expect(spans, hasLength(2)); // 'Visit ', link
      final link = spans[1] as TextSpan;
      expect(link.recognizer, isNotNull);
      expect(_plainTextFromSpan(link), 'https://example.com');
    });
  });

  testWidgets('TypeSet builds RichText', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: TypeSet('Hello *world*'),
      ),
    );

    final richText = tester.widget<RichText>(find.byType(RichText));
    final root = richText.text as TextSpan;
    expect(_plainTextFromSpan(root), 'Hello world');
  });
}

List<TextSpan> _collectLeaves(List<InlineSpan> spans) {
  final out = <TextSpan>[];
  for (final s in spans) {
    if (s is! TextSpan) continue;
    final children = s.children;
    if (children == null || children.isEmpty) {
      if (s.text != null && s.text!.isNotEmpty) out.add(s);
      continue;
    }
    out.addAll(_collectLeaves(children));
  }
  return out;
}

String _plainTextFromSpan(InlineSpan span) {
  if (span is TextSpan) {
    final sb = StringBuffer();
    if (span.text != null) sb.write(span.text);
    final children = span.children;
    if (children != null) {
      for (final c in children) {
        sb.write(_plainTextFromSpan(c));
      }
    }
    return sb.toString();
  }
  return '';
}
