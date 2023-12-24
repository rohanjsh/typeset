import 'package:typeset/src/core/typeset_reserved.dart';
import 'package:typeset/src/models/style_type_enum.dart';
import 'package:typeset/src/models/style_type_value_model.dart';

/// The 'TypesetController' class is responsible for manipulating
/// a given input string and converting it into a list of TypeValueModel
/// objects based on certain style types defined in a literals map.
///
/// Example Usage:
/// ```dart
/// final controller = TypesetController('This is *bold* and _italic_.');
/// final result = controller.manipulateString();
/// ```
///
/// Inputs:
/// - `input` (String): The input string to be manipulated.
///
/// Flow:
/// 1. Create a map called `literalsMap` that maps certain characters to
///    their corresponding `StyleTypeEnum` values.
/// 2. Initialize `currentStyle` as `StyleTypeEnum.plain` and create an empty
///    `StringBuffer` called `currentContent`.
/// 3. Iterate over each character in the `input` string.
/// 4. If the current character is a forward slash ('/') and the
///    next character is a key in `literalsMap`,
///    skip the escaping character and add the
///    next literal character as normal text to `currentContent`.
/// 5. If the current character is a key in `literalsMap` and the
///    `currentStyle` is `StyleTypeEnum.plain`, add any existing plain text in
///    `currentContent` to the `list` as a `TypeValueModel` object.
///    Then clear `currentContent` and update `currentStyle`
///    to the corresponding style type.
/// 6. If the current character is a key in `literalsMap` and the corresponding
///    style type is equal to `currentStyle`, add the current content in
///    `currentContent` to the `list` as a `TypeValueModel` object.
///    Then clear `currentContent` and reset `currentStyle` to
///    `StyleTypeEnum.plain`.
/// 7. If none of the above conditions are met, add the current character to
///    `currentContent`.
/// 8. After the loop, if there is any leftover text in `currentContent`,
///    add it to the `list` as plain text.
/// 9. Return the `list` of `TypeValueModel` objects.
///
/// Outputs:
/// - `list` (List<TypeValueModel>): A list of `TypeValueModel` objects
///    representing the manipulated string. Each object contains a style type
///    and the corresponding text segment.
class TypesetController {
  /// The constructor for the TypesetController class.
  TypesetController({
    required this.input,
  });

  /// The input string to be manipulated.
  final String input;

  /// A list of `TypeValueModel` objects representing the manipulated string.
  List<StyleTypeValueModel> list = [];

  /// Manipulates a given string by identifying specific characters and
  /// assigning corresponding style types to them.
  ///
  /// Returns a list of [StyleTypeValueModel] objects, where each object
  /// represents a segment of the manipulated string with its
  /// corresponding style type.
  ///
  /// Example Usage:
  /// ```dart
  /// var result = manipulateString();
  /// ```
  List<StyleTypeValueModel> manipulateString() {
    // Define literals in a map for easy access
    //to their corresponding style types.
    const literalsMap = <String, StyleTypeEnum>{
      TypesetReserved.boldChar: StyleTypeEnum.bold,
      TypesetReserved.italicChar: StyleTypeEnum.italic,
      TypesetReserved.underlineChar: StyleTypeEnum.underline,
      TypesetReserved.monospaceChar: StyleTypeEnum.monospace,
      TypesetReserved.strikethroughChar: StyleTypeEnum.strikethrough,
      TypesetReserved.linkChar: StyleTypeEnum.link,
    };

    var currentStyle = StyleTypeEnum.plain;
    final currentContent = StringBuffer();

    for (var i = 0; i < input.length; i++) {
      if (i < input.length - 1 &&
          input[i] == TypesetReserved.escapeLiteral &&
          literalsMap.containsKey(input[i + 1])) {
        // Skip literal character and add the next char as normal text.
        currentContent.write(input[++i]);
        continue;
      }

      if (literalsMap.containsKey(input[i]) &&
          currentStyle == StyleTypeEnum.plain) {
        // Add any existing plain text to the list.
        if (currentContent.isNotEmpty) {
          list.add(
            StyleTypeValueModel(
              styleType: currentStyle,
              value: currentContent.toString(),
            ),
          );
          currentContent.clear();
        }
        // Update the style for the subsequent text.
        currentStyle = literalsMap[input[i]]!;
      } else if (literalsMap.containsKey(input[i]) &&
          literalsMap[input[i]] == currentStyle) {
        // End the current styled text and reset style to plain.
        list.add(
          StyleTypeValueModel(
            styleType: currentStyle,
            value: currentContent.toString(),
          ),
        );
        currentContent.clear();
        currentStyle = StyleTypeEnum.plain;
      } else {
        // Add the current character as part of the current text segment.
        currentContent.write(input[i]);
      }
    }

    // Add any leftover text as plain text.
    if (currentContent.isNotEmpty) {
      list.add(
        StyleTypeValueModel(
          styleType: currentStyle,
          value: currentContent.toString(),
        ),
      );
    }

    return list;
  }
}
