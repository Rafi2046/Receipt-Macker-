import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/layout/app_card.dart';

/// What Pro unlocked, as one calm card: a gold check, the benefit and a
/// short line under it. No per-row icons.
class ProBenefitList extends StatelessWidget {
  const ProBenefitList({required this.benefits, super.key});

  /// Title and one-line description of each benefit.
  final List<(String, String)> benefits;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        children: [
          for (var i = 0; i < benefits.length; i++) ...[
            if (i > 0)
              Divider(
                height: AppSizes.borderWidth,
                indent: AppSpacing.lg + AppSizes.iconMd + AppSpacing.md,
                color: colors.border,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.md,
                children: [
                  Container(
                    width: AppSizes.iconMd,
                    height: AppSizes.iconMd,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.warning,
                    ),
                    child: Icon(
                      AppIcons.check,
                      size: AppSizes.iconSm,
                      color: colors.panel,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSpacing.xxs,
                      children: [
                        Text(
                          benefits[i].$1,
                          style: context.textStyles.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          benefits[i].$2,
                          style: context.textStyles.bodySmall?.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
