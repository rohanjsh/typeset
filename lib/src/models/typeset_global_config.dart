import 'package:flutter/foundation.dart';
import 'package:typeset/src/models/typeset_config.dart';
import 'package:typeset/src/models/typeset_document_cache.dart';

/// Global singleton for TypeSet configuration.
abstract final class TypeSetGlobalConfig {
  TypeSetGlobalConfig._();

  /// The global TypeSet configuration (set at app startup).
  static TypeSetConfig current = TypeSetConfig.defaults();

  /// Shared LRU cache for compiled documents.
  ///
  /// All TypeSet widgets and editing controllers share this cache
  /// automatically, so the same text is never parsed more than once per config.
  ///
  /// Set to `null` to disable caching globally (useful in memory-constrained
  /// environments or when content changes on every render).
  ///
  /// Defaults to an LRU cache with a capacity of 256 documents.
  static TypeSetDocumentCache? documentCache = TypeSetDocumentCache();

  /// Resets the global configuration and cache to defaults.
  ///
  /// Useful for testing to ensure a clean state.
  @visibleForTesting
  static void reset() {
    current = TypeSetConfig.defaults();
    documentCache = TypeSetDocumentCache();
  }
}
