import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_durations.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// One destination in [AppNavBar]: a line icon over a short label. The
/// selected tab is tinted with the brand color and shows a small dot.
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
    final tint = selected ? colors.primary : colors.textSecondary;
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: AppSizes.minTapTarget * 0.75,
        child: SizedBox(
          height: AppSizes.navDockHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppSpacing.xxs,
            children: [
              AnimatedScale(
                scale: selected ? 1.08 : 1,
                duration: AppDurations.medium,
                child: Icon(icon, size: AppSizes.navIconSize, color: tint),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: context.textStyles.labelSmall?.copyWith(
                  color: tint,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
