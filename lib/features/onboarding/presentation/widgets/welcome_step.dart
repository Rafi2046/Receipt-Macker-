import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../settings/domain/models/app_language.dart';
import '../../../settings/presentation/view_models/app_settings_view_model.dart';
import 'language_option_card.dart';

/// Step 1: what the app does, and the UI language (switches immediately).
class WelcomeStep extends ConsumerWidget {
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final language = ref.watch(
      appSettingsViewModelProvider.select((s) => s.language),
    );
    final settings = ref.read(appSettingsViewModelProvider.notifier);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Icon(
            AppIcons.invoice,
            size: AppSizes.iconXl,
            color: context.appColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.onboardingWelcomeTitle,
          style: context.textStyles.displaySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.onboardingWelcomeBody,
          style: context.textStyles.bodyLarge?.copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Text(
          l10n.onboardingChooseLanguage,
          style: context.textStyles.titleMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        LanguageOptionCard(
          label: l10n.languageBangla,
          selected: language == AppLanguage.bn,
          onTap: () => settings.setLanguage(AppLanguage.bn),
        ),
        const SizedBox(height: AppSpacing.sm),
        LanguageOptionCard(
          label: l10n.languageEnglish,
          selected: language == AppLanguage.en,
          onTap: () => settings.setLanguage(AppLanguage.en),
        ),
      ],
    );
  }
}
