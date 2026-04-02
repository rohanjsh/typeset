import 'package:flutter/foundation.dart';
import 'package:typeset/src/models/typeset_autolink_config.dart';
import 'package:typeset/src/models/typeset_style.dart';

/// Configuration for TypeSet rendering and editing.
@immutable
final class TypeSetConfig {
  /// Creates a TypeSet configuration.
  const TypeSetConfig({
    this.style,
    this.autoLinkConfig,
  });

  /// Creates default configuration with http and https AutoLink schemes.
  factory TypeSetConfig.defaults() {
    return _defaults;
  }

  /// Resolves the effective config by applying precedence in this order:
  /// defaults -> global -> scoped -> local.
  ///
  /// Resolution is field-level, so partially specified configs inherit the
  /// remaining values from less-specific layers.
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

  /// Styling configuration (null means use renderer defaults).
  final TypeSetStyle? style;

  /// AutoLink configuration (null means use scoped or global defaults).
  final TypeSetAutoLinkConfig? autoLinkConfig;

  /// Creates a copy with the given fields replaced.
  TypeSetConfig copyWith({
    TypeSetStyle? style,
    TypeSetAutoLinkConfig? autoLinkConfig,
  }) {
    return TypeSetConfig(
      style: style ?? this.style,
      autoLinkConfig: autoLinkConfig ?? this.autoLinkConfig,
    );
  }

  /// Creates a merged config where non-null values from [override]
  /// replace this config's values field by field.
  TypeSetConfig merge(TypeSetConfig? override) {
    if (override == null) {
      return this;
    }

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
