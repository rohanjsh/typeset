import 'package:typeset/src/models/ast/typeset_nodes.dart';
import 'package:typeset/src/models/typeset_autolink_config.dart';

/// Post-processing pass that detects and linkifies raw URLs in plain text.
///
/// Scans [TypesetTextNode]s for URLs matching `http://`, `https://`, or `www.` patterns.
/// Converts matching URLs to [TypesetLinkNode]s based on [config].
/// Skips URLs inside existing links and inline code blocks.
List<TypesetNode> typesetAutoLink(
  List<TypesetNode> nodes,
  TypeSetAutoLinkConfig config,
) {
  return _autoLinkNodes(nodes, config);
}

/// Regex pattern for detecting URLs in plain text.
///
/// Matches: `http://...`, `https://...`, or `www...` (normalized to https).
final RegExp _urlRegex = RegExp(r'(https?:\/\/[^\s]+|www\.[^\s]+)');

/// Recursively applies AutoLink to all text nodes in the AST.
///
/// [TypesetTextNode]: Scanned for URLs and linkified.
/// [TypesetStyleNode]: Recursively processes children.
/// [TypesetCodeNode] and [TypesetLinkNode]: Skipped.
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

/// Scans plain text for URLs and converts them to link nodes.
///
/// **Algorithm:**
/// 1. Find all URL matches using [_urlRegex]
/// 2. For each match:
///    - Trim trailing punctuation
///    - Validate the URL against [config]
///    - Create a [TypesetLinkNode] if valid, otherwise keep as text
/// 3. Coalesce adjacent text nodes
///
/// **Returns:** List of text and link nodes (never null, may be empty)
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
    if (!_hasAutoLinkBoundary(text, m.start)) {
      continue;
    }

    // Add text before the URL
    if (m.start > index) {
      _appendText(out, text.substring(index, m.start));
    }

    // Extract and process URL
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
      _appendText(out, raw);
    }

    if (trailing.isNotEmpty) {
      _appendText(out, trailing);
    }

    index = m.end;
  }

  if (index < text.length) {
    _appendText(out, text.substring(index));
  }

  return out;
}

/// Normalizes a URL: converts `www.example.com` to `https://www.example.com`.
String _normalizeAutolinkUrl(String display) {
  if (display.startsWith('www.')) return 'https://$display';
  return display;
}

/// Validates that a URL is safe to use in a link node.
///
/// Checks: scheme allowed, host not empty, domain matches allowlist
/// (if provided), passes custom validator.
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

/// Trims trailing punctuation from a detected URL.
/// (`.`, `,`, `!`, `?`, `:`, `;`, `)`, `]`)
({String url, String trailing}) _trimTrailingPunctuation(String raw) {
  var url = raw;
  var trailing = '';

  while (url.isNotEmpty) {
    final last = url.codeUnitAt(url.length - 1);
    final isTrim = switch (last) {
      46 || // .
      44 || // ,
      33 || // !
      63 || // ?
      58 || // :
      34 || // "
      62 || // >
      59 =>
        true, // ;
      41 => _hasExcessClosingDelimiter(url, 40, 41), // )
      93 => _hasExcessClosingDelimiter(url, 91, 93), // ]
      125 => _hasExcessClosingDelimiter(url, 123, 125), // }
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
  if (start == 0) {
    return true;
  }

  return !_isAutoLinkContinuation(text.codeUnitAt(start - 1));
}

bool _isAutoLinkContinuation(int codeUnit) {
  final isDigit = codeUnit >= 48 && codeUnit <= 57;
  final isUpper = codeUnit >= 65 && codeUnit <= 90;
  final isLower = codeUnit >= 97 && codeUnit <= 122;

  return isDigit ||
      isUpper ||
      isLower ||
      codeUnit == 64 || // @
      codeUnit == 95 || // _
      codeUnit == 45 || // -
      codeUnit == 46 || // .
      codeUnit == 47; // /
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
