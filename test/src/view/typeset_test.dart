import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
