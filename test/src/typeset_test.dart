// ignore_for_file: prefer_const_constructors
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typeset/src/typeset_parser.dart';

import 'typeset_widget.dart';

//example widget for testing

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    'Tests for TypeSet Widget',
    () {
      testWidgets(
        'TypeSet widget displays bold, italic, and strikethrough text',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            TypeSetTest(
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
            Key(
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
          TypeSetTest(
            titleForExt: 'Hello World',
            key: Key(
              'extensionTest',
            ),
          ),
        );

        final extensionTest = find.byKey(
          Key(
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

  group('TypesetParser', () {
    test('parses bold text', () {
      const inputText = 'This *word* is bold';
      final expectedSpans = [
        TextSpan(
          text: 'This ',
          style: TextStyle(),
        ),
        TextSpan(
          text: 'word ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: 'is ',
          style: TextStyle(),
        ),
        TextSpan(
          text: 'bold',
          style: TextStyle(),
        )
      ];
      expect(
        TypesetParser.parseText(inputText),
        equals(expectedSpans),
      );
    });

    test('parses italic text', () {
      const inputText = 'This _word_ is italic';
      final expectedSpans = [
        TextSpan(
          text: 'This ',
          style: TextStyle(),
        ),
        TextSpan(
          text: 'word ',
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
        TextSpan(
          text: 'is ',
          style: TextStyle(),
        ),
        TextSpan(
          text: 'italic',
          style: TextStyle(),
        )
      ];
      expect(
        TypesetParser.parseText(inputText),
        equals(expectedSpans),
      );
    });

    test('parses underline text', () {
      const inputText = 'This //word// is underlined';
      final expectedSpans = [
        TextSpan(
          text: 'This ',
          style: TextStyle(),
        ),
        TextSpan(
          text: 'word ',
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
        TextSpan(
          text: 'is ',
          style: TextStyle(),
        ),
        TextSpan(
          text: 'underlined',
          style: TextStyle(),
        )
      ];
      expect(
        TypesetParser.parseText(inputText),
        equals(expectedSpans),
      );
    });

    test('parses strikethrough text', () {
      const inputText = 'This ~word~ is strikethrough';
      final expectedSpans = [
        TextSpan(
          text: 'This ',
          style: TextStyle(),
        ),
        TextSpan(
          text: 'word ',
          style: TextStyle(
            decoration: TextDecoration.lineThrough,
          ),
        ),
        TextSpan(
          text: 'is ',
          style: TextStyle(),
        ),
        TextSpan(
          text: 'strikethrough',
          style: TextStyle(),
        )
      ];
      expect(
        TypesetParser.parseText(inputText),
        equals(expectedSpans),
      );
    });

    test('parses link correctly', () {
      const inputText = '[Example|http://example.com]';

      final result = TypesetParser.parseText(inputText);

      expect(result.length, 1);
      final linkSpan = result[0];
      expect(linkSpan.text, 'Example');
      expect(linkSpan.style?.color, Colors.blue);
      expect(linkSpan.style?.decoration, TextDecoration.underline);
      expect(linkSpan.recognizer, isA<TapGestureRecognizer>());
    });
  });
}
