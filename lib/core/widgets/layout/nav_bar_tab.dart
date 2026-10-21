import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_durations.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// One destination in [AppNavBar]. Unselected it is an icon in a circle;
/// selected it grows to [width] as a pill with a filled brand circle and
/// its label. Give every tab the same pill width ([pillWidthFor]) so the
/// dock never changes size when the selection moves.
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

  /// Pill width when selected; a circle ignores it.
  final double width;
  final VoidCallback onTap;

  static const _labelPadding = EdgeInsetsDirectional.only(
    start: AppSpacing.md,
    end: AppSpacing.xl,
  );

  static TextStyle? _labelStyle(BuildContext context) =>
      context.textStyles.labelLarge?.copyWith(
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
    return AppSizes.minTapTarget + _labelPadding.horizontal + widest.ceil();
  }

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
            child: AnimatedContainer(
              duration: AppDurations.medium,
              curve: Curves.easeOutCubic,
              width: selected ? width : AppSizes.minTapTarget,
              // Lay out at the final width and clip while the pill grows,
              // so the label never overflows mid-animation.
              child: ClipRect(
                child: OverflowBox(
                  alignment: AlignmentDirectional.centerStart,
                  minWidth: selected ? width : AppSizes.minTapTarget,
                  maxWidth: selected ? width : AppSizes.minTapTarget,
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
