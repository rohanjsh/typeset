import 'package:flutter/foundation.dart';
import 'package:typeset/src/config/config.dart';
import 'package:typeset/src/document_cache.dart';

/// Global singleton for TypeSet configuration.
abstract final class TypeSetGlobalConfig {
  TypeSetGlobalConfig._();

  /// The active global config applied to all TypeSet instances.
  static TypeSetConfig current = TypeSetConfig.defaults();

  /// Shared LRU cache for compiled documents.
  /// Set to `null` to disable caching globally.
  static TypeSetDocumentCache? documentCache = TypeSetDocumentCache();

  /// Resets global config and cache to defaults. Test only.
  @visibleForTesting
  static void reset() {
    current = TypeSetConfig.defaults();
    documentCache = TypeSetDocumentCache();
  }
}
