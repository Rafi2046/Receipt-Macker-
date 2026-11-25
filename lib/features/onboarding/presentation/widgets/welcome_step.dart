import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../settings/domain/models/app_language.dart';
import '../../../settings/presentation/view_models/app_settings_view_model.dart';
import 'language_option_card.dart';

/// Language picker inside the surface sheet. Brand pitch lives in the hero.
class WelcomeStep extends ConsumerWidget {
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final language = ref.watch(
      appSettingsViewModelProvider.select((s) => s.language),
    );
    final settings = ref.read(appSettingsViewModelProvider.notifier);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xxl,
        AppSpacing.xl,
        AppSpacing.lg,
      ),
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.onboardingChooseLanguage,
            style: context.textStyles.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.onboardingWelcomeBody,
          style: context.textStyles.bodyLarge?.copyWith(
            color: colors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        LanguageOptionCard(
          label: l10n.languageBangla,
          selected: language == AppLanguage.bn,
          onTap: () => settings.setLanguage(AppLanguage.bn),
        ),
        const SizedBox(height: AppSpacing.md),
        LanguageOptionCard(
          label: l10n.languageEnglish,
          selected: language == AppLanguage.en,
          onTap: () => settings.setLanguage(AppLanguage.en),
        ),
      ],
    );
  }
}

/// Brand mark + pitch on the coral field above the sheet.
class WelcomeHero extends StatelessWidget {
  const WelcomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.md),
              child: Image.asset(
                AppImages.logo,
                width: AppSizes.iconXl,
                height: AppSizes.iconXl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Icon(
                  AppIcons.invoice,
                  size: AppSizes.iconXl,
                  color: colors.onPrimary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                l10n.appTitle,
                style: context.textStyles.headlineSmall?.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          l10n.onboardingWelcomeTitle,
          style: context.textStyles.headlineMedium?.copyWith(
            color: colors.onPrimary,
            fontWeight: FontWeight.w700,
            height: 1.15,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}
