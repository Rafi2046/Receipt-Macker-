import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_durations.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// One destination in [AppNavBar]: a line icon. The selected tab sits in a
/// brand-colored circle that grows in with a soft bounce.
class NavBarTab extends StatelessWidget {
  const NavBarTab({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: Tooltip(
        message: label,
        child: InkResponse(
          onTap: onTap,
          radius: AppSizes.minTapTarget * 0.6,
          child: SizedBox(
            height: AppSizes.navDockHeight,
            child: Center(
              child: AnimatedScale(
                scale: selected ? 1 : 0.9,
                duration: AppDurations.medium,
                curve: Curves.easeOutBack,
                child: AnimatedContainer(
                  duration: AppDurations.medium,
                  curve: Curves.easeOutCubic,
                  width: AppSizes.navSelectedSize,
                  height: AppSizes.navSelectedSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected
                        ? colors.primary
                        : colors.primary.withValues(alpha: 0),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: colors.primary.withValues(alpha: 0.35),
                              blurRadius: AppSpacing.md,
                              offset: const Offset(0, AppSpacing.xs),
                            ),
                          ]
                        : const [],
                  ),
                  child: Icon(
                    icon,
                    size: AppSizes.navIconSize,
                    color: selected ? colors.onPrimary : colors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
