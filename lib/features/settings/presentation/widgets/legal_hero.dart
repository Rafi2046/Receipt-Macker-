import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';

/// Plain top of a legal or help page: an optional line icon, the title, a
/// one-line summary and an optional "last updated" note. No color fill.
class LegalHero extends StatelessWidget {
  const LegalHero({
    required this.title,
    required this.intro,
    this.icon,
    this.note,
    super.key,
  });

  final String title;
  final String intro;
  final IconData? icon;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final icon = this.icon;
    final note = this.note;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        if (icon != null)
          Icon(icon, size: AppSizes.iconLg, color: colors.textPrimary),
        Text(
          title,
          style: context.textStyles.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          intro,
          style: context.textStyles.bodyLarge?.copyWith(
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
    );
  }
}
