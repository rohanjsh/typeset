import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

/// Configuration for AutoLink URL detection and behavior.
@immutable
final class TypeSetAutoLinkConfig {
  /// Creates an AutoLink configuration with optional scheme/domain validation.
  TypeSetAutoLinkConfig({
    Set<String>? allowedSchemes,
    this.allowedDomains,
    this.customValidator,
    this.linkRecognizerBuilder,
  }) : _allowedSchemes = allowedSchemes == null
            ? null
            : UnmodifiableSetView(Set<String>.of(allowedSchemes));

  static const Set<String> _defaultAllowedSchemes = {'http', 'https'};
  static const Object _unset = Object();

  final Set<String>? _allowedSchemes;

  /// Allowed URL schemes.
  ///
  /// When this config is used standalone, omitted schemes default to
  /// `http` and `https`. During config merging, an omitted value inherits
  /// the less-specific configuration.
  Set<String> get allowedSchemes => _allowedSchemes ?? _defaultAllowedSchemes;

  /// Optional regex pattern for domain allowlisting.
  final RegExp? allowedDomains;

  /// Custom validation function for URLs.
  final bool Function(Uri uri)? customValidator;

  /// Builder function for link gesture recognizers.
  final GestureRecognizer Function(String linkText, String url)? //
      linkRecognizerBuilder;

  /// Predefined config: HTTPS only (no HTTP).
  static final httpsOnly = TypeSetAutoLinkConfig(
    allowedSchemes: const <String>{'https'},
  );

  /// Predefined config: Disable autolink entirely.
  static final disabled = TypeSetAutoLinkConfig(
    allowedSchemes: const <String>{},
  );

  /// Creates a copy with the given fields replaced.
  TypeSetAutoLinkConfig copyWith({
    Object? allowedSchemes = _unset,
    Object? allowedDomains = _unset,
    Object? customValidator = _unset,
    Object? linkRecognizerBuilder = _unset,
  }) {
    return TypeSetAutoLinkConfig(
      allowedSchemes: identical(allowedSchemes, _unset)
          ? _allowedSchemes
          : allowedSchemes as Set<String>?,
      allowedDomains: identical(allowedDomains, _unset)
          ? this.allowedDomains
          : allowedDomains as RegExp?,
      customValidator: identical(customValidator, _unset)
          ? this.customValidator
          : customValidator as bool Function(Uri uri)?,
      linkRecognizerBuilder: identical(linkRecognizerBuilder, _unset)
          ? this.linkRecognizerBuilder
          : linkRecognizerBuilder as GestureRecognizer Function(
              String linkText,
              String url,
            )?,
    );
  }

  /// Creates a merged config where non-null values from [override]
  /// replace this config's values.
  TypeSetAutoLinkConfig merge(TypeSetAutoLinkConfig? override) {
    if (override == null) {
      return this;
    }

    return TypeSetAutoLinkConfig(
      allowedSchemes: override._allowedSchemes ?? _allowedSchemes,
      allowedDomains: override.allowedDomains ?? allowedDomains,
      customValidator: override.customValidator ?? customValidator,
      linkRecognizerBuilder:
          override.linkRecognizerBuilder ?? linkRecognizerBuilder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeSetAutoLinkConfig &&
          runtimeType == other.runtimeType &&
          setEquals(_allowedSchemes, other._allowedSchemes) &&
          _regExpEquals(allowedDomains, other.allowedDomains) &&
          customValidator == other.customValidator &&
          linkRecognizerBuilder == other.linkRecognizerBuilder;

  @override
  int get hashCode => Object.hash(
        _allowedSchemes == null
            ? null
            : Object.hashAllUnordered(_allowedSchemes!),
        _regExpHash(allowedDomains),
        customValidator,
        linkRecognizerBuilder,
      );
}

bool _regExpEquals(RegExp? left, RegExp? right) {
  if (identical(left, right)) {
    return true;
  }
  if (left == null || right == null) {
    return false;
  }

  return left.pattern == right.pattern &&
      left.isCaseSensitive == right.isCaseSensitive &&
      left.isMultiLine == right.isMultiLine &&
      left.isUnicode == right.isUnicode &&
      left.isDotAll == right.isDotAll;
}

int? _regExpHash(RegExp? value) {
  if (value == null) {
    return null;
  }

  return Object.hash(
    value.pattern,
    value.isCaseSensitive,
    value.isMultiLine,
    value.isUnicode,
    value.isDotAll,
  );
}
