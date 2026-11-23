import 'package:flutter/material.dart';

import 'app_opacity.dart';
import 'app_sizes.dart';
import 'app_spacing.dart';

/// Soft elevation for floating chrome (AppBar pill, docks).
abstract final class AppShadows {
  static List<BoxShadow> bar(Color shadowColor) => [
        BoxShadow(
          color: shadowColor.withValues(alpha: AppOpacity.shadow),
          blurRadius: AppSizes.pageShadowBlur,
          offset: const Offset(0, AppSpacing.xs),
        ),
      ];
}
