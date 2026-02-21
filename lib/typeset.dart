/// TypeSet public API.
///
/// Provides:
/// - TypeSet widget for rendering inline-formatted text.
/// - TypeSetEditingController for editing with live formatting markers.
/// - getTypesetContextMenus helper for text selection actions.
/// - Configuration models for style and AutoLink behavior.
library typeset;

export 'src/core/typeset_config_provider.dart';
export 'src/models/typeset_autolink_config.dart';
export 'src/models/typeset_config.dart';
export 'src/models/typeset_global_config.dart';
export 'src/models/typeset_reserved.dart';
export 'src/models/typeset_style.dart';
export 'src/view/typeset.dart';
export 'src/view/typeset_context_menus.dart';
export 'src/view/typeset_editing_controller.dart';
export 'src/view/typeset_ext.dart';
