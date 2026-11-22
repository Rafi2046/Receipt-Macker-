import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/purchases/pro_plan.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/buttons/app_button.dart';

/// Docked at the bottom of the paywall: Continue (or "Start free trial")
/// for the chosen plan, and the cancel-anytime line.
class PaywallBuyBar extends StatelessWidget {
  const PaywallBuyBar({
    required this.plan,
    required this.busy,
    required this.onBuy,
    super.key,
  });

  /// Null while prices load or when the store could not be reached.
  final ProPlan? plan;
  final bool busy;
  final ValueChanged<String> onBuy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final plan = this.plan;
    final days = plan?.trialDays;
    final label = days != null && days > 0
        ? l10n.paywallStartTrial(
            AppFormatters(Localizations.localeOf(context).languageCode)
                .integer(days),
          )
        : l10n.paywallContinue;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            AppSpacing.md,
            AppSpacing.pagePadding,
            AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.sm,
            children: [
              AppButton(
                label: label,
                expand: true,
                isLoading: busy,
                onPressed: plan == null || busy ? null : () => onBuy(plan.id),
              ),
              Text(
                l10n.paywallCancelAnytime,
                textAlign: TextAlign.center,
                style: context.textStyles.labelSmall?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
