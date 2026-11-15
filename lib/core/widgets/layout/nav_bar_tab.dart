import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_durations.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// One destination in [AppNavBar]. Unselected it is a compact icon;
/// selected it grows to [width] as a pill with a brand circle and label.
class NavBarTab extends StatelessWidget {
  const NavBarTab({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.width,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;

  /// Pill width when selected; unselected uses a compact tap slot.
  final double width;
  final VoidCallback onTap;

  static const _labelPadding = EdgeInsetsDirectional.only(
    start: AppSpacing.sm,
    end: AppSpacing.md,
  );

  static TextStyle? _labelStyle(BuildContext context) =>
      context.textStyles.labelMedium?.copyWith(
        color: context.appColors.textPrimary,
        fontWeight: FontWeight.w600,
      );

  /// Width of a pill that fits the longest of [labels].
  static double pillWidthFor(BuildContext context, List<String> labels) {
    final scaler = MediaQuery.textScalerOf(context);
    final style = _labelStyle(context);
    var widest = 0.0;
    for (final label in labels) {
      final painter = TextPainter(
        text: TextSpan(text: label, style: style),
        textDirection: Directionality.of(context),
        textScaler: scaler,
        maxLines: 1,
      )..layout();
      if (painter.width > widest) widest = painter.width;
      painter.dispose();
    }
    return AppSizes.navItemSize + _labelPadding.horizontal + widest.ceil();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final slot = selected ? width : AppSizes.navItemSize;
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: Tooltip(
        message: selected ? '' : label,
        child: Material(
          color: selected
              ? colors.surfaceAlt
              : colors.surface.withValues(alpha: 0),
          shape: const StadiumBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            customBorder: const StadiumBorder(),
            child: AnimatedContainer(
              duration: AppDurations.medium,
              curve: Curves.easeOutCubic,
              width: slot,
              height: AppSizes.navItemSize,
              child: ClipRect(
                child: OverflowBox(
                  alignment: AlignmentDirectional.centerStart,
                  minWidth: slot,
                  maxWidth: slot,
                  child: Row(
                    children: [
                      _IconCircle(
                        icon: selected ? selectedIcon : icon,
                        selected: selected,
                      ),
                      if (selected) Expanded(child: _Label(label: label)),
                    ],
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
      width: AppSizes.navItemSize,
      height: AppSizes.navItemSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? colors.primary : colors.surface.withValues(alpha: 0),
      ),
      child: Icon(
        icon,
        size: AppSizes.navIconSize,
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
      padding: NavBarTab._labelPadding,
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: NavBarTab._labelStyle(context),
      ),
    );
  }
}
