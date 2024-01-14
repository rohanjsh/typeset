// ignore_for_file: lines_longer_than_80_chars, cascade_invocations

import 'package:flutter_test/flutter_test.dart';
import 'package:typeset/src/models/style_type_enum.dart';
import 'package:typeset/src/models/style_type_value_model.dart';

void main() {
  group(
    'StyleTypeValueModel test',
    () {
      test(
        'Creating a new instance of StyleTypeValueModel with valid arguments sets the styleType and value properties correctly',
        () {
          // Arrange
          const styleType = StyleTypeEnum.bold;
          const value = 'Hello';

          // Act
          final model = StyleTypeValueModel(styleType: styleType, value: value);

          // Assert
          expect(model.styleType, equals(styleType));
          expect(model.value, equals(value));
        },
      );

      test(
        'The styleType property can be set to any valid StyleTypeEnum value',
        () {
          // Arrange
          const styleType = StyleTypeEnum.italic;
          const value = 'Hello';
          final model =
              StyleTypeValueModel(styleType: StyleTypeEnum.bold, value: value);

          // Act
          model.styleType = styleType;

          // Assert
          expect(model.styleType, equals(styleType));
        },
      );

      test(
        'The value property can be set to any non-null String value',
        () {
          // Arrange
          const styleType = StyleTypeEnum.bold;
          const value = 'Hello';
          final model =
              StyleTypeValueModel(styleType: styleType, value: 'World');

          // Act
          model.value = value;

          // Assert
          expect(model.value, equals(value));
        },
      );
    },
  );
}
