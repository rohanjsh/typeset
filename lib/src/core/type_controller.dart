// ignore_for_file: public_member_api_docs, constant_identifier_names, omit_local_variable_types

import 'package:typeset/src/models/type_enum.dart';
import 'package:typeset/src/models/type_value_model.dart';

class TypesetController {
  TypesetController(this.input);

  final String input;
  List<TypeValueModel> list = [];

  List<TypeValueModel> manipulateString() {
    const String BOLD_LITERAL = '*';
    const String ITALIC_LITERAL = '_';
    const String UNDERLINE_LITERAL = '#';
    const String MONO_LITERAL = '`';
    const String STRIKE_THROUGH_LITERAL = '~';
    const String LINK_LITERAL = '§';

    TYPE typeOfString = TYPE.normal;

    final StringBuffer normalString = StringBuffer();
    final StringBuffer boldString = StringBuffer();
    final StringBuffer italicString = StringBuffer();
    final StringBuffer underlineString = StringBuffer();
    final StringBuffer strikeThroughString = StringBuffer();
    final StringBuffer monoString = StringBuffer();
    final StringBuffer linkString = StringBuffer();

    for (int i = 0; i < input.length; i++) {
      if (input[i] == BOLD_LITERAL && typeOfString == TYPE.normal) {
        typeOfString = TYPE.bold;
        continue;
      }
      if (input[i] == ITALIC_LITERAL && typeOfString == TYPE.normal) {
        typeOfString = TYPE.italic;
        continue;
      }
      if (input[i] == UNDERLINE_LITERAL && typeOfString == TYPE.normal) {
        typeOfString = TYPE.underline;
        continue;
      }
      if (input[i] == MONO_LITERAL && typeOfString == TYPE.normal) {
        typeOfString = TYPE.mono;
        continue;
      }
      if (input[i] == STRIKE_THROUGH_LITERAL && typeOfString == TYPE.normal) {
        typeOfString = TYPE.strikeThrough;
        continue;
      }
      if (input[i] == LINK_LITERAL && typeOfString == TYPE.normal) {
        typeOfString = TYPE.link;
        continue;
      }

      if (typeOfString == TYPE.bold) {
        if (input[i] == '/' &&
            input[i + 1] == BOLD_LITERAL &&
            i < input.length - 2) {
          boldString.write(BOLD_LITERAL);
          i++;
          continue;
        }
        if (input[i] == BOLD_LITERAL) {
          _addNormalStringToList(normalString);

          typeOfString = TYPE.normal;
          list.add(
            TypeValueModel(
              TYPE.bold,
              boldString.toString().split('').join(),
            ),
          );

          boldString.clear();
          continue;
        }
        boldString.write(input[i]);
        continue;
      }

      if (typeOfString == TYPE.italic) {
        if (input[i] == '/' &&
            input[i + 1] == ITALIC_LITERAL &&
            i < input.length - 2) {
          italicString.write(ITALIC_LITERAL);
          i++;
          continue;
        }
        if (input[i] == ITALIC_LITERAL) {
          _addNormalStringToList(normalString);

          typeOfString = TYPE.normal;
          list.add(
            TypeValueModel(
              TYPE.italic,
              italicString.toString().split('').join(),
            ),
          );

          italicString.clear();
          continue;
        }
        italicString.write(input[i]);
        continue;
      }

      if (typeOfString == TYPE.underline) {
        if (input[i] == '/' &&
            input[i + 1] == UNDERLINE_LITERAL &&
            i < input.length - 2) {
          underlineString.write(UNDERLINE_LITERAL);
          i++;
          continue;
        }
        if (input[i] == UNDERLINE_LITERAL) {
          _addNormalStringToList(normalString);

          typeOfString = TYPE.normal;
          list.add(
            TypeValueModel(
              TYPE.underline,
              underlineString.toString().split('').join(),
            ),
          );

          underlineString.clear();
          continue;
        }
        underlineString.write(input[i]);
        continue;
      }

      if (typeOfString == TYPE.mono) {
        if (input[i] == '/' &&
            input[i + 1] == MONO_LITERAL &&
            i < input.length - 2) {
          monoString.write(MONO_LITERAL);
          i++;
          continue;
        }
        if (input[i] == MONO_LITERAL) {
          _addNormalStringToList(normalString);

          typeOfString = TYPE.mono;
          list.add(
            TypeValueModel(
              TYPE.mono,
              monoString.toString().split('').join(),
            ),
          );

          monoString.clear();
          continue;
        }
        monoString.write(input[i]);
        continue;
      }

      if (typeOfString == TYPE.strikeThrough) {
        if (input[i] == '/' &&
            input[i + 1] == STRIKE_THROUGH_LITERAL &&
            i < input.length - 2) {
          strikeThroughString.write(STRIKE_THROUGH_LITERAL);
          i++;
          continue;
        }
        if (input[i] == STRIKE_THROUGH_LITERAL) {
          _addNormalStringToList(normalString);

          typeOfString = TYPE.strikeThrough;
          list.add(
            TypeValueModel(
              TYPE.strikeThrough,
              strikeThroughString.toString().split('').join(),
            ),
          );

          strikeThroughString.clear();
          continue;
        }
        strikeThroughString.write(input[i]);
        continue;
      }

      if (typeOfString == TYPE.link) {
        if (input[i] == '/' &&
            input[i + 1] == LINK_LITERAL &&
            i < input.length - 2) {
          linkString.write(LINK_LITERAL);
          i++;
          continue;
        }
        if (input[i] == LINK_LITERAL) {
          _addNormalStringToList(normalString);

          typeOfString = TYPE.link;
          list.add(
            TypeValueModel(
              TYPE.link,
              linkString.toString().split('').join(),
            ),
          );

          linkString.clear();
          continue;
        }
        linkString.write(input[i]);
        continue;
      }

      normalString.write(input[i]);
    }
    _addNormalStringToList(normalString);
    return list;
  }

  void _addNormalStringToList(StringBuffer normalString) {
    if (normalString.isNotEmpty) {
      list.add(
        TypeValueModel(
          TYPE.normal,
          normalString.toString().split('').join(),
        ),
      );
      normalString.clear();
    }
  }
}
