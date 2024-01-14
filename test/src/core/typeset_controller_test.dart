import 'package:flutter_test/flutter_test.dart';
import 'package:typeset/src/core/typeset_controller.dart';
import 'package:typeset/src/models/style_type_enum.dart';

void main() {
  group(
    'TypesetController Tests',
    () {
      test('No Special Characters', testNoReservedCharacters);
      test('Special Characters - Bold', testReservedCharactersBold);
      test('Special Characters - Italic', testReservedCharactersItalic);
      test(
        'Special Characters - Strikethrough',
        testReservedCharactersStrikethrough,
      );
      test('Special Characters - Underline', testReservedCharactersUnderline);
      test('Special Characters - Monospace', testReservedCharactersMonospace);
      test('Special Characters - Link', testReservedCharactersLink);

      test('Empty String', testEmptyString);
      test('Escape Literal', testEscapeLiteral);
    },
  );
}

void testNoReservedCharacters() {
  final controller = TypesetController(input: 'This is a plain text');
  final result = controller.manipulateString();

  expect(result.length, equals(1));
  expect(result[0].styleType, equals(StyleTypeEnum.plain));
  expect(result[0].value, equals('This is a plain text'));
}

void testReservedCharactersBold() {
  final controller = TypesetController(
    input: 'This is a *bold* text',
  );
  final result = controller.manipulateString();

  expect(result.length, equals(3));
  expect(result[0].styleType, equals(StyleTypeEnum.plain));
  expect(result[0].value, equals('This is a '));
  expect(result[1].styleType, equals(StyleTypeEnum.bold));
  expect(result[1].value, equals('bold'));
  expect(result[2].styleType, equals(StyleTypeEnum.plain));
  expect(result[2].value, equals(' text'));
}

//italic
void testReservedCharactersItalic() {
  final controller = TypesetController(
    input: 'This is a _italic_ text',
  );
  final result = controller.manipulateString();

  expect(result.length, equals(3));
  expect(result[0].styleType, equals(StyleTypeEnum.plain));
  expect(result[0].value, equals('This is a '));
  expect(result[1].styleType, equals(StyleTypeEnum.italic));
  expect(result[1].value, equals('italic'));
  expect(result[2].styleType, equals(StyleTypeEnum.plain));
  expect(result[2].value, equals(' text'));
}

//strikethrough
void testReservedCharactersStrikethrough() {
  final controller = TypesetController(
    input: 'This is a ~strikethrough~ text',
  );
  final result = controller.manipulateString();

  expect(result.length, equals(3));
  expect(result[0].styleType, equals(StyleTypeEnum.plain));
  expect(result[0].value, equals('This is a '));
  expect(result[1].styleType, equals(StyleTypeEnum.strikethrough));
  expect(result[1].value, equals('strikethrough'));
  expect(result[2].styleType, equals(StyleTypeEnum.plain));
  expect(result[2].value, equals(' text'));
}

//underline
void testReservedCharactersUnderline() {
  final controller = TypesetController(
    input: 'This is a #underline# text',
  );
  final result = controller.manipulateString();

  expect(result.length, equals(3));
  expect(result[0].styleType, equals(StyleTypeEnum.plain));
  expect(result[0].value, equals('This is a '));
  expect(result[1].styleType, equals(StyleTypeEnum.underline));
  expect(result[1].value, equals('underline'));
  expect(result[2].styleType, equals(StyleTypeEnum.plain));
  expect(result[2].value, equals(' text'));
}

//monospace
void testReservedCharactersMonospace() {
  final controller = TypesetController(
    input: 'This is a `monospace` text',
  );
  final result = controller.manipulateString();

  expect(result.length, equals(3));
  expect(result[0].styleType, equals(StyleTypeEnum.plain));
  expect(result[0].value, equals('This is a '));
  expect(result[1].styleType, equals(StyleTypeEnum.monospace));
  expect(result[1].value, equals('monospace'));
  expect(result[2].styleType, equals(StyleTypeEnum.plain));
  expect(result[2].value, equals(' text'));
}

//link
void testReservedCharactersLink() {
  final controller = TypesetController(
    input: 'This is a §link|https://example.com§ text',
  );
  final result = controller.manipulateString();

  expect(result.length, equals(3));
  expect(result[0].styleType, equals(StyleTypeEnum.plain));
  expect(result[0].value, equals('This is a '));
  expect(result[1].styleType, equals(StyleTypeEnum.link));
  expect(result[1].value, equals('link|https://example.com'));
  expect(result[2].styleType, equals(StyleTypeEnum.plain));
  expect(result[2].value, equals(' text'));
}

void testEmptyString() {
  final controller = TypesetController(input: '');
  final result = controller.manipulateString();

  expect(result.length, equals(0));
}

// escape literal
void testEscapeLiteral() {
  final controller = TypesetController(
    input: 'This is a Hello ¦* text',
  );
  final result = controller.manipulateString();

  expect(result.length, equals(1));
  expect(result[0].styleType, equals(StyleTypeEnum.plain));
  expect(result[0].value, equals('This is a Hello * text'));
}
