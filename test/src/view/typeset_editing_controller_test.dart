import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typeset/typeset.dart';

void main() {
  group('TypeSetEditingController', () {
    late TypeSetEditingController controller;

    TextSpan buildSpan(
      TypeSetEditingController controller, {
      TextStyle? style,
    }) {
      late TextSpan result;
      runApp(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              result = controller.buildTextSpan(
                context: context,
                style: style ?? const TextStyle(),
                withComposing: false,
              );
              return Container();
            },
          ),
        ),
      );
      return result;
    }

    setUp(() {
      controller = TypeSetEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('returns empty span for empty text', (tester) async {
      await tester.pumpWidget(Container());
      final span = buildSpan(controller);
      expect(span.children, isNull);
    });

    testWidgets('handles plain text without formatting', (tester) async {
      await tester.pumpWidget(Container());
      controller.text = 'Hello World';
      final span = buildSpan(controller);
      expect(span.children?.length, 1);
      expect((span.children![0] as TextSpan).text, 'Hello World');
    });

    testWidgets('applies bold formatting', (tester) async {
      await tester.pumpWidget(Container());
      controller.text = 'This is *bold* text';
      final span = buildSpan(controller);
      expect(span.children, isNotNull);
      final children = span.children!;
      expect(children.length, 3);
      expect((children[0] as TextSpan).text, 'This is *');
      expect((children[1] as TextSpan).text, 'bold');
      expect(
        (children[1] as TextSpan).style?.fontWeight,
        FontWeight.bold,
      );
      expect((children[2] as TextSpan).text, '* text');
    });

    testWidgets('applies italic formatting', (tester) async {
      await tester.pumpWidget(Container());
      controller.text = 'This is _italic_ text';
      final span = buildSpan(controller);
      final children = span.children!;
      expect(children.length, 3);
      expect((children[0] as TextSpan).text, 'This is _');
      expect((children[1] as TextSpan).text, 'italic');
      expect(
        (children[1] as TextSpan).style?.fontStyle,
        FontStyle.italic,
      );
      expect((children[2] as TextSpan).text, '_ text');
    });

    testWidgets('applies underline formatting', (tester) async {
      await tester.pumpWidget(Container());
      controller.text = 'This is __underline__ text';
      final span = buildSpan(controller);
      final children = span.children!;
      expect(children.length, 3);
      expect((children[0] as TextSpan).text, 'This is __');
      expect((children[1] as TextSpan).text, 'underline');
      expect(
        (children[1] as TextSpan).style?.decoration,
        TextDecoration.underline,
      );
      expect((children[2] as TextSpan).text, '__ text');
    });

    testWidgets('applies strikethrough formatting', (tester) async {
      await tester.pumpWidget(Container());
      controller.text = 'This is ~strikethrough~ text';
      final span = buildSpan(controller);
      final children = span.children!;
      expect(children.length, 3);
      expect((children[0] as TextSpan).text, 'This is ~');
      expect((children[1] as TextSpan).text, 'strikethrough');
      expect(
        (children[1] as TextSpan).style?.decoration,
        TextDecoration.lineThrough,
      );
      expect((children[2] as TextSpan).text, '~ text');
    });

    testWidgets('applies inline code formatting', (tester) async {
      await tester.pumpWidget(Container());
      controller.text = 'This is `code` text';
      final span = buildSpan(controller);
      final children = span.children!;
      expect(children.length, 3);
      expect((children[0] as TextSpan).text, 'This is `');
      expect((children[1] as TextSpan).text, 'code');
      expect((children[1] as TextSpan).style?.fontFamily, 'Courier');
      expect((children[2] as TextSpan).text, '` text');
    });

    testWidgets('handles link formatting', (tester) async {
      await tester.pumpWidget(Container());
      controller.text = 'Visit https://example.com now';
      final span = buildSpan(controller);
      final children = span.children!;
      // AutoLink without delimiters: 'Visit ' + link + ' now'
      expect(children.length, 3);
      expect((children[0] as TextSpan).text, 'Visit ');
      // Link is rendered as a TextSpan with recognizer (no brackets)
      final linkSpan = children[1] as TextSpan;
      expect(linkSpan.text, isNull); // Link span has children, not direct text
      expect(linkSpan.children, isNotNull);
      expect(linkSpan.children!.length, 1);
      expect((linkSpan.children![0] as TextSpan).text, 'https://example.com');
      expect(
        linkSpan.style?.color,
        const Color(0xFF0000EE),
      );
      expect(
        linkSpan.style?.decoration,
        TextDecoration.underline,
      );
      expect((children[2] as TextSpan).text, ' now');
    });

    testWidgets('handles nested formatting', (tester) async {
      await tester.pumpWidget(Container());
      controller.text = 'This is *bold _and italic_* text';
      final span = buildSpan(controller);
      expect(span.children, isNotNull);
      final children = span.children!;
      // Verify we have at least 3 children
      expect(children.length, greaterThanOrEqualTo(3));
      // First child should be 'This is *'
      expect((children[0] as TextSpan).text, 'This is *');
      // Last child should be '* text'
      expect((children.last as TextSpan).text, '* text');
      // Verify nested formatting is present (italic inside bold)
      // by checking that some span has italic style
      final hasItalic = children.any((s) {
        final ts = s as TextSpan;
        return ts.style?.fontStyle == FontStyle.italic ||
            (ts.children?.any((c) {
                  final cs = c as TextSpan;
                  return cs.style?.fontStyle == FontStyle.italic;
                }) ??
                false);
      });
      expect(hasItalic, isTrue);
    });

    testWidgets('handles multiple formatting types', (tester) async {
      await tester.pumpWidget(Container());
      controller.text = 'This is *bold* and _italic_ text';
      final span = buildSpan(controller);
      final children = span.children!;
      expect(children.length, 5);
      expect((children[0] as TextSpan).text, 'This is *');
      expect((children[1] as TextSpan).text, 'bold');
      expect(
        (children[1] as TextSpan).style?.fontWeight,
        FontWeight.bold,
      );
      expect((children[2] as TextSpan).text, '* and _');
      expect((children[3] as TextSpan).text, 'italic');
      expect(
        (children[3] as TextSpan).style?.fontStyle,
        FontStyle.italic,
      );
      expect((children[4] as TextSpan).text, '_ text');
    });

    testWidgets('handles unmatched markers gracefully', (tester) async {
      await tester.pumpWidget(Container());
      controller.text = 'This is *unmatched text';
      final span = buildSpan(controller);
      // Unmatched markers should be treated as literal text
      expect(span.children, isNotNull);
      final children = span.children!;
      expect(children.length, 1);
      expect((children[0] as TextSpan).text, 'This is *unmatched text');
    });
  });
}
