import 'package:flutter/widgets.dart';
import 'package:typeset/src/models/typeset_config.dart';

/// Provides TypeSet configuration to a widget subtree.
class TypeSetConfigProvider extends InheritedWidget {
  /// Creates a TypeSet configuration provider.
  const TypeSetConfigProvider({
    required this.config,
    required super.child,
    super.key,
  });

  /// The configuration provided to the subtree.
  final TypeSetConfig config;

  /// Gets the configuration from the nearest ancestor provider.
  static TypeSetConfig? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TypeSetConfigProvider>()
        ?.config;
  }

  /// Gets the configuration from the nearest ancestor provider, or the default.
  static TypeSetConfig maybeOf(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<TypeSetConfigProvider>()
            ?.config ??
        TypeSetConfig.defaults();
  }

  @override
  bool updateShouldNotify(TypeSetConfigProvider oldWidget) =>
      config != oldWidget.config;
}
