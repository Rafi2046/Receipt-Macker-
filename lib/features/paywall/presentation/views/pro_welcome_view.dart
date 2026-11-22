import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/purchases/free_plan.dart';
import '../../../../core/services/url_launch_service.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../widgets/pro_badge.dart';

/// Shown right after a purchase: a welcome, what Pro unlocked, and a link
/// to manage the subscription in Google Play (CLAUDE §9.1).
class ProWelcomeView extends StatelessWidget {
  const ProWelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final unlocked = <(IconData, String)>[
      (
        AppIcons.template,
        l10n.proUnlockedTemplates(format.integer(FreePlan.templateCount)),
      ),
      (AppIcons.palette, l10n.proUnlockedColors),
      (AppIcons.noAds, l10n.proUnlockedNoAds),
      (AppIcons.noFooter, l10n.proUnlockedNoFooter),
      (AppIcons.unlimited, l10n.proUnlockedUnlimited),
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
              AppSpacing.xxxl,
              AppSpacing.pagePadding,
              AppSpacing.xxl,
            ),
            children: [
              const Center(child: _Burst()),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.proWelcomeTitle,
                textAlign: TextAlign.center,
                style: context.textStyles.bodyLarge?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: AppSpacing.sm,
                children: [
                  Text(
                    AppConstants.appName,
                    style: context.textStyles.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const ProBadge(),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                l10n.proUnlockedTitle.toUpperCase(),
                style: context.textStyles.labelMedium?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Column(
                  spacing: AppSpacing.md,
                  children: [
                    for (final (icon, text) in unlocked)
                      Row(
                        spacing: AppSpacing.md,
                        children: [
                          Icon(
                            icon,
                            size: AppSizes.iconRow,
                            color: colors.textPrimary,
                          ),
                          Expanded(
                            child: Text(
                              text,
                              style: context.textStyles.bodyLarge,
                            ),
                          ),
                          Icon(
                            AppIcons.check,
                            size: AppSizes.iconRow,
                            color: colors.success,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
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

/// The celebration mark: a gold disc that pops in once.
class _Burst extends StatelessWidget {
  const _Burst();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1),
      duration: AppDurations.slow,
      curve: Curves.easeOutBack,
      builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.warning.withValues(alpha: 0.16),
          border: Border.all(color: colors.warning.withValues(alpha: 0.5)),
        ),
        child: Icon(
          AppIcons.welcome,
          size: AppSizes.iconXl,
          color: colors.warning,
        ),
      ),
    );
  }
}
