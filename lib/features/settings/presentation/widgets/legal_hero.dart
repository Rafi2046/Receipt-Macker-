import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';

/// Top of a legal or help page: a large line icon on a soft tint, the page
/// title, a one-line summary and an optional "last updated" note.
class LegalHero extends StatelessWidget {
  const LegalHero({
    required this.icon,
    required this.title,
    required this.intro,
    this.note,
    super.key,
  });

  final IconData icon;
  final String title;
  final String intro;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final note = this.note;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: AppRadius.card,
        border: Border.all(color: colors.primary.withValues(alpha: 0.16)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary.withValues(alpha: 0.10), colors.surface],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: colors.border),
            ),
            child: Icon(icon, size: AppSizes.iconLg, color: colors.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: context.textStyles.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            intro,
            style: context.textStyles.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          if (note != null)
            Text(
              note,
              style: context.textStyles.labelSmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}
