import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typeset/src/document.dart';
import 'package:typeset/typeset.dart';

import '../../helpers/span_test_helpers.dart';

void main() {
  group('TypeSetDocument', () {
    test('preserves source text and computes plain text', () {
      final document = TypeSetDocument.compile(
        'Hello *world* and https://flutter.dev',
      );

      expect(document.inputText, 'Hello *world* and https://flutter.dev');
      expect(document.plainText, 'Hello world and https://flutter.dev');
    });

    test('renders delimiters on demand for compiled formatted text', () {
      final document = TypeSetDocument.compile('Hello *world*');

      final root = TextSpan(
        children: document.render(showDelimiters: true),
      );
      final leaves = collectLeafTextSpans(root);

      expect(leaves.map((leaf) => leaf.text), ['Hello *', 'world', '*']);
      expect(leaves[1].style?.fontWeight, FontWeight.bold);
    });

    test('uses compile-time link detection and render-time recognizers', () {
      final document = TypeSetDocument.compile(
        'Visit https://example.com and https://flutter.dev',
        autoLinkConfig: TypeSetAutoLinkConfig(
          allowedSchemes: const {'https'},
          allowedDomains: RegExp(r'^flutter\.dev$'),
        ),
      );

      final root = TextSpan(
        children: document.render(
          linkRecognizerBuilder: (linkText, url) =>
              TapGestureRecognizer()..onTap = () {},
        ),
      );
      final recognizedSpans = collectRecognizedTextSpans(root);

      expect(recognizedSpans, hasLength(1));
      expect(
        inlineSpanPlainText(recognizedSpans.single),
        'https://flutter.dev',
      );
    });
  });
}
