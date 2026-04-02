import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:typeset/src/core/typeset_config_provider.dart';
import 'package:typeset/src/models/typeset_autolink_config.dart';
import 'package:typeset/src/models/typeset_config.dart';
import 'package:typeset/src/models/typeset_document.dart';
import 'package:typeset/src/models/typeset_global_config.dart';
import 'package:typeset/src/models/typeset_style.dart';

/// Resolves TypeSet configuration using local, scoped, global, theme, and
/// default layers.
///
/// Precedence order (highest wins):
/// 1. [local] config passed to a widget or controller
/// 2. nearest [TypeSetConfigProvider] in the tree
/// 3. [TypeSetGlobalConfig.current]
/// 4. theme-derived defaults from the active [ThemeData]
/// 5. library defaults
TypeSetConfig resolveTypeSetConfig(
  BuildContext context, {
  TypeSetConfig? local,
}) {
  final theme = Theme.of(context);
  final themeConfig = TypeSetConfig(
    style: TypeSetStyle.fromTheme(theme),
  );
  return TypeSetConfig.resolve(
    local: local,
    scoped: TypeSetConfigProvider.maybeOf(context),
    global: TypeSetGlobalConfig.current,
    defaults: TypeSetConfig.defaults().merge(themeConfig),
  );
}

/// Shared runtime session for document caching and recognizer lifecycle.
final class TypeSetRuntimeSession {
  List<GestureRecognizer> _recognizers = <GestureRecognizer>[];
  TypeSetDocument? _cachedDocument;
  String? _cachedInputText;
  TypeSetAutoLinkConfig? _cachedCompileAutoLinkConfig;

  /// Renders the given content with consistent caching and recognizer handling.
  List<InlineSpan> render({
    required String inputText,
    required TypeSetConfig config,
    bool showDelimiters = false,
  }) {
    final nextRecognizers = <GestureRecognizer>[];
    final document = _resolveDocument(
      inputText: inputText,
      autoLinkConfig: config.autoLinkConfig,
    );

    final spans = document.render(
      style: config.style,
      showDelimiters: showDelimiters,
      linkRecognizerBuilder: config.autoLinkConfig?.linkRecognizerBuilder,
      onLinkRecognizerCreated: nextRecognizers.add,
    );

    _replaceRecognizers(nextRecognizers);
    return spans;
  }

  /// Clears cached documents and disposes active recognizers.
  void clear() {
    _cachedDocument = null;
    _cachedInputText = null;
    _cachedCompileAutoLinkConfig = null;
    _replaceRecognizers(const <GestureRecognizer>[]);
  }

  /// Releases all runtime resources held by this session.
  void dispose() {
    clear();
  }

  TypeSetDocument _resolveDocument({
    required String inputText,
    required TypeSetAutoLinkConfig? autoLinkConfig,
  }) {
    final compileConfig = _compileAutoLinkConfig(autoLinkConfig);

    // Fast path: session-level single-entry cache (same widget, same text).
    if (_cachedDocument != null &&
        _cachedInputText == inputText &&
        _cachedCompileAutoLinkConfig == compileConfig) {
      return _cachedDocument!;
    }

    // Slow path: check the global LRU cache before compiling.
    final globalCache = TypeSetGlobalConfig.documentCache;
    final nextDocument = globalCache != null
        ? globalCache.getOrCompile(inputText, autoLinkConfig: compileConfig)
        : TypeSetDocument.compile(inputText, autoLinkConfig: compileConfig);

    _cachedDocument = nextDocument;
    _cachedInputText = inputText;
    _cachedCompileAutoLinkConfig = compileConfig;
    return nextDocument;
  }

  static TypeSetAutoLinkConfig? _compileAutoLinkConfig(
    TypeSetAutoLinkConfig? autoLinkConfig,
  ) {
    return autoLinkConfig?.copyWith(linkRecognizerBuilder: null);
  }

  void _replaceRecognizers(List<GestureRecognizer> nextRecognizers) {
    final previousRecognizers = _recognizers;
    _recognizers = nextRecognizers;

    for (final recognizer in previousRecognizers) {
      recognizer.dispose();
    }
  }
}
