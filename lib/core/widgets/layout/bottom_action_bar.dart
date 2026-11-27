import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_opacity.dart';
import '../../constants/app_spacing.dart';

/// The bar at the foot of a form page that holds its main button(s): its
/// own surface, lifted off the page by a hairline and a soft shadow.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
        boxShadow: [
          BoxShadow(
            color: colors.shadowOf(AppOpacity.shadow),
            blurRadius: AppSpacing.lg,
            offset: const Offset(0, -AppSpacing.xs),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePadding,
            vertical: AppSpacing.md,
          ),
          child: child,
        ),
      ),
    );
  }
}
