import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../paywall_state.dart';
import 'pro_plan_card.dart';

/// The plans to pick from; a spinner while prices load and a retry when
/// Google Play could not be reached.
class PaywallPlans extends StatelessWidget {
  const PaywallPlans({
    required this.state,
    required this.onSelect,
    required this.onRetry,
    super.key,
  });

  final PaywallState state;
  final ValueChanged<String> onSelect;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (state.loading) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.plans.isEmpty) {
      return Column(
        spacing: AppSpacing.md,
        children: [
          Text(
            l10n.proPriceUnavailable,
            textAlign: TextAlign.center,
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
          AppButton(
            label: l10n.retry,
            variant: AppButtonVariant.secondary,
            onPressed: onRetry,
          ),
        ],
      );
    }
    final selected = state.selected;
    return Column(
      spacing: AppSpacing.lg,
      children: [
        for (final plan in state.plans)
          ProPlanCard(
            plan: plan,
            selected: plan.id == selected?.id,
            onTap: state.busy ? null : () => onSelect(plan.id),
          ),
      ],
    );
  }
}
