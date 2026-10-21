import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_durations.dart';
import '../../constants/app_opacity.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// One destination in [AppNavBar]: an icon in a pill that fills in when
/// selected, with the label under it.
class NavBarTab extends StatelessWidget {
  const NavBarTab({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final color = selected ? colors.primary : colors.textSecondary;
    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        child: InkResponse(
          onTap: onTap,
          containedInkWell: true,
          highlightShape: BoxShape.rectangle,
          borderRadius: AppRadius.button,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: AppDurations.medium,
                curve: Curves.easeOutCubic,
                width: AppSizes.navIndicatorWidth,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: selected
                      ? colors.primary.withValues(alpha: AppOpacity.tint)
                      : colors.primary.withValues(alpha: 0),
                  borderRadius: AppRadius.chip,
                ),
                child: AnimatedSwitcher(
                  duration: AppDurations.fast,
                  child: Icon(
                    selected ? selectedIcon : icon,
                    key: ValueKey(selected),
                    color: color,
                    size: AppSizes.iconMd,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              AnimatedDefaultTextStyle(
                duration: AppDurations.fast,
                style: (context.textStyles.labelSmall ?? const TextStyle())
                    .copyWith(
                      color: color,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
