import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/url_launch_service.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/layout/top_bar_button.dart';
import '../paywall_state.dart';
import '../view_models/paywall_view_model.dart';
import '../widgets/paywall_buy_bar.dart';
import '../widgets/paywall_feature_carousel.dart';
import '../widgets/paywall_plans.dart';
import '../widgets/pro_badge.dart';
import '../widgets/pro_comparison_table.dart';

/// The Pro offer: what it adds, real store prices, one Continue button,
/// and the Free versus Pro table (CLAUDE §9.1).
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
    return Scaffold(
      backgroundColor: context.appColors.background,
      bottomNavigationBar: PaywallBuyBar(
        plan: state.selected,
        busy: state.busy,
        onBuy: (id) async {
          final bought = await vm.buy(id);
          if (bought && context.mounted) {
            context.pushReplacementNamed(RouteNames.proWelcome);
          }
        },
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            AppSpacing.sm,
            AppSpacing.pagePadding,
            AppSpacing.xxl,
          ),
          children: [
            Row(
              children: [
                TopBarButton(
                  icon: AppIcons.close,
                  semanticLabel: l10n.close,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: state.busy ? null : vm.restore,
                      child: Text(
                        l10n.proRestore,
                        maxLines: 2,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const _Headline(),
            const SizedBox(height: AppSpacing.xl),
            const PaywallFeatureCarousel(),
            const SizedBox(height: AppSpacing.xxl),
            PaywallPlans(state: state, onSelect: vm.select, onRetry: vm.load),
            const SizedBox(height: AppSpacing.sectionGap),
            Text(
              l10n.paywallCompareTitle,
              textAlign: TextAlign.center,
              style: context.textStyles.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const ProComparisonTable(),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                AppButton(
                  label: l10n.privacyTitle,
                  variant: AppButtonVariant.text,
                  onPressed: () =>
                      UrlLaunchService.openUrl(AppConstants.privacyPolicyUrl),
                ),
                AppButton(
                  label: l10n.termsTitle,
                  variant: AppButtonVariant.text,
                  onPressed: () =>
                      UrlLaunchService.openUrl(AppConstants.termsOfServiceUrl),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      spacing: AppSpacing.sm,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            Text(
              l10n.paywallUpgradeTo,
              style: context.textStyles.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const ProBadge(),
          ],
        ),
        Text(
          l10n.paywallTagline,
          textAlign: TextAlign.center,
          style: context.textStyles.bodyMedium?.copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
