import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';

/// Large selectable card for one UI language.
class LanguageOptionCard extends StatelessWidget {
  const LanguageOptionCard({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    // Label always uses textPrimary so selected coral stays readable on
    // dark surfaces (primary-colored text on charcoal fails contrast).
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected
            ? Color.alphaBlend(c.primary.withValues(alpha: 0.14), c.surfaceAlt)
            : c.surfaceAlt,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(
            color: selected ? c.primary : c.border,
            width: selected
                ? AppSizes.selectedBorderWidth
                : AppSizes.borderWidth,
          ),
        ),
        child: InkWell(
          borderRadius: AppRadius.card,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSizes.languageCardHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: context.textStyles.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: AppDurations.fast,
                    width: AppSizes.iconMd,
                    height: AppSizes.iconMd,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? c.primary : null,
                      border: selected ? null : Border.all(color: c.border),
                    ),
                    child: selected
                        ? Icon(
                            AppIcons.check,
                            size: AppSizes.iconSm,
                            color: c.onPrimary,
                          )
                        : null,
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
