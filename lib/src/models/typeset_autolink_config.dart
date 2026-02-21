import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

/// Configuration for AutoLink URL detection and behavior.
@immutable
final class TypeSetAutoLinkConfig {
  /// Creates an AutoLink configuration with optional scheme/domain validation.
  const TypeSetAutoLinkConfig({
    this.allowedSchemes = const {'http', 'https'},
    this.allowedDomains,
    this.customValidator,
    this.linkRecognizerBuilder,
  });

  /// Allowed URL schemes (default: http, https). Empty set disables autolink.
  final Set<String> allowedSchemes;

  /// Optional regex pattern for domain allowlisting.
  final RegExp? allowedDomains;

  /// Custom validation function for URLs.
  final bool Function(Uri uri)? customValidator;

  /// Builder function for link gesture recognizers.
  final GestureRecognizer Function(String linkText, String url)? //
      linkRecognizerBuilder;

  /// Predefined config: HTTPS only (no HTTP).
  static const httpsOnly = TypeSetAutoLinkConfig(
    allowedSchemes: {'https'},
  );

  /// Predefined config: Disable autolink entirely.
  static const disabled = TypeSetAutoLinkConfig(
    allowedSchemes: {},
  );

  /// Creates a copy with the given fields replaced.
  TypeSetAutoLinkConfig copyWith({
    Set<String>? allowedSchemes,
    RegExp? allowedDomains,
    bool Function(Uri uri)? customValidator,
    GestureRecognizer Function(String linkText, String url)?
        linkRecognizerBuilder,
  }) {
    return TypeSetAutoLinkConfig(
      allowedSchemes: allowedSchemes ?? this.allowedSchemes,
      allowedDomains: allowedDomains ?? this.allowedDomains,
      customValidator: customValidator ?? this.customValidator,
      linkRecognizerBuilder:
          linkRecognizerBuilder ?? this.linkRecognizerBuilder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeSetAutoLinkConfig &&
          runtimeType == other.runtimeType &&
          allowedSchemes == other.allowedSchemes &&
          allowedDomains == other.allowedDomains &&
          customValidator == other.customValidator &&
          linkRecognizerBuilder == other.linkRecognizerBuilder;

  @override
  int get hashCode =>
      allowedSchemes.hashCode ^
      allowedDomains.hashCode ^
      customValidator.hashCode ^
      linkRecognizerBuilder.hashCode;
}
