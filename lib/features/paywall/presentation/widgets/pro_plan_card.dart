import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/purchases/pro_plan.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';

/// One subscription to pick. The billed [ProPlan.price] is the largest
/// text; the period and any free trial sit in smaller type (CLAUDE §9.1).
class ProPlanCard extends StatelessWidget {
  const ProPlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final ProPlan plan;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final styles = context.textStyles;
    final yearly = plan.period == ProPeriod.yearly;
    final days = plan.trialDays;
    final trial = days == null || days <= 0
        ? null
        : l10n.proTrialThen(
            AppFormatters(Localizations.localeOf(context).languageCode)
                .integer(days),
            plan.price,
          );
    return Semantics(
      selected: selected,
      button: true,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: AppDurations.fast,
            decoration: BoxDecoration(
              color: selected
                  ? colors.primary.withValues(alpha: 0.06)
                  : colors.surface,
              borderRadius: AppRadius.card,
              border: Border.all(
                color: selected ? colors.primary : colors.border,
                width: selected
                    ? AppSizes.selectedBorderWidth
                    : AppSizes.borderWidth,
              ),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                borderRadius: AppRadius.card,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    spacing: AppSpacing.md,
                    children: [
                      Icon(
                        selected ? AppIcons.success : AppIcons.unchecked,
                        color: selected ? colors.primary : colors.border,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: AppSpacing.xxs,
                          children: [
                            Text(
                              yearly ? l10n.proYearly : l10n.proMonthly,
                              style: styles.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (trial != null)
                              Text(
                                trial,
                                style: styles.bodySmall?.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerEnd,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                plan.price,
                                style: styles.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                              Text(
                                yearly
                                    ? l10n.paywallPerYear
                                    : l10n.paywallPerMonth,
                                style: styles.labelSmall?.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (yearly)
            Positioned(
              top: -AppSpacing.md,
              right: AppSpacing.lg,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: colors.warning,
                  borderRadius: AppRadius.chip,
                ),
                child: Text(
                  l10n.proBestValue,
                  style: styles.labelSmall?.copyWith(
                    color: colors.panel,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
