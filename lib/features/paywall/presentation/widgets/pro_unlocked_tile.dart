import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/layout/app_card.dart';

/// One thing Pro unlocked: a gold icon disc, the benefit and a check.
class ProUnlockedTile extends StatelessWidget {
  const ProUnlockedTile({required this.icon, required this.label, super.key});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.warning.withValues(alpha: 0.16),
                ),
                child: Icon(
                  icon,
                  size: AppSizes.iconRow,
                  color: colors.warning,
                ),
              ),
              const Spacer(),
              Icon(
                AppIcons.success,
                size: AppSizes.iconRow,
                color: colors.success,
              ),
            ],
          ),
          Text(
            label,
            style: context.textStyles.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
