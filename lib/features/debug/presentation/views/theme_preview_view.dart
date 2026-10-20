import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../settings/presentation/view_models/app_settings_view_model.dart';
import '../widgets/color_swatch_grid.dart';
import '../widgets/numbers_sample.dart';
import '../widgets/palette_picker.dart';
import '../widgets/preferences_panel.dart';
import '../widgets/preview_section.dart';
import '../widgets/status_label_row.dart';
import '../widgets/typography_sample.dart';

/// M0 debug screen: palettes, tokens, light/dark and EN/BN at a glance.
class ThemePreviewView extends ConsumerWidget {
  const ThemePreviewView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(appSettingsViewModelProvider);
    final vm = ref.read(appSettingsViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.themePreviewTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            children: [
              PreferencesPanel(
                language: settings.language,
                theme: settings.theme,
                onLanguageChanged: vm.setLanguage,
                onThemeChanged: vm.setTheme,
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              PreviewSection(
                title: l10n.paletteSectionTitle,
                child: PalettePicker(
                  selected: settings.palette,
                  onSelected: vm.setPalette,
                ),
              ),
              PreviewSection(
                title: l10n.colorsSectionTitle,
                child: const ColorSwatchGrid(),
              ),
              PreviewSection(
                title: l10n.statusSectionTitle,
                child: const StatusLabelRow(),
              ),
              PreviewSection(
                title: l10n.typographySectionTitle,
                child: const TypographySample(),
              ),
              PreviewSection(
                title: l10n.numbersSectionTitle,
                child: const NumbersSample(),
              ),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(AppIcons.add),
                label: Text(l10n.sampleButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
