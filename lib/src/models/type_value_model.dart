import 'package:typeset/src/models/style_type_enum.dart';

/// Represents a model for a type-value pair.
///
/// This class defines a model that consists of two properties: `type`
/// and `value`.
/// The `type` property represents the type of the model and is of
/// type `StyleTypeEnum`.
/// The `value` property represents the value of the model and is of
/// type `String`.
///
/// Example Usage:
/// ```dart
/// TypeValueModel model =
///             TypeValueModel(type: StyleTypeEnum.bold, value: "Hello");
/// print(model.type); // Output: StyleTypeEnum.bold
/// print(model.value); // Output: Hello
/// ```
class TypeValueModel {
  /// Creates a new instance of [TypeValueModel].
  TypeValueModel({
    required this.type,
    required this.value,
  });

  /// The style for the text
  StyleTypeEnum type;

  /// The value for the text
  String value;
}
