// ignore_for_file: deprecated_member_use_from_same_package
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typeset/src/core/typeset_parser.dart';

import 'typeset_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
  });

  group('TypesetParser parseText', () {
    test('parses bold text', () {
      const inputText = 'This *word* is bold';
      final expectedSpans = [
        const TextSpan(
          text: 'This ',
          style: TextStyle(),
        ),
        const TextSpan(
          text: 'word ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const TextSpan(
          text: 'is ',
          style: TextStyle(),
        ),
        const TextSpan(
          text: 'bold',
          style: TextStyle(),
        ),
      ];
      expect(
        TypesetParser.parseText(inputText: inputText),
        equals(expectedSpans),
      );
    });

    test('parses italic text', () {
      const inputText = 'This _word_ is italic';
      final expectedSpans = [
        const TextSpan(
          text: 'This ',
          style: TextStyle(),
        ),
        const TextSpan(
          text: 'word ',
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
        const TextSpan(
          text: 'is ',
          style: TextStyle(),
        ),
        const TextSpan(
          text: 'italic',
          style: TextStyle(),
        ),
      ];
      expect(
        TypesetParser.parseText(inputText: inputText),
        equals(expectedSpans),
      );
    });

    test('parses underline text', () {
      const inputText = 'This //word// is underlined';
      final expectedSpans = [
        const TextSpan(
          text: 'This ',
          style: TextStyle(),
        ),
        const TextSpan(
          text: 'word ',
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
        const TextSpan(
          text: 'is ',
          style: TextStyle(),
        ),
        const TextSpan(
          text: 'underlined',
          style: TextStyle(),
        ),
      ];
      expect(
        TypesetParser.parseText(inputText: inputText),
        equals(expectedSpans),
      );
    });

    test('parses strikethrough text', () {
      const inputText = 'This ~word~ is strikethrough';
      final expectedSpans = [
        const TextSpan(
          text: 'This ',
          style: TextStyle(),
        ),
        const TextSpan(
          text: 'word ',
          style: TextStyle(
            decoration: TextDecoration.lineThrough,
          ),
        ),
        const TextSpan(
          text: 'is ',
          style: TextStyle(),
        ),
        const TextSpan(
          text: 'strikethrough',
          style: TextStyle(),
        ),
      ];
      expect(
        TypesetParser.parseText(inputText: inputText),
        equals(expectedSpans),
      );
    });

    test('parses link correctly', () {
      const inputText = '[Example|http://example.com]';

      final result = TypesetParser.parseText(inputText: inputText);

      expect(result.length, 1);
      final linkSpan = result[0];
      expect(linkSpan.text, 'Example');
      expect(linkSpan.style?.color, Colors.blue);
      expect(linkSpan.style?.decoration, TextDecoration.underline);
      expect(linkSpan.recognizer, isA<TapGestureRecognizer>());
    });
  });

  group('TypesetParser parser', () {
    test('parses bold text', () {
      const inputText = 'This *word* is bold';
      final expectedSpans = [
        const TextSpan(
          text: 'This ',
          style: TextStyle(),
        ),
        const TextSpan(
          text: 'word',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const TextSpan(
          text: ' is bold',
          style: TextStyle(),
        ),
      ];
      expect(
        TypesetParser.parser(inputText: inputText),
        equals(expectedSpans),
      );
    });

    test('parses italic text', () {
      const inputText = 'This _word_ is italic';
      final expectedSpans = [
        const TextSpan(
          text: 'This ',
          style: TextStyle(),
        ),
        const TextSpan(
          text: 'word',
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
        const TextSpan(
          text: ' is italic',
          style: TextStyle(),
        ),
      ];
      expect(
        TypesetParser.parser(inputText: inputText),
        equals(expectedSpans),
      );
    });

    test('parses underline text', () {
      const inputText = 'This #word# is underlined';
      final expectedSpans = [
        const TextSpan(
          text: 'This ',
          style: TextStyle(),
        ),
        const TextSpan(
          text: 'word',
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
        const TextSpan(
          text: ' is underlined',
          style: TextStyle(),
        ),
      ];
      expect(
        TypesetParser.parser(inputText: inputText),
        equals(expectedSpans),
      );
    });

    test('parses strikethrough text', () {
      const inputText = 'This ~word~ is strikethrough';
      final expectedSpans = [
        const TextSpan(
          text: 'This ',
          style: TextStyle(),
        ),
        const TextSpan(
          text: 'word',
          style: TextStyle(
            decoration: TextDecoration.lineThrough,
          ),
        ),
        const TextSpan(
          text: ' is strikethrough',
          style: TextStyle(),
        ),
      ];
      expect(
        TypesetParser.parser(inputText: inputText),
        equals(expectedSpans),
      );
    });

    test('parses link correctly', () {
      const inputText = '§Example|http://example.com§';

      final result = TypesetParser.parser(inputText: inputText);

      expect(result.length, 1);
      final linkSpan = result[0];
      expect(linkSpan.text, 'Example');
      expect(linkSpan.style?.color, Colors.blue);
      expect(linkSpan.style?.decoration, TextDecoration.underline);
      expect(linkSpan.recognizer, isA<TapGestureRecognizer>());
    });
  });
}
