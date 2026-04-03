import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:typeset/src/config/autolink_config.dart';
import 'package:typeset/src/config/config.dart';
import 'package:typeset/src/config/config_provider.dart';
import 'package:typeset/src/config/global_config.dart';
import 'package:typeset/src/config/style.dart';
import 'package:typeset/src/document.dart';

/// Resolves config through local, scoped, global, and theme layers.
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

/// Manages document caching and gesture recognizer lifecycle.
final class TypeSetRuntimeSession {
  List<GestureRecognizer> _recognizers = <GestureRecognizer>[];
  TypeSetDocument? _cachedDocument;
  String? _cachedInputText;
  TypeSetAutoLinkConfig? _cachedCompileAutoLinkConfig;

  /// Renders content with caching and recognizer management.
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

  /// Clears cache and disposes all recognizers.
  void clear() {
    _cachedDocument = null;
    _cachedInputText = null;
    _cachedCompileAutoLinkConfig = null;
    _replaceRecognizers(const <GestureRecognizer>[]);
  }

  /// Releases all session resources.
  void dispose() {
    clear();
  }

  TypeSetDocument _resolveDocument({
    required String inputText,
    required TypeSetAutoLinkConfig? autoLinkConfig,
  }) {
    final compileConfig = _compileAutoLinkConfig(autoLinkConfig);

    if (_cachedDocument != null &&
        _cachedInputText == inputText &&
        _cachedCompileAutoLinkConfig == compileConfig) {
      return _cachedDocument!;
    }

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
