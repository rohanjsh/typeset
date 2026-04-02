import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typeset/src/core/typeset_span_utils.dart';
import 'package:typeset/typeset.dart';

void main() {
  group('TypeSetEditingController', () {
    late TypeSetEditingController controller;

    TextSpan buildSpan(
      TypeSetEditingController controller, {
      TextStyle? style,
      bool withComposing = false,
    }) {
      late TextSpan result;
      runApp(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              result = controller.buildTextSpan(
                context: context,
                style: style ?? const TextStyle(),
                withComposing: withComposing,
              );
              return Container();
            },
          ),
        ),
      );
      return result;
    }

    Future<TextSpan> pumpSpan(
      WidgetTester tester,
      TypeSetEditingController controller, {
      TextStyle? style,
      bool withComposing = false,
    }) async {
      late TextSpan result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              result = controller.buildTextSpan(
                context: context,
                style: style ?? const TextStyle(),
                withComposing: withComposing,
              );
              return Container();
            },
          ),
        ),
      );
      return result;
    }

    setUp(() {
      TypeSetGlobalConfig.reset();
      controller = TypeSetEditingController();
    });

    tearDown(() {
      controller.dispose();
      TypeSetGlobalConfig.reset();
    });

    test('rejects negative maxLiveFormattingLength', () {
      expect(
        () => TypeSetEditingController(maxLiveFormattingLength: -1),
        throwsArgumentError,
      );
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

    testWidgets('falls back to plain text for oversized input', (tester) async {
      await tester.pumpWidget(Container());
      controller.dispose();
      controller = TypeSetEditingController(maxLiveFormattingLength: 5)
        ..text = 'Hello *world*';

      final span = buildSpan(controller);
      final leaves = collectLeafTextSpans(span);

      expect(leaves, hasLength(1));
      expect(leaves.single.text, 'Hello *world*');
    });

    testWidgets('resumes formatting after text drops below the guard', (
      tester,
    ) async {
      controller.dispose();
      controller = TypeSetEditingController(maxLiveFormattingLength: 8)
        ..text = 'Hello *world*';

      final oversized = await pumpSpan(tester, controller);
      expect(collectLeafTextSpans(oversized).single.text, 'Hello *world*');

      controller.text = 'Hi *x*';
      final formatted = await pumpSpan(tester, controller);
      final leaves = collectLeafTextSpans(formatted);

      expect(leaves.map((leaf) => leaf.text), ['Hi ', '*', 'x', '*']);
      expect(
        leaves.singleWhere((leaf) => leaf.text == 'x').style?.fontWeight,
        FontWeight.bold,
      );
    });

    testWidgets('applies bold formatting', (tester) async {
      await tester.pumpWidget(Container());
      controller.text = 'This is *bold* text';
      final span = buildSpan(controller);
      expect(span.children, isNotNull);
      // Theme integration provides markerColor, so markers are separate spans:
      // 'This is ' + '*' + 'bold' + '*' + ' text'
      final leaves = collectLeafTextSpans(span);
      expect(
        leaves.map((l) => l.text).toList(),
        ['This is ', '*', 'bold', '*', ' text'],
      );
      final bold = leaves.singleWhere((l) => l.text == 'bold');
      expect(bold.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('applies italic formatting', (tester) async {
      await tester.pumpWidget(Container());
      controller.text = 'This is _italic_ text';
      final span = buildSpan(controller);
      final leaves = collectLeafTextSpans(span);
      expect(
        leaves.map((l) => l.text).toList(),
        ['This is ', '_', 'italic', '_', ' text'],
      );
      final italic = leaves.singleWhere((l) => l.text == 'italic');
      expect(italic.style?.fontStyle, FontStyle.italic);
    });

    testWidgets('applies underline formatting', (tester) async {
      await tester.pumpWidget(Container());
      controller.text = 'This is __underline__ text';
      final span = buildSpan(controller);
      final leaves = collectLeafTextSpans(span);
      expect(
        leaves.map((l) => l.text).toList(),
        ['This is ', '__', 'underline', '__', ' text'],
      );
      final underline = leaves.singleWhere((l) => l.text == 'underline');
      expect(underline.style?.decoration, TextDecoration.underline);
    });

    testWidgets('applies strikethrough formatting', (tester) async {
      await tester.pumpWidget(Container());
      controller.text = 'This is ~strikethrough~ text';
      final span = buildSpan(controller);
      final leaves = collectLeafTextSpans(span);
      expect(
        leaves.map((l) => l.text).toList(),
        ['This is ', '~', 'strikethrough', '~', ' text'],
      );
      final strike = leaves.singleWhere((l) => l.text == 'strikethrough');
      expect(strike.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('applies inline code formatting', (tester) async {
      await tester.pumpWidget(Container());
      controller.text = 'This is `code` text';
      final span = buildSpan(controller);
      final leaves = collectLeafTextSpans(span);
      expect(
        leaves.map((l) => l.text).toList(),
        ['This is ', '`', 'code', '`', ' text'],
      );
      final code = leaves.singleWhere((l) => l.text == 'code');
      expect(code.style?.fontFamily, 'Courier');
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
      // Link color comes from theme's colorScheme.primary
      expect(linkSpan.style?.color, isNotNull);
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
      final leaves = collectLeafTextSpans(span);
      // Markers are separate spans due to theme markerColor.
      // Verify that 'This is ' is the first leaf text
      expect(leaves.first.text, 'This is ');
      // Verify nested formatting is present (italic inside bold)
      final hasItalic =
          leaves.any((l) => l.style?.fontStyle == FontStyle.italic);
      expect(hasItalic, isTrue);
      // Verify bold is present
      final hasBold = leaves.any((l) => l.style?.fontWeight == FontWeight.bold);
      expect(hasBold, isTrue);
    });

    testWidgets('handles multiple formatting types', (tester) async {
      await tester.pumpWidget(Container());
      controller.text = 'This is *bold* and _italic_ text';
      final span = buildSpan(controller);
      final leaves = collectLeafTextSpans(span);
      // With theme markerColor, markers are separate spans.
      expect(
        leaves.map((l) => l.text).toList(),
        [
          'This is ', '*', 'bold', '*', //
          ' and ', '_', 'italic', '_', ' text',
        ],
      );
      final bold = leaves.singleWhere((l) => l.text == 'bold');
      expect(bold.style?.fontWeight, FontWeight.bold);
      final italic = leaves.singleWhere((l) => l.text == 'italic');
      expect(italic.style?.fontStyle, FontStyle.italic);
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

    testWidgets('underlines the composing range while preserving formatting', (
      tester,
    ) async {
      controller.value = const TextEditingValue(
        text: 'This is *bold* text',
        selection: TextSelection.collapsed(offset: 19),
        composing: TextRange(start: 9, end: 13),
      );

      final span = await pumpSpan(tester, controller, withComposing: true);
      final leaves = collectLeafTextSpans(span);

      // With theme markerColor, markers are separate spans:
      // 'This is ' + '*' + 'bold' + '*' + ' text'
      expect(
        leaves.map((leaf) => leaf.text),
        ['This is ', '*', 'bold', '*', ' text'],
      );
      // 'This is ' should not be underlined
      expect(leaves[0].style?.decoration, isNot(TextDecoration.underline));
      // '*' (opening marker at offset 8) — not in composing range [9,13]
      expect(leaves[1].style?.decoration, isNot(TextDecoration.underline));
      // 'bold' (offsets 9-12) — inside composing range [9,13]
      expect(leaves[2].style?.fontWeight, FontWeight.bold);
      expect(leaves[2].style?.decoration, TextDecoration.underline);
      // '*' (closing marker at offset 13) — end of composing range
      // '* text' should not be underlined
      expect(leaves[4].style?.decoration, isNot(TextDecoration.underline));
    });

    testWidgets('ignores collapsed composing ranges', (tester) async {
      controller.value = const TextEditingValue(
        text: 'Hello World',
        selection: TextSelection.collapsed(offset: 11),
        composing: TextRange.collapsed(5),
      );

      final span = await pumpSpan(tester, controller, withComposing: true);
      final leaves = collectLeafTextSpans(span);

      expect(leaves, hasLength(1));
      expect(leaves.single.text, 'Hello World');
      expect(leaves.single.style?.decoration, isNot(TextDecoration.underline));
    });

    testWidgets('ignores composing when withComposing is false',
        (tester) async {
      controller.value = const TextEditingValue(
        text: 'Hello',
        selection: TextSelection.collapsed(offset: 5),
        composing: TextRange(start: 1, end: 4),
      );

      final span = await pumpSpan(tester, controller);
      final leaves = collectLeafTextSpans(span);

      expect(leaves, hasLength(1));
      expect(leaves.single.text, 'Hello');
      expect(leaves.single.style?.decoration, isNot(TextDecoration.underline));
    });

    testWidgets('disposes link recognizers across rebuilds and dispose', (
      tester,
    ) async {
      final createdRecognizers = <TrackingTapGestureRecognizer>[];
      final trackingController = TypeSetEditingController(
        text: 'Visit https://example.com',
        config: TypeSetConfig(
          autoLinkConfig: TypeSetAutoLinkConfig(
            linkRecognizerBuilder: (linkText, url) {
              final recognizer = TrackingTapGestureRecognizer();
              createdRecognizers.add(recognizer);
              return recognizer;
            },
          ),
        ),
      );

      await pumpSpan(tester, trackingController);

      expect(createdRecognizers, hasLength(1));
      expect(createdRecognizers.single.isDisposed, isFalse);

      await pumpSpan(tester, trackingController);

      expect(createdRecognizers, hasLength(2));
      expect(createdRecognizers.first.isDisposed, isTrue);
      expect(createdRecognizers.last.isDisposed, isFalse);

      trackingController.dispose();

      expect(createdRecognizers.last.isDisposed, isTrue);
    });

    testWidgets('merges local, scoped, and global config fields', (
      tester,
    ) async {
      TypeSetGlobalConfig.current = const TypeSetConfig(
        style: TypeSetStyle(
          linkStyle: TextStyle(color: Colors.green),
        ),
      );

      controller.dispose();
      controller = TypeSetEditingController(
        text:
            'Visit https://example.com and https://flutter.dev with *bold* and _italic_',
        config: TypeSetConfig(
          style: const TypeSetStyle(
            boldStyle: TextStyle(fontWeight: FontWeight.w900),
          ),
          autoLinkConfig: TypeSetAutoLinkConfig(
            linkRecognizerBuilder: (linkText, url) =>
                TapGestureRecognizer()..onTap = () {},
          ),
        ),
      );

      late TextSpan span;
      await tester.pumpWidget(
        MaterialApp(
          home: TypeSetConfigProvider(
            config: TypeSetConfig(
              style: const TypeSetStyle(
                italicStyle: TextStyle(
                  color: Colors.purple,
                  fontStyle: FontStyle.italic,
                ),
              ),
              autoLinkConfig: TypeSetAutoLinkConfig(
                allowedSchemes: const {'https'},
                allowedDomains: RegExp(r'^flutter\.dev$'),
              ),
            ),
            child: Builder(
              builder: (BuildContext context) {
                span = controller.buildTextSpan(
                  context: context,
                  style: const TextStyle(),
                  withComposing: false,
                );
                return Container();
              },
            ),
          ),
        ),
      );

      final leaves = collectLeafTextSpans(span);
      final bold = leaves.singleWhere((leaf) => leaf.text == 'bold');
      expect(bold.style?.fontWeight, FontWeight.w900);

      final italic = leaves.singleWhere((leaf) => leaf.text == 'italic');
      expect(italic.style?.fontStyle, FontStyle.italic);
      expect(italic.style?.color, Colors.purple);

      final recognizedSpans = collectRecognizedTextSpans(span);
      expect(recognizedSpans, hasLength(1));

      final flutterDev = recognizedSpans.single;
      expect(inlineSpanPlainText(flutterDev), 'https://flutter.dev');
      expect(flutterDev.style?.color, Colors.green);
      expect(flutterDev.recognizer, isNotNull);
    });
  });
}

final class TrackingTapGestureRecognizer extends TapGestureRecognizer {
  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
