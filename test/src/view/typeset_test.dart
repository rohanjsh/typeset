import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typeset/typeset.dart';

import '../../helpers/span_test_helpers.dart';

import 'typeset_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(TypeSetGlobalConfig.reset);
  tearDown(TypeSetGlobalConfig.reset);

  group(
    'Tests for TypeSet Widget',
    () {
      testWidgets(
        'TypeSet widget displays bold, italic, and strikethrough text',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const TypeSetTest(
              title:
                  'Hello, *World* _World_ ~World~ //hello// [hello](https://google.com)',
              key: Key(
                'typeset_widget_test',
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          );

          final boldItalicUnderlineText = find.byKey(
            const Key(
              'typeset_widget_test',
            ),
          );

          expect(
            boldItalicUnderlineText,
            findsOneWidget,
          );
        },
      );
    },
  );

  group('Tests for TypeSetExtension', () {
    testWidgets(
      'TypeSet widget displays through extension',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const TypeSetTest(
            titleForExt: 'Hello World',
            key: Key(
              'extensionTest',
            ),
          ),
        );

        final extensionTest = find.byKey(
          const Key(
            'extensionTest',
          ),
        );
        expect(
          extensionTest,
          findsOneWidget,
        );
      },
    );

    testWidgets('TypeSet extension forwards the widget key', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: 'Hello World'.typeset(key: const Key('typeset-extension-key')),
        ),
      );

      expect(find.byKey(const Key('typeset-extension-key')), findsOneWidget);
    });

    test('plainText returns rendered plain text', () {
      expect(
        'Hello *world* and __underlined__ text'.plainText,
        'Hello world and underlined text',
      );
      expect(
        r'\*literal\* and _open'.plainText,
        '*literal* and _open',
      );
      expect(
        'Keep * spaced* literal in v3'.plainText,
        'Keep * spaced* literal in v3',
      );
    });
  });

  testWidgets('TypeSet disposes link recognizers on rebuild and unmount', (
    tester,
  ) async {
    final createdRecognizers = <TrackingTapGestureRecognizer>[];
    final config = TypeSetConfig(
      autoLinkConfig: TypeSetAutoLinkConfig(
        linkRecognizerBuilder: (linkText, url) {
          final recognizer = TrackingTapGestureRecognizer();
          createdRecognizers.add(recognizer);
          return recognizer;
        },
      ),
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: TypeSet('Visit https://example.com', config: config),
      ),
    );

    expect(createdRecognizers, hasLength(1));
    expect(createdRecognizers.first.isDisposed, isFalse);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: TypeSet('Visit https://flutter.dev', config: config),
      ),
    );

    expect(createdRecognizers, hasLength(2));
    expect(createdRecognizers.first.isDisposed, isTrue);
    expect(createdRecognizers.last.isDisposed, isFalse);

    await tester.pumpWidget(const SizedBox.shrink());

    expect(createdRecognizers.last.isDisposed, isTrue);
  });

  testWidgets('TypeSet exposes link semantics for tappable autolinks', (
    tester,
  ) async {
    final semanticsHandle = tester.ensureSemantics();

    final config = TypeSetConfig(
      autoLinkConfig: TypeSetAutoLinkConfig(
        linkRecognizerBuilder: (linkText, url) =>
            TapGestureRecognizer()..onTap = () {},
      ),
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: TypeSet('Visit https://example.com now', config: config),
      ),
    );

    expect(
      tester.getSemantics(find.byType(RichText)),
      matchesSemantics(
        children: <Matcher>[
          matchesSemantics(label: 'Visit ', textDirection: TextDirection.ltr),
          matchesSemantics(
            label: 'https://example.com',
            textDirection: TextDirection.ltr,
            isLink: true,
            hasTapAction: true,
          ),
          matchesSemantics(label: ' now', textDirection: TextDirection.ltr),
        ],
      ),
    );

    semanticsHandle.dispose();
  });

  testWidgets('TypeSet merges local, scoped, and global config fields', (
    tester,
  ) async {
    TypeSetGlobalConfig.current = const TypeSetConfig(
      style: TypeSetStyle(
        linkStyle: TextStyle(color: Colors.green),
      ),
    );

    final localConfig = TypeSetConfig(
      style: const TypeSetStyle(
        boldStyle: TextStyle(fontWeight: FontWeight.w900),
      ),
      autoLinkConfig: TypeSetAutoLinkConfig(
        linkRecognizerBuilder: (linkText, url) =>
            TapGestureRecognizer()..onTap = () {},
      ),
    );
    final scopedConfig = TypeSetConfig(
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
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: TypeSetConfigProvider(
          config: scopedConfig,
          child: TypeSet(
            'Visit https://example.com and https://flutter.dev with *bold* and _italic_',
            config: localConfig,
          ),
        ),
      ),
    );

    final richText = tester.widget<RichText>(find.byType(RichText));
    final root = richText.text as TextSpan;

    final bold = _findLeafTextSpan(root, 'bold');
    expect(bold.style?.fontWeight, FontWeight.w900);

    final italic = _findLeafTextSpan(root, 'italic');
    expect(italic.style?.fontStyle, FontStyle.italic);
    expect(italic.style?.color, Colors.purple);

    final recognizedSpans = collectRecognizedTextSpans(root);
    expect(recognizedSpans, hasLength(1));

    final flutterDev = recognizedSpans.single;
    expect(inlineSpanPlainText(flutterDev), 'https://flutter.dev');
    expect(flutterDev.style?.color, Colors.green);
    expect(flutterDev.recognizer, isNotNull);
  });

  testWidgets(
    'TypeSet uses theme defaults and lets global config override them',
    (tester) async {
      const codeBackground = Color(0xFFE0E0E0);
      const codeForeground = Color(0xFF7B1FA2);

      TypeSetGlobalConfig.current = const TypeSetConfig(
        style: TypeSetStyle(
          linkStyle: TextStyle(color: Colors.green),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.light(
              primary: Colors.orange,
              outline: Colors.teal,
              onSurfaceVariant: codeForeground,
              surfaceContainerHighest: codeBackground,
            ),
          ),
          home: const Scaffold(
            body: TypeSet('Visit https://flutter.dev and use `code`'),
          ),
        ),
      );

      final richText = tester.widget<RichText>(find.byType(RichText));
      final root = richText.text as TextSpan;
      final leaves = collectRenderedTextLeaves(<InlineSpan>[root]);
      final link = leaves.singleWhere(
        (candidate) => candidate.text == 'https://flutter.dev',
      );
      final code = leaves.singleWhere((candidate) => candidate.text == 'code');

      expect(link.style.color, Colors.green);
      expect(code.style.backgroundColor, codeBackground);
      expect(code.style.color, codeForeground);
    },
  );

  testWidgets(
    'TypeSet applies link policy and adds recognizers at render time',
    (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: TypeSet(
            'Visit https://example.com and https://flutter.dev',
            config: TypeSetConfig(
              autoLinkConfig: TypeSetAutoLinkConfig(
                allowedSchemes: const {'https'},
                allowedDomains: RegExp(r'^flutter\.dev$'),
                linkRecognizerBuilder: (linkText, url) =>
                    TapGestureRecognizer()..onTap = () {},
              ),
            ),
          ),
        ),
      );

      final richText = tester.widget<RichText>(find.byType(RichText));
      final root = richText.text as TextSpan;
      final recognizedSpans = collectRecognizedTextSpans(root);

      expect(recognizedSpans, hasLength(1));
      expect(
        inlineSpanPlainText(recognizedSpans.single),
        'https://flutter.dev',
      );
    },
  );
}

final class TrackingTapGestureRecognizer extends TapGestureRecognizer {
  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}

TextSpan _findLeafTextSpan(InlineSpan span, String text) {
  return collectLeafTextSpans(span)
      .singleWhere((candidate) => candidate.text == text);
}
