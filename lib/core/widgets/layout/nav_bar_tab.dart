import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_durations.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// One destination in [AppNavBar]. Unselected it is an icon in a circle;
/// selected it grows into a pill with a filled brand circle and its label.
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
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: Tooltip(
        message: selected ? '' : label,
        child: Material(
          color: colors.surfaceAlt,
          shape: const StadiumBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            // AnimatedSize clips, so the label never overflows while the
            // pill grows.
            child: AnimatedSize(
              duration: AppDurations.medium,
              curve: Curves.easeOutCubic,
              alignment: AlignmentDirectional.centerStart,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _IconCircle(
                    icon: selected ? selectedIcon : icon,
                    selected: selected,
                  ),
                  if (selected) Flexible(child: _Label(label: label)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  const _IconCircle({required this.icon, required this.selected});

  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AnimatedContainer(
      duration: AppDurations.medium,
      curve: Curves.easeOutCubic,
      width: AppSizes.minTapTarget,
      height: AppSizes.minTapTarget,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? colors.primary : colors.surfaceAlt,
      ),
      child: Icon(
        icon,
        size: AppSizes.iconMd,
        color: selected ? colors.onPrimary : colors.textSecondary,
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: AppSpacing.md,
        end: AppSpacing.xl,
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: context.textStyles.labelLarge?.copyWith(
          color: context.appColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
