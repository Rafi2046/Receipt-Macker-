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
    this.subtitle,
    super.key,
  });

  final String label;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final fill = selected ? c.primary : c.surfaceAlt;
    final ink = selected ? c.onPrimary : c.textPrimary;
    final muted = selected
        ? c.onPrimary.withValues(alpha: 0.85)
        : c.textSecondary;
    return Semantics(
      selected: selected,
      button: true,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.lg)),
          border: Border.all(
            color: selected ? c.primary : c.border,
            width: selected
                ? AppSizes.selectedBorderWidth
                : AppSizes.borderWidth,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: c.primary.withValues(alpha: 0.28),
                    blurRadius: AppSpacing.lg,
                    offset: const Offset(0, AppSpacing.xs),
                  ),
                ]
              : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: const BorderRadius.all(
              Radius.circular(AppRadius.lg),
            ),
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppSizes.languageCardHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.lg,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            label,
                            style: context.textStyles.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: ink,
                            ),
                          ),
                          if (subtitle case final sub?
                              when sub.trim().isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              sub,
                              style: context.textStyles.bodyMedium?.copyWith(
                                color: muted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: AppDurations.fast,
                      width: AppSizes.iconMd,
                      height: AppSizes.iconMd,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected
                            ? c.onPrimary.withValues(alpha: 0.2)
                            : null,
                        border: selected
                            ? null
                            : Border.all(color: c.border),
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
      ),
    );
  }
}
