/// Reserved characters and delimiter constants for TypeSet formatting.
abstract final class TypesetReserved {
  TypesetReserved._();

  /// Escape prefix (`\`).
  static const escapeChar = r'\';

  /// Bold delimiter (`*`).
  static const boldChar = '*';

  /// Italic delimiter (`_`).
  static const italicChar = '_';

  /// Strikethrough delimiter (`~`).
  static const strikethroughChar = '~';

  /// Monospace/code delimiter (`` ` ``).
  static const monospaceChar = '`';

  /// Underline delimiter (`__`).
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
