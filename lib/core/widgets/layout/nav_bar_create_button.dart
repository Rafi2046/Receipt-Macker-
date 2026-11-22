import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_opacity.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// The round create button in the middle of [AppNavBar].
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
    return Tooltip(
      message: tooltip,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: AppOpacity.shadow * 4),
              blurRadius: AppSpacing.md,
              offset: const Offset(0, AppSpacing.xs),
            ),
          ],
        ),
        child: Material(
          color: colors.primary,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: SizedBox.square(
              dimension: AppSizes.navCreateSize,
              child: Icon(
                AppIcons.addRounded,
                color: colors.onPrimary,
                size: AppSizes.iconMd,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
