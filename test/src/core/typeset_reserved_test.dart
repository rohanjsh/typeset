// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_test/flutter_test.dart';
import 'package:typeset/typeset.dart';

void main() {
  group(
    'TypesetReserved Tests',
    () {
      test('Accessing all constants', testAccessAllConstants);
      test('Escape Literal', testEscapeLiteral);
      test('Bold Character Formatting', testBoldCharFormatting);
      test('Font Size Regex Matching', testFontSizeRegexMatching);
    },
  );
}

// Accessing all the constants should return the expected values.
void testAccessAllConstants() {
  expect(TypesetReserved.escapeLiteral, equals('¦'));
  expect(TypesetReserved.boldChar, equals('*'));
  expect(TypesetReserved.italicChar, equals('_'));
  expect(TypesetReserved.strikethroughChar, equals('~'));
  expect(TypesetReserved.monospaceChar, equals('`'));
  expect(TypesetReserved.underlineChar, equals('#'));
  expect(TypesetReserved.linkChar, equals('§'));
  expect(TypesetReserved.linkSplitChar, equals('|'));
}

void testEscapeLiteral() {
  const text =
      'This is an example of ${TypesetReserved.escapeLiteral}escaping${TypesetReserved.escapeLiteral} character.';
  expect(text, equals('This is an example of ¦escaping¦ character.'));
}

void testBoldCharFormatting() {
  const text =
      'This is an ${TypesetReserved.boldChar}example${TypesetReserved.boldChar} of bold formatting.';
  expect(text, equals('This is an *example* of bold formatting.'));
}

void testFontSizeRegexMatching() {
  final regex = RegExp(TypesetReserved.fontSizeRegex);
  expect(regex.hasMatch('This is an example<12>'), isTrue);
  expect(regex.hasMatch('This is another example<24>'), isTrue);
  expect(regex.hasMatch('This is a third example<36>'), isTrue);
  expect(regex.hasMatch('This is not an example'), isFalse);
}
