import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../settings/domain/models/app_language.dart';
import '../../../settings/presentation/view_models/app_settings_view_model.dart';
import 'language_option_card.dart';

/// Language picker inside the white sheet. Title lives in the coral hero.
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
        Text(
          l10n.onboardingChooseLanguage,
          style: context.textStyles.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.onboardingWelcomeBody,
          style: context.textStyles.bodyMedium?.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
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

/// Logo + headline on the coral field above the sheet.
class WelcomeHero extends StatelessWidget {
  const WelcomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.appTitle,
          style: context.textStyles.titleMedium?.copyWith(
            color: colors.onPrimary.withValues(alpha: 0.85),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.onboardingWelcomeTitle,
          style: context.textStyles.headlineSmall?.copyWith(
            color: colors.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
