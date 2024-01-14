/// Enum declaration for different types of text formatting options.
///
/// Example Usage:
/// ```dart
/// StyleTypeEnum myType = StyleTypeEnum.bold;
/// print(myType); // Output: bold
/// ```
///
/// Flow:
/// - The enum `StyleTypeEnum` is declared with seven different values: `bold`,
///  `italic`,`underline`, `plain`, `monospace`, `strikethrough`, and `link`.
/// - Each value represents a specific text formatting option.
/// - Enums are used to define a set of named constants, in this case,
/// the different types of text formatting.
enum StyleTypeEnum {
  /// Bold Style
  bold('Bold'),

  /// Italic Style
  italic('Italic'),

  /// Underline Style
  underline('Underline'),

  /// Plain Style
  plain('Plain'),

  /// Monospace Style
  monospace('Monospace'),

  /// Strikethrough Style
  strikethrough('Strikethrough'),

  /// Link Style
  link('Link');

  const StyleTypeEnum(this.styleTypeEnumValue);

  /// The String value of the enum.
  final String styleTypeEnumValue;
}
