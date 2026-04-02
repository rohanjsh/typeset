import 'package:typeset/src/core/parser/typeset_autolink_pass.dart';
import 'package:typeset/src/models/ast/typeset_nodes.dart';
import 'package:typeset/src/models/typeset_autolink_config.dart';
import 'package:typeset/src/models/typeset_reserved.dart';

/// Supports: `*bold*`, `_italic_`, `__underline__`, `~strikethrough~`,
/// `` `code` ``, `\escape`.
final class TypesetParser {
  /// Creates a TypesetParser instance.
  const TypesetParser();

  /// Parses markup text into an AST.
  ///
  /// If [autoLinkConfig] has non-empty schemes, applies AutoLink
  /// post-processing.
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

/// Stack frame for tracking open delimiters during parsing.
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

    if (ch == TypesetReserved.escapeChar) {
      if (i + 1 < input.length) {
        _appendText(current, input[i + 1]);
        i += 2;
      } else {
        _appendText(current, TypesetReserved.escapeChar);
        i += 1;
      }
      continue;
    }

    if (ch == TypesetReserved.monospaceChar) {
      final end = input.indexOf(TypesetReserved.monospaceChar, i + 1);
      if (end == -1) {
        _appendText(current, TypesetReserved.monospaceChar);
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
          _appendText(frames.last.children, '$delimiter$delimiter');
        } else {
          frames.last.children.add(
            TypesetStyleNode(style: closing.style!, children: closing.children),
          );
        }
        i += delimiter.length;
        continue;
      }

      final crosses =
          frames.take(frames.length - 1).any((f) => f.delimiter == delimiter);
      if (crosses) {
        _appendText(current, delimiter);
        i += delimiter.length;
        continue;
      }

      if (!canOpen) {
        _appendText(current, delimiter);
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

    _appendText(current, ch);
    i += 1;
  }

  while (frames.length > 1) {
    final unclosed = frames.removeLast();
    _appendText(frames.last.children, unclosed.delimiter!);
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

bool _isWhitespace(int codeUnit) {
  return switch (codeUnit) {
    0x09 || 0x0A || 0x0B || 0x0C || 0x0D || 0x20 || 0x85 || 0xA0 => true,
    _ => false,
  };
}

/// Appends text to the output, coalescing adjacent text nodes.
void _appendText(List<TypesetNode> out, String text) {
  if (text.isEmpty) return;

  final last = out.isEmpty ? null : out.last;
  if (last is TypesetTextNode) {
    out[out.length - 1] = TypesetTextNode(last.text + text);
  } else {
    out.add(TypesetTextNode(text));
  }
}
