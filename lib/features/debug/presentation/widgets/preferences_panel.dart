import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../settings/domain/models/app_language.dart';
import '../../../settings/domain/models/app_theme_preference.dart';

/// Language and theme switches.
class PreferencesPanel extends StatelessWidget {
  const PreferencesPanel({
    required this.language,
    required this.theme,
    required this.onLanguageChanged,
    required this.onThemeChanged,
    super.key,
  });

  final AppLanguage language;
  final AppThemePreference theme;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final ValueChanged<AppThemePreference> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<AppLanguage>(
          segments: [
            ButtonSegment(
              value: AppLanguage.en,
              label: Text(l10n.languageEnglish),
            ),
            ButtonSegment(
              value: AppLanguage.bn,
              label: Text(l10n.languageBangla),
            ),
          ],
          selected: {language},
          onSelectionChanged: (s) => onLanguageChanged(s.first),
        ),
        const SizedBox(height: AppSpacing.md),
        SegmentedButton<AppThemePreference>(
          segments: [
            ButtonSegment(
              value: AppThemePreference.system,
              icon: const Icon(AppIcons.themeSystem),
              label: Text(l10n.themeSystem),
            ),
            ButtonSegment(
              value: AppThemePreference.light,
              icon: const Icon(AppIcons.themeLight),
              label: Text(l10n.themeLight),
            ),
            ButtonSegment(
              value: AppThemePreference.dark,
              icon: const Icon(AppIcons.themeDark),
              label: Text(l10n.themeDark),
            ),
          ],
          selected: {theme},
          onSelectionChanged: (s) => onThemeChanged(s.first),
        ),
      ],
    );
  }
}
