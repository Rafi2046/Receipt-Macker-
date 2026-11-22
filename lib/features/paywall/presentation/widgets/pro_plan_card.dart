import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/purchases/pro_plan.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../l10n/gen/app_localizations.dart';

/// One subscription. The billed [ProPlan.price] is the largest text.
class ProPlanCard extends StatelessWidget {
  const ProPlanCard({
    required this.plan,
    required this.busy,
    required this.onBuy,
    super.key,
  });

  final ProPlan plan;
  final bool busy;
  final VoidCallback? onBuy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final styles = context.textStyles;
    final yearly = plan.period == ProPeriod.yearly;
    final priceStyle = yearly ? styles.titleLarge : styles.titleMedium;
    final colors = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: yearly ? colors.primary.withValues(alpha: 0.04) : colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: yearly ? colors.primary : colors.border,
          width: yearly ? 2 : 1,
        ),
        boxShadow: yearly
            ? [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (yearly) ...[
            Row(
              children: [
                Icon(AppIcons.star, size: 16, color: colors.primary),
                const SizedBox(width: 4),
                Text(
                  l10n.proBestValue,
                  style: styles.labelMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          Text(
            yearly ? l10n.proYearly : l10n.proMonthly,
            style: styles.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(plan.price, style: priceStyle),
          if (_trial(context, l10n) case final trial?) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              trial,
              style: styles.bodySmall?.copyWith(
                color: context.appColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: yearly ? l10n.proYearly : l10n.proMonthly,
            expand: true,
            isLoading: busy,
            onPressed: onBuy,
          ),
        ],
      ),
    );
  }

  String? _trial(BuildContext context, AppLocalizations l10n) {
    final days = plan.trialDays;
    if (days == null || days <= 0) return null;
    final formatted = AppFormatters(
      Localizations.localeOf(context).languageCode,
    ).integer(days);
    return l10n.proTrialThen(formatted, plan.price);
  }
}
