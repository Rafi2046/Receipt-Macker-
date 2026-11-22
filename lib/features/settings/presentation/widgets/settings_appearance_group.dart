import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/inputs/choice_sheet.dart';
import '../../../../core/widgets/layout/editor_row.dart';
import '../../domain/models/app_language.dart';
import '../../domain/models/app_theme_preference.dart';
import '../view_models/app_settings_view_model.dart';
import 'settings_group.dart';

/// App language and theme, each a row that opens a choice sheet.
class SettingsAppearanceGroup extends ConsumerWidget {
  const SettingsAppearanceGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(appSettingsViewModelProvider);
    final vm = ref.read(appSettingsViewModelProvider.notifier);
    final languages = <Choice<AppLanguage>>[
      (value: AppLanguage.en, label: l10n.languageEnglish, icon: null),
      (value: AppLanguage.bn, label: l10n.languageBangla, icon: null),
    ];
    final themes = <Choice<AppThemePreference>>[
      (
        value: AppThemePreference.system,
        label: l10n.settingsThemeSystem,
        icon: AppIcons.themeSystem,
      ),
      (
        value: AppThemePreference.light,
        label: l10n.settingsThemeLight,
        icon: AppIcons.themeLight,
      ),
      (
        value: AppThemePreference.dark,
        label: l10n.settingsThemeDark,
        icon: AppIcons.themeDark,
      ),
    ];
    String labelOf<T>(List<Choice<T>> list, T value) =>
        list.firstWhere((c) => c.value == value).label;

    return SettingsGroup(
      title: l10n.settingsAppearance,
      children: [
        EditorRow(
          icon: AppIcons.setLanguage,
          iconSize: AppSizes.iconRow,
          title: l10n.settingsLanguage,
          value: labelOf(languages, state.language),
          onTap: () async {
            final picked = await ChoiceSheet.show(
              context,
              title: l10n.settingsLanguage,
              options: languages,
              selected: state.language,
            );
            if (picked != null) await vm.setLanguage(picked);
          },
        ),
        EditorRow(
          icon: switch (state.theme) {
            AppThemePreference.light => AppIcons.themeLight,
            AppThemePreference.dark => AppIcons.themeDark,
            AppThemePreference.system => AppIcons.themeSystem,
          },
          iconSize: AppSizes.iconRow,
          title: l10n.settingsTheme,
          value: labelOf(themes, state.theme),
          onTap: () async {
            final picked = await ChoiceSheet.show(
              context,
              title: l10n.settingsTheme,
              options: themes,
              selected: state.theme,
            );
            if (picked != null) await vm.setTheme(picked);
          },
        ),
      ],
    );
  }
}
