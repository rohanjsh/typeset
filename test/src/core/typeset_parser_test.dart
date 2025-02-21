import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typeset/src/core/typeset_parser.dart';

void main() {
  group(
    'TypesetParser Tests',
    () {
      test('Parser with bold, italics, link', testBoldItalicLinkInParser);
      test('Parser with monospace', testMonoSpaceInParser);
      test('Parser with custom styling', testCustomStyling);
      test('Parser with font size', testFontSize);
      test('Parser with url launcher', testUrlLauncher);
    },
  );
}

void testBoldItalicLinkInParser() {
  const inputText =
      'This is *bold* and _italic_ text with a §link|https://example.com§';
  final spans = TypesetParser.parser(
    inputText: inputText,
  );

  expect(spans.length, 6);
  expect(spans[0].text, 'This is ');
  expect(spans[1].text, 'bold');
  expect(spans[2].text, ' and ');
  expect(spans[3].text, 'italic');
  expect(spans[4].text, ' text with a ');
  expect(spans[5].text, 'link');

  expect(spans[1].style!.fontWeight, FontWeight.w700);
  expect(spans[3].style!.fontStyle, FontStyle.italic);
  expect(spans[5].style!.color, Colors.blue);
}

void testMonoSpaceInParser() {
  const inputText = 'This is `monospace` text';
  final spans = TypesetParser.parser(
    inputText: inputText,
  );

  expect(spans.length, 3);
  expect(spans[0].text, 'This is ');
  expect(spans[1].text, 'monospace');
  expect(spans[2].text, ' text');

  expect(spans[1].style!.fontFamily, 'Courier');
}

void testCustomStyling() {
  const inputText =
      'This is *bold* and _italic_ text with a §link|https://example.com§';
  const linkStyle = TextStyle(color: Colors.red);
  const boldStyle = TextStyle(fontWeight: FontWeight.w600);
  final recognizer = TapGestureRecognizer()
    ..onTap = () => debugPrint('Link tapped!');
  final spans = TypesetParser.parser(
    inputText: inputText,
    linkStyle: linkStyle,
    linkRecognizerBuilder: (linkText, url) => recognizer,
    boldStyle: boldStyle,
  );

  expect(spans.length, 6);
  expect(spans[0].text, 'This is ');
  expect(spans[1].text, 'bold');
  expect(spans[2].text, ' and ');
  expect(spans[3].text, 'italic');
  expect(spans[4].text, ' text with a ');
  expect(spans[5].text, 'link');

  expect(spans[1].style!.fontWeight, FontWeight.w600);
  expect(spans[3].style!.fontStyle, FontStyle.italic);
  expect(spans[5].style!.color, Colors.red);
  expect(spans[5].recognizer, recognizer);
}

void testFontSize() {
  const inputText = 'This is *body<10>* and _title<40>_ size';
  final spans = TypesetParser.parser(
    inputText: inputText,
  );

  expect(spans.length, 5);
  expect(spans[0].text, 'This is ');
  expect(spans[1].text, 'body');
  expect(spans[2].text, ' and ');
  expect(spans[3].text, 'title');
  expect(spans[4].text, ' size');

  expect(spans[1].style!.fontSize, 10);
  expect(spans[3].style!.fontSize, 40);
}

void testUrlLauncher() {
  const inputText = 'This is a §link|https://google.com§';
  final spans = TypesetParser.parser(
    inputText: inputText,
  );

  expect(spans[1].recognizer.runtimeType, TapGestureRecognizer);
}
