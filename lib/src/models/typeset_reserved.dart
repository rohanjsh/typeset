/// Reserved characters for TypeSet formatting
final class TypesetReserved {
  TypesetReserved._();

  /// The escape character (backslash).
  static const escapeChar = r'\';

  /// The delimiter for bold formatting.
  static const boldChar = '*';

  /// The delimiter for italic formatting.
  static const italicChar = '_';

  /// The delimiter for strikethrough formatting.
  static const strikethroughChar = '~';

  /// The delimiter for monospace/inline code formatting.
  static const monospaceChar = '`';

  /// The delimiter for underline formatting (double underscore).
  static const underlineChar = '__';

  /// All single-character formatting delimiters.
  static const allSingle = {
    boldChar,
    italicChar,
    strikethroughChar,
    monospaceChar,
  };

  /// All formatting delimiters (single and multi-character).
  static const all = {
    boldChar,
    italicChar,
    strikethroughChar,
    monospaceChar,
    underlineChar,
  };
}
