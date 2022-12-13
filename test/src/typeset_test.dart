// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typeset/typeset.dart';

//example widget for testing
class _TypeSetTest extends StatefulWidget {
  const _TypeSetTest({super.key, required this.title, this.style});

  final String title;
  final TextStyle? style;

  @override
  State<_TypeSetTest> createState() => __TypeSetTestState();
}

class __TypeSetTestState extends State<_TypeSetTest> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: TypeSet(
            inputText: widget.title,
            style: widget.style,
          ),
        ),
      ),
    );
  }
}

void main() {
  group(
    'Tests for TypeSet Widget',
    () {
      testWidgets(
        'TypeSet widget displays normal text correctly',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            _TypeSetTest(title: 'Hello World'),
          );

          expect(
            find.text(
              'Hello World',
              findRichText: true,
            ),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'TypeSet widget displays bold text correctly',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            _TypeSetTest(
              title: 'Hello, *World!*',
              key: Key('boldText'),
            ),
          );
          final boldText = find.byKey(
            Key('boldText'),
          );
          expect(
            boldText,
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'TypeSet widget displays italic text correctly',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            _TypeSetTest(
              title: 'Hello, _World_!',
              key: Key('italicText'),
            ),
          );
          final italicText = find.byKey(
            Key('italicText'),
          );
          expect(italicText, findsOneWidget);
        },
      );

      testWidgets(
        'TypeSet widget displays underline text correctly',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            _TypeSetTest(
              title: 'Hello, ~World~!',
              key: Key('underlineText'),
            ),
          );
          final underlineText = find.byKey(
            Key('underlineText'),
          );
          expect(underlineText, findsOneWidget);
        },
      );

      testWidgets(
        'TypeSet widget displays underline text correctly',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            _TypeSetTest(
              title: 'Hello, -World-!',
              key: Key('underlineText'),
            ),
          );
          final underlineText = find.byKey(
            Key('underlineText'),
          );
          expect(underlineText, findsOneWidget);
        },
      );

      testWidgets(
        'TypeSet widget displays bold, italic, and underline text correctly',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            _TypeSetTest(
              title: 'Hello, *World* _World_ ~World~!',
              key: Key('boldItalicUnderlineText'),
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          );

          final boldItalicUnderlineText = find.byKey(
            Key('boldItalicUnderlineText'),
          );

          expect(boldItalicUnderlineText, findsOneWidget);
        },
      );
    },
  );
}
