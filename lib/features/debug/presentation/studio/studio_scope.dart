import 'package:flutter/widgets.dart';

import 'studio_font.dart';
import 'studio_palette.dart';
import 'studio_type.dart';

/// Palette and type for the mock screens under this route.
class StudioScope extends InheritedWidget {
  const StudioScope({
    required this.palette,
    required this.type,
    required this.font,
    required super.child,
    super.key,
  });

  final StudioPalette palette;
  final StudioType type;
  final StudioFont font;

  static StudioScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<StudioScope>();
    if (scope == null) {
      throw StateError('StudioScope is missing above this widget');
    }
    return scope;
  }

  @override
  bool updateShouldNotify(StudioScope oldWidget) =>
      oldWidget.palette != palette ||
      oldWidget.font != font ||
      oldWidget.type.family != type.family;
}

extension StudioContext on BuildContext {
  StudioPalette get studio => StudioScope.of(this).palette;

  StudioType get studioType => StudioScope.of(this).type;
}
