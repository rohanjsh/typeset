import 'package:typeset/src/ast/ast_utils.dart';
import 'package:typeset/src/ast/nodes.dart';
import 'package:typeset/src/config/autolink_config.dart';

/// Post-processing pass that detects and linkifies raw URLs in plain text.
List<TypesetNode> typesetAutoLink(
  List<TypesetNode> nodes,
  TypeSetAutoLinkConfig config,
) {
  return _autoLinkNodes(nodes, config);
}

final RegExp _urlRegex = RegExp(r'(https?:\/\/[^\s]+|www\.[^\s]+)');

List<TypesetNode> _autoLinkNodes(
  List<TypesetNode> nodes,
  TypeSetAutoLinkConfig config,
) {
  final out = <TypesetNode>[];

  for (final node in nodes) {
    switch (node) {
      case TypesetTextNode():
        out.addAll(_autoLinkText(node.text, config));
      case TypesetStyleNode():
        out.add(
          TypesetStyleNode(
            style: node.style,
            children: _autoLinkNodes(node.children, config),
          ),
        );
      case TypesetCodeNode():
        out.add(node);
      case TypesetLinkNode():
        out.add(node);
    }
  }

  return out;
}

List<TypesetNode> _autoLinkText(
  String text,
  TypeSetAutoLinkConfig config,
) {
  if (text.isEmpty) return const <TypesetNode>[];

  final matches = _urlRegex.allMatches(text);
  if (matches.isEmpty) return <TypesetNode>[TypesetTextNode(text)];

  final out = <TypesetNode>[];
  var index = 0;

  for (final m in matches) {
    if (!_hasAutoLinkBoundary(text, m.start)) continue;

    if (m.start > index) {
      appendTextNode(out, text.substring(index, m.start));
    }

    final raw = m.group(0)!;
    final trimmed = _trimTrailingPunctuation(raw);
    final urlText = trimmed.url;
    final trailing = trimmed.trailing;

    final normalized = _normalizeAutolinkUrl(urlText);
    if (_isValidAutoLink(normalized, config)) {
      out.add(
        TypesetLinkNode(
          url: normalized,
          label: <TypesetNode>[TypesetTextNode(urlText)],
        ),
      );
    } else {
      appendTextNode(out, raw);
    }

    if (trailing.isNotEmpty) {
      appendTextNode(out, trailing);
    }

    index = m.end;
  }

  if (index < text.length) {
    appendTextNode(out, text.substring(index));
  }

  return out;
}

String _normalizeAutolinkUrl(String display) {
  if (display.startsWith('www.')) return 'https://$display';
  return display;
}

bool _isValidAutoLink(String url, TypeSetAutoLinkConfig config) {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  if (!config.allowedSchemes.contains(uri.scheme)) return false;
  if (uri.host.isEmpty) return false;
  if (config.allowedDomains != null) {
    if (!config.allowedDomains!.hasMatch(uri.host)) return false;
  }
  if (config.customValidator != null) {
    if (!config.customValidator!(uri)) return false;
  }
  return true;
}

// Characters stripped from the trailing end of detected URLs.
const _dot = 0x2E; // .
const _comma = 0x2C; // ,
const _excl = 0x21; // !
const _question = 0x3F; // ?
const _colon = 0x3A; // :
const _quote = 0x22; // "
const _gt = 0x3E; // >
const _semi = 0x3B; // ;
const _lparen = 0x28; // (
const _rparen = 0x29; // )
const _lbracket = 0x5B; // [
const _rbracket = 0x5D; // ]
const _lbrace = 0x7B; // {
const _rbrace = 0x7D; // }

({String url, String trailing}) _trimTrailingPunctuation(String raw) {
  var url = raw;
  var trailing = '';

  while (url.isNotEmpty) {
    final last = url.codeUnitAt(url.length - 1);
    final isTrim = switch (last) {
      _dot ||
      _comma ||
      _excl ||
      _question ||
      _colon ||
      _quote ||
      _gt ||
      _semi =>
        true,
      _rparen => _hasExcessClosingDelimiter(url, _lparen, _rparen),
      _rbracket => _hasExcessClosingDelimiter(url, _lbracket, _rbracket),
      _rbrace => _hasExcessClosingDelimiter(url, _lbrace, _rbrace),
      _ => false,
    };

    if (!isTrim) break;
    trailing = String.fromCharCode(last) + trailing;
    url = url.substring(0, url.length - 1);
  }

  return (url: url, trailing: trailing);
}

bool _hasExcessClosingDelimiter(String text, int open, int close) {
  var opens = 0;
  var closes = 0;
  for (final codeUnit in text.codeUnits) {
    if (codeUnit == open) {
      opens += 1;
    } else if (codeUnit == close) {
      closes += 1;
    }
  }
  return closes > opens;
}

bool _hasAutoLinkBoundary(String text, int start) {
  if (start == 0) return true;
  return !_isAutoLinkContinuation(text.codeUnitAt(start - 1));
}

bool _isAutoLinkContinuation(int codeUnit) {
  final isDigit = codeUnit >= 0x30 && codeUnit <= 0x39; // 0-9
  final isUpper = codeUnit >= 0x41 && codeUnit <= 0x5A; // A-Z
  final isLower = codeUnit >= 0x61 && codeUnit <= 0x7A; // a-z
  return isDigit ||
      isUpper ||
      isLower ||
      codeUnit == 0x40 || // @
      codeUnit == 0x5F || // _
      codeUnit == 0x2D || // -
      codeUnit == 0x2E || // .
      codeUnit == 0x2F; // /
}
