import 'package:flutter/foundation.dart';
import 'package:typeset/src/models/typeset_config.dart';

/// Global singleton for TypeSet configuration.
final class TypeSetGlobalConfig {
  TypeSetGlobalConfig._();

  /// The global TypeSet configuration instance (set at app startup).
  static TypeSetConfig instance = TypeSetConfig.defaults();

  /// Resets the global configuration to defaults.
  ///
  /// Useful for testing to ensure a clean state.
  @visibleForTesting
  static void reset() {
    instance = TypeSetConfig.defaults();
  }
}
