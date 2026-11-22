import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/purchases/free_plan.dart';
import '../../../../core/services/url_launch_service.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../widgets/paywall_slides.dart';
import '../widgets/pro_badge.dart';
import '../widgets/pro_benefit_list.dart';

/// Shown right after a purchase: a welcome, what Pro unlocked, and a link
/// to manage the subscription in Google Play (CLAUDE §9.1).
class ProWelcomeView extends StatelessWidget {
  const ProWelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final benefits = <(String, String)>[
      (
        l10n.proUnlockedTemplates(format.integer(FreePlan.designCount)),
        l10n.proBenefitDesigns,
      ),
      (l10n.proUnlockedColors, l10n.proBenefitColors),
      (l10n.proUnlockedNoAds, l10n.proBenefitNoAds),
      (l10n.proUnlockedNoFooter, l10n.proBenefitNoFooter),
      (l10n.proUnlockedUnlimited, l10n.proBenefitUnlimited),
    ];
    return PopScope(
      // Back goes home, not to the paywall that was just completed.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.goNamed(RouteNames.home);
      },
      child: Scaffold(
        backgroundColor: colors.background,
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pagePadding,
              AppSpacing.sm,
              AppSpacing.pagePadding,
              AppSpacing.md,
            ),
            child: AppButton(
              label: l10n.proWelcomeDone,
              expand: true,
              onPressed: () => context.goNamed(RouteNames.home),
            ),
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pagePadding,
              AppSpacing.lg,
              AppSpacing.pagePadding,
              AppSpacing.xxl,
            ),
            children: [
              const _Hero(),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.proUnlockedTitle.toUpperCase(),
                style: context.textStyles.labelMedium?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ProBenefitList(benefits: benefits),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.proManage,
                textAlign: TextAlign.center,
                style: context.textStyles.bodySmall?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              Center(
                child: AppButton(
                  label: l10n.proManageAction,
                  icon: AppIcons.openExternal,
                  variant: AppButtonVariant.text,
                  onPressed: () => UrlLaunchService.openUrl(
                    AppConstants.manageSubscriptionUrl,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The welcome card: Pro designs fanned out over a deep panel with a gold
/// edge, then the thank-you and the QuickBill PRO mark. It pops in once.
class _Hero extends StatelessWidget {
  const _Hero();

  static const double _artHeight = 150;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.94, end: 1),
      duration: AppDurations.slow,
      curve: Curves.easeOutBack,
      builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          borderRadius: AppRadius.card,
          border: Border.all(color: colors.warning.withValues(alpha: 0.6)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colors.warning.withValues(alpha: 0.22), colors.panel],
            stops: const [0, 0.6],
          ),
          color: colors.panel,
        ),
        child: Column(
          spacing: AppSpacing.sm,
          children: [
            const SizedBox(height: _artHeight, child: TemplatesSlideArt()),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.proWelcomeTitle,
              style: context.textStyles.bodyLarge?.copyWith(
                color: colors.onPanelMuted,
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.sm,
              children: [
                Text(
                  AppConstants.appName,
                  style: context.textStyles.headlineSmall?.copyWith(
                    color: colors.onPanel,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const ProBadge(),
              ],
            ),
            Text(
              l10n.proWelcomeLead,
              textAlign: TextAlign.center,
              style: context.textStyles.bodyMedium?.copyWith(
                color: colors.onPanelMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
