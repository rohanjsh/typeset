import 'package:flutter/widgets.dart';
import 'package:typeset/src/config/config.dart';

/// Provides TypeSet configuration to a widget subtree.
final class TypeSetConfigProvider extends InheritedWidget {
  /// Creates a config provider.
  const TypeSetConfigProvider({
    required this.config,
    required super.child,
    super.key,
  });

  /// The config to provide to descendants.
  final TypeSetConfig config;

  /// Returns the nearest ancestor config, or throws.
  static TypeSetConfig of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<TypeSetConfigProvider>();
    assert(
      provider != null,
      'TypeSetConfigProvider.of() called with no '
      'TypeSetConfigProvider ancestor in the widget tree.',
    );
    if (provider == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('TypeSetConfigProvider.of() was called with no ancestor.'),
        ErrorDescription(
          'No TypeSetConfigProvider widget was found above this context.',
        ),
      ]);
    }
    return provider.config;
  }

  /// Returns the nearest ancestor config, or null.
  static TypeSetConfig? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TypeSetConfigProvider>()
        ?.config;
  }

  @override
  bool updateShouldNotify(TypeSetConfigProvider oldWidget) =>
      config != oldWidget.config;
}
