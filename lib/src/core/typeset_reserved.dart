/// A class that contains constant variables representing different
/// typesetting elements.
///
/// The `TypesetConstants` class provides easy access to literals used for
/// typesetting in Dart.
/// These literals can be used to format text in bold, italic, strikethrough,
/// monospace, underline, and create links.
///
/// Example Usage:
/// ```dart
/// print(TypesetConstants.boldChar); // Output: *
/// print(TypesetConstants.italicChar); // Output: _
/// print(TypesetConstants.strikethroughChar); // Output: ~
/// print(TypesetConstants.monospaceChar); // Output: `
/// print(TypesetConstants.underlineChar); // Output: #
/// print(TypesetConstants.linkChar); // Output: §
/// ```
final class TypesetReserved {
  TypesetReserved._();

  /// The escape character used in typesetting.
  static const escapeLiteral = '¦';

  /// The literal for bold formatting.
  static const boldChar = '*';

  /// The literal for italic formatting.
  static const italicChar = '_';

  /// The literal for strikethrough formatting.
  static const strikethroughChar = '~';

  /// The literal for monospace formatting.
  static const monospaceChar = '`';

  /// The literal for underline formatting.
  static const underlineChar = '#';

  /// The literal for creating links.
  static const linkChar = '§';

  /// Regex to identify links
  static const fontSizeRegex = r'(.+?)<(\d+)>';
}
