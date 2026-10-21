import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_opacity.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// The gradient "new invoice" button in the middle of [AppNavBar].
class NavBarCreateButton extends StatelessWidget {
  const NavBarCreateButton({
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Tooltip(
        message: tooltip,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadius.button,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.heroStart, colors.heroEnd],
            ),
            boxShadow: [
              BoxShadow(
                color: colors.heroStart.withValues(alpha: AppOpacity.glow),
                blurRadius: AppSpacing.lg,
                offset: const Offset(0, AppSpacing.sm),
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onPressed,
              borderRadius: AppRadius.button,
              child: SizedBox.square(
                dimension: AppSizes.navCreateButton,
                child: Icon(
                  AppIcons.addRounded,
                  color: colors.onHero,
                  size: AppSizes.iconLg,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
