import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// One round color choice with a 48dp tap area. Selected shows a ring and a
/// check; [badge] puts a small icon on the corner (logo, edit).
class AccentDot extends StatelessWidget {
  const AccentDot({
    required this.label,
    required this.onTap,
    this.color,
    this.gradient,
    this.selected = false,
    this.badge,
    this.centerIcon,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final Gradient? gradient;
  final bool selected;
  final IconData? badge;
  final IconData? centerIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final fill = color ?? colors.surfaceAlt;
    final onFill = ThemeData.estimateBrightnessForColor(fill) == Brightness.dark
        ? colors.onPrimary
        : colors.textPrimary;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkResponse(
        onTap: onTap,
        radius: AppSizes.minTapTarget / 2,
        child: SizedBox.square(
          dimension: AppSizes.minTapTarget,
          child: Center(
            child: AnimatedContainer(
              duration: kThemeAnimationDuration,
              padding: const EdgeInsets.all(AppSpacing.xxs),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? colors.textPrimary : colors.border,
                  width: selected
                      ? AppSizes.selectedBorderWidth
                      : AppSizes.borderWidth,
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: AppSizes.accentDot,
                    height: AppSizes.accentDot,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: gradient == null ? fill : null,
                      gradient: gradient,
                    ),
                    child: switch ((selected, centerIcon)) {
                      (true, _) => Icon(
                        AppIcons.check,
                        size: AppSizes.iconSm,
                        color: onFill,
                      ),
                      (false, final IconData icon) => Icon(
                        icon,
                        size: AppSizes.iconSm,
                        color: onFill,
                      ),
                      _ => null,
                    },
                  ),
                  if (badge case final IconData icon)
                    Positioned(
                      right: -AppSpacing.xs,
                      bottom: -AppSpacing.xs,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.xxs),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.border),
                        ),
                        child: Icon(
                          icon,
                          size: AppSizes.accentDotBadge - AppSpacing.xs,
                          color: colors.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
