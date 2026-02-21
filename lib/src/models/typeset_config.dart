import 'package:flutter/foundation.dart';
import 'package:typeset/src/models/typeset_autolink_config.dart';
import 'package:typeset/src/models/typeset_style.dart';

/// Default configuration for TypeSet.
@immutable
final class TypeSetConfig {
  /// Creates a TypeSet configuration.
  const TypeSetConfig({
    this.style,
    this.autoLinkConfig,
  });

  /// Creates default configuration with http and https AutoLink schemes.
  factory TypeSetConfig.defaults() {
    return const TypeSetConfig(
      autoLinkConfig: TypeSetAutoLinkConfig(),
    );
  }

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeSetConfig &&
          runtimeType == other.runtimeType &&
          style == other.style &&
          autoLinkConfig == other.autoLinkConfig;

  @override
  int get hashCode => style.hashCode ^ autoLinkConfig.hashCode;
}
