import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/layout/app_card.dart';

/// One point of a policy: a line icon, a short heading and plain text.
typedef LegalSection = ({IconData icon, String title, String body});

class LegalSectionCard extends StatelessWidget {
  const LegalSectionCard({required this.section, super.key});

  final LegalSection section;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          Icon(section.icon, size: AppSizes.iconRow, color: colors.textPrimary),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Text(
                  section.title,
                  style: context.textStyles.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  section.body,
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
