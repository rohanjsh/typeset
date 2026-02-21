import 'package:flutter_test/flutter_test.dart';
import 'package:typeset/typeset.dart';

void main() {
  group('TypesetReserved Tests', () {
    test('constants have expected values', () {
      expect(TypesetReserved.escapeChar, equals(r'\'));
      expect(TypesetReserved.boldChar, equals('*'));
      expect(TypesetReserved.italicChar, equals('_'));
      expect(TypesetReserved.strikethroughChar, equals('~'));
      expect(TypesetReserved.monospaceChar, equals('`'));
      expect(TypesetReserved.underlineChar, equals('__'));
    });

    test('allSingle contains only single-char delimiters', () {
      expect(
        TypesetReserved.allSingle,
        equals({'*', '_', '~', '`'}),
      );
    });

    test('all contains all delimiters', () {
      expect(
        TypesetReserved.all,
        equals({'*', '_', '~', '`', '__'}),
      );
    });

    test('bold char formatting', () {
      const text = 'This is an ${TypesetReserved.boldChar}example'
          '${TypesetReserved.boldChar} of bold formatting.';
      expect(text, equals('This is an *example* of bold formatting.'));
    });

    test('underline uses double underscore', () {
      const text = 'This is ${TypesetReserved.underlineChar}underlined'
          '${TypesetReserved.underlineChar} text.';
      expect(text, equals('This is __underlined__ text.'));
    });
  });
}
