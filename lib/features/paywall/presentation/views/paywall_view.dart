import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../paywall_state.dart';
import '../view_models/paywall_view_model.dart';
import '../widgets/pro_comparison_table.dart';
import '../widgets/pro_plan_card.dart';

/// Pro plans, real store prices, and the Free versus Pro table.
class PaywallView extends ConsumerWidget {
  const PaywallView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    ref.listen(paywallViewModelProvider.select((s) => s.notice), (_, notice) {
      if (notice == null || !context.mounted) return;
      AppSnackbar.show(
        context,
        switch (notice) {
          PaywallNotice.restored => l10n.proRestored,
          PaywallNotice.none => l10n.proNothingToRestore,
          PaywallNotice.failed => l10n.proBuyFailed,
        },
        tone: notice == PaywallNotice.restored
            ? AppSnackbarTone.success
            : AppSnackbarTone.error,
      );
      ref.read(paywallViewModelProvider.notifier).clearNotice();
    });
    final state = ref.watch(paywallViewModelProvider);
    final vm = ref.read(paywallViewModelProvider.notifier);
    return AppScaffold(
      title: l10n.proTitle,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          Text(l10n.proSubtitle, style: context.textStyles.bodyLarge),
          const SizedBox(height: AppSpacing.lg),
          _Plans(state: state, onBuy: vm.buy, onRetry: vm.load),
          const SizedBox(height: AppSpacing.sectionGap),
          const ProComparisonTable(),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: l10n.proRestore,
            variant: AppButtonVariant.secondary,
            expand: true,
            isLoading: state.busy,
            onPressed: state.busy ? null : vm.restore,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: l10n.privacyTitle,
            variant: AppButtonVariant.text,
            expand: true,
            onPressed: () => context.pushNamed(RouteNames.privacy),
          ),
          AppButton(
            label: l10n.termsTitle,
            variant: AppButtonVariant.text,
            expand: true,
            onPressed: () => context.pushNamed(RouteNames.terms),
          ),
        ],
      ),
    );
  }
}

class _Plans extends StatelessWidget {
  const _Plans({
    required this.state,
    required this.onBuy,
    required this.onRetry,
  });

  final PaywallState state;
  final Future<bool> Function(String productId) onBuy;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    if (state.loading) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.plans.isEmpty) {
      return Column(
        children: [
          Text(context.l10n.proPriceUnavailable),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: context.l10n.retry,
            variant: AppButtonVariant.secondary,
            onPressed: onRetry,
          ),
        ],
      );
    }
    return Column(
      children: [
        for (final plan in state.plans) ...[
          ProPlanCard(
            plan: plan,
            busy: state.busy,
            onBuy: state.busy
                ? null
                : () async {
                    final bought = await onBuy(plan.id);
                    if (bought && context.mounted) {
                      context.pushReplacementNamed(RouteNames.proWelcome);
                    }
                  },
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}
