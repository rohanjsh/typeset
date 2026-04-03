import 'package:typeset/src/ast/ast_utils.dart';
import 'package:typeset/src/ast/nodes.dart';
import 'package:typeset/src/config/autolink_config.dart';
import 'package:typeset/src/parser/autolink_pass.dart';
import 'package:typeset/src/reserved.dart';

/// Parses markup text into an AST.
/// Supports: `*bold*`, `_italic_`, `__underline__`, `~strikethrough~`,
/// `` `code` ``, `\escape`.
final class TypesetParser {
  /// Creates a parser.
  const TypesetParser();

  /// Parses [input] into an AST, optionally applying AutoLink post-processing.
  List<TypesetNode> parse(
    String input, {
    TypeSetAutoLinkConfig? autoLinkConfig,
  }) {
    if (input.isEmpty) return const <TypesetNode>[];

    final parsed = _parseInline(input);
    final config = autoLinkConfig ?? _defaultAutoLinkConfig;

    if (config.allowedSchemes.isEmpty) return parsed;
    return typesetAutoLink(parsed, config);
  }
}

final TypeSetAutoLinkConfig _defaultAutoLinkConfig = TypeSetAutoLinkConfig();

final class _Frame {
  _Frame({required this.delimiter, required this.style});

  final String? delimiter;
  final TypesetStyle? style;
  final List<TypesetNode> children = <TypesetNode>[];
}

List<TypesetNode> _parseInline(String input) {
  if (input.isEmpty) return const <TypesetNode>[];

  final frames = <_Frame>[_Frame(delimiter: null, style: null)];
  var i = 0;

  while (i < input.length) {
    final current = frames.last.children;
    final ch = input[i];

    // Only consume backslash when the next char is a reserved delimiter.
    // A backslash before a non-reserved char is kept as a literal backslash
    // to avoid silently eating user content like file paths.
    if (ch == TypesetReserved.escapeChar) {
      if (i + 1 < input.length && _isEscapable(input[i + 1])) {
        appendTextNode(current, input[i + 1]);
        i += 2;
      } else {
        appendTextNode(current, TypesetReserved.escapeChar);
        i += 1;
      }
      continue;
    }

    if (ch == TypesetReserved.monospaceChar) {
      final end = input.indexOf(TypesetReserved.monospaceChar, i + 1);
      if (end == -1) {
        appendTextNode(current, TypesetReserved.monospaceChar);
        i += 1;
        continue;
      }
      final code = input.substring(i + 1, end);
      current.add(TypesetCodeNode(code));
      i = end + 1;
      continue;
    }

    final delimiter = _readDelimiter(input, i);
    if (delimiter != null) {
      final canClose = _canCloseDelimiter(input, i, delimiter);
      final canOpen = _canOpenDelimiter(input, i, delimiter);

      if (frames.length > 1 && frames.last.delimiter == delimiter && canClose) {
        final closing = frames.removeLast();
        if (closing.children.isEmpty) {
          appendTextNode(frames.last.children, '$delimiter$delimiter');
        } else {
          frames.last.children.add(
            TypesetStyleNode(
              style: closing.style!,
              children: closing.children,
            ),
          );
        }
        i += delimiter.length;
        continue;
      }

      final crosses =
          frames.take(frames.length - 1).any((f) => f.delimiter == delimiter);
      if (crosses) {
        appendTextNode(current, delimiter);
        i += delimiter.length;
        continue;
      }

      if (!canOpen) {
        appendTextNode(current, delimiter);
        i += delimiter.length;
        continue;
      }

      frames.add(
        _Frame(
          delimiter: delimiter,
          style: _styleForDelimiter(delimiter),
        ),
      );
      i += delimiter.length;
      continue;
    }

    appendTextNode(current, ch);
    i += 1;
  }

  while (frames.length > 1) {
    final unclosed = frames.removeLast();
    appendTextNode(frames.last.children, unclosed.delimiter!);
    frames.last.children.addAll(unclosed.children);
  }

  return frames.single.children;
}

TypesetStyle _styleForDelimiter(String delimiter) {
  return switch (delimiter) {
    TypesetReserved.boldChar => TypesetStyle.bold,
    TypesetReserved.italicChar => TypesetStyle.italic,
    TypesetReserved.underlineChar => TypesetStyle.underline,
    TypesetReserved.strikethroughChar => TypesetStyle.strikethrough,
    _ => throw StateError('Unsupported delimiter: $delimiter'),
  };
}

String? _readDelimiter(String input, int index) {
  assert(index >= 0 && index < input.length, 'Index out of bounds');
  final ch = input[index];
  return switch (ch) {
    TypesetReserved.italicChar => (index + 1 < input.length &&
            input[index + 1] == TypesetReserved.italicChar)
        ? TypesetReserved.underlineChar
        : TypesetReserved.italicChar,
    TypesetReserved.boldChar || TypesetReserved.strikethroughChar => ch,
    _ => null,
  };
}

bool _canOpenDelimiter(String input, int index, String delimiter) {
  final nextIndex = index + delimiter.length;
  return nextIndex < input.length &&
      !_isWhitespace(input.codeUnitAt(nextIndex));
}

bool _canCloseDelimiter(String input, int index, String delimiter) {
  final previousIndex = index - 1;
  return previousIndex >= 0 && !_isWhitespace(input.codeUnitAt(previousIndex));
}

bool _isEscapable(String ch) {
  return ch == TypesetReserved.escapeChar ||
      TypesetReserved.allSingle.contains(ch);
}

bool _isWhitespace(int codeUnit) {
  return switch (codeUnit) {
    0x09 || 0x0A || 0x0B || 0x0C || 0x0D || 0x20 || 0x85 || 0xA0 => true,
    _ => false,
  };
}
