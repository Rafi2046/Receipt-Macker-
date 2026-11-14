import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/pdf/pdf_template.dart';
import '../../../../core/services/url_launch_service.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../../../../core/widgets/pdf/mini_layout_thumbnail.dart';
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
          const _HeroBanner(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.paywallOurPlans,
            style: context.textStyles.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.proSubtitle,
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _Plans(state: state, onBuy: vm.buy, onRetry: vm.load),
          const SizedBox(height: AppSpacing.sectionGap),
          const ProComparisonTable(),
          const SizedBox(height: AppSpacing.lg),
          const _TestimonialCard(),
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
            onPressed: () =>
                UrlLaunchService.openUrl(AppConstants.privacyPolicyUrl),
          ),
          AppButton(
            label: l10n.termsTitle,
            variant: AppButtonVariant.text,
            expand: true,
            onPressed: () =>
                UrlLaunchService.openUrl(AppConstants.termsOfServiceUrl),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.heroStart, colors.heroEnd],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'PRO EXPERIENCE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Premium Billing',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Unlock All 8 Premium Designs',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 20,
            child: Row(
              children: [
                Transform.rotate(
                  angle: -0.1,
                  child: MiniLayoutThumbnail(
                    template: PdfTemplate.classic,
                    accentColor: colors.primary,
                    width: 40,
                    height: 52,
                  ),
                ),
                Transform.translate(
                  offset: const Offset(-8, -4),
                  child: Transform.rotate(
                    angle: 0.1,
                    child: MiniLayoutThumbnail(
                      template: PdfTemplate.modern,
                      accentColor: colors.secondary,
                      width: 40,
                      height: 52,
                    ),
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

class _TestimonialCard extends StatelessWidget {
  const _TestimonialCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (_) => const Icon(Icons.star, size: 16, color: Color(0xFFF59E0B)),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.paywallTestimonialQuote,
            style: context.textStyles.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.paywallTestimonialAuthor,
            style: context.textStyles.labelSmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
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
