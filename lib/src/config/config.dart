import 'package:flutter/foundation.dart';
import 'package:typeset/src/config/autolink_config.dart';
import 'package:typeset/src/config/style.dart';

/// Configuration for TypeSet rendering and editing.
@immutable
final class TypeSetConfig {
  /// Creates a config.
  const TypeSetConfig({
    this.style,
    this.autoLinkConfig,
  });

  /// Returns library defaults.
  factory TypeSetConfig.defaults() => _defaults;

  /// Resolves config: defaults → global → scoped → local.
  factory TypeSetConfig.resolve({
    TypeSetConfig? local,
    TypeSetConfig? scoped,
    TypeSetConfig? global,
    TypeSetConfig? defaults,
  }) {
    return (defaults ?? TypeSetConfig.defaults())
        .merge(global)
        .merge(scoped)
        .merge(local);
  }

  static final TypeSetConfig _defaults = TypeSetConfig(
    autoLinkConfig: TypeSetAutoLinkConfig(),
  );

  /// Style overrides.
  final TypeSetStyle? style;

  /// AutoLink detection settings.
  final TypeSetAutoLinkConfig? autoLinkConfig;

  /// Returns a copy with the given fields replaced.
  TypeSetConfig copyWith({
    TypeSetStyle? style,
    TypeSetAutoLinkConfig? autoLinkConfig,
  }) {
    return TypeSetConfig(
      style: style ?? this.style,
      autoLinkConfig: autoLinkConfig ?? this.autoLinkConfig,
    );
  }

  /// Merges [override] on top of this config.
  TypeSetConfig merge(TypeSetConfig? override) {
    if (override == null) return this;

    return TypeSetConfig(
      style: style == null ? override.style : style!.merge(override.style),
      autoLinkConfig: autoLinkConfig == null
          ? override.autoLinkConfig
          : autoLinkConfig!.merge(override.autoLinkConfig),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeSetConfig &&
          runtimeType == other.runtimeType &&
          style == other.style &&
          autoLinkConfig == other.autoLinkConfig;

  @override
  int get hashCode => Object.hash(style, autoLinkConfig);
}
