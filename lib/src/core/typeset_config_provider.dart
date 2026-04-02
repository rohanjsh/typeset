import 'package:flutter/widgets.dart';
import 'package:typeset/src/models/typeset_config.dart';

/// Provides TypeSet configuration to a widget subtree.
final class TypeSetConfigProvider extends InheritedWidget {
  /// Creates a TypeSet configuration provider.
  const TypeSetConfigProvider({
    required this.config,
    required super.child,
    super.key,
  });

  /// The configuration provided to the subtree.
  final TypeSetConfig config;

  /// Gets the configuration from the nearest ancestor provider.
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

  /// Gets the configuration from the nearest ancestor provider, if present.
  static TypeSetConfig? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TypeSetConfigProvider>()
        ?.config;
  }

  @override
  bool updateShouldNotify(TypeSetConfigProvider oldWidget) =>
      config != oldWidget.config;
}
