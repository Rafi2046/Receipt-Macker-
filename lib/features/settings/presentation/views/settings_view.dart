import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_currencies.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/inputs/dropdown_field.dart';
import '../../../../core/widgets/inputs/percent_field.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../../../../core/widgets/layout/section_header.dart';
import '../../domain/models/app_language.dart';
import '../../domain/models/app_theme_preference.dart';
import '../view_models/app_settings_view_model.dart';

/// Full app settings screen: Language, Theme, Defaults, and Invoice Numbering.
class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  late final TextEditingController _prefixController;
  late final TextEditingController _seqController;

  @override
  void initState() {
    super.initState();
    _prefixController = TextEditingController();
    _seqController = TextEditingController();

    // Load numbering once the widget binds.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appSettingsViewModelProvider.notifier).loadNumbering().then((_) {
        if (!mounted) return;
        final state = ref.read(appSettingsViewModelProvider);
        _prefixController.text = state.invoicePrefix;
        _seqController.text = '${state.nextInvoiceSequence}';
      });
    });
  }

  @override
  void dispose() {
    _prefixController.dispose();
    _seqController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(appSettingsViewModelProvider);
    final vm = ref.read(appSettingsViewModelProvider.notifier);
    final format = AppFormatters(Localizations.localeOf(context).languageCode);

    ref.listen(appSettingsViewModelProvider.select((s) => s.numberingSaved), (
      _,
      saved,
    ) {
      if (saved) {
        AppSnackbar.show(
          context,
          l10n.settingsNumberingSaved,
          tone: AppSnackbarTone.success,
        );
        vm.clearFeedback();
      }
    });

    ref.listen(appSettingsViewModelProvider.select((s) => s.failure), (
      _,
      failure,
    ) {
      if (failure != null) {
        AppSnackbar.show(
          context,
          l10n.settingsNumberingInvalid,
          tone: AppSnackbarTone.error,
        );
        vm.clearFeedback();
      }
    });

    return AppScaffold(
      title: l10n.settingsTitle,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          AppSpacing.pagePadding,
          AppSpacing.pagePadding,
          AppSizes.fabClearance,
        ),
        children: [
          // 1. Appearance & Language
          SectionHeader(title: l10n.settingsAppearance),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsLanguage,
                  style: context.textStyles.titleSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
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
                  selected: {state.language},
                  onSelectionChanged: (selected) {
                    if (selected.isNotEmpty) {
                      vm.setLanguage(selected.first);
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.settingsTheme, style: context.textStyles.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                SegmentedButton<AppThemePreference>(
                  segments: [
                    ButtonSegment(
                      value: AppThemePreference.system,
                      label: Text(l10n.settingsThemeSystem),
                    ),
                    ButtonSegment(
                      value: AppThemePreference.light,
                      label: Text(l10n.settingsThemeLight),
                    ),
                    ButtonSegment(
                      value: AppThemePreference.dark,
                      label: Text(l10n.settingsThemeDark),
                    ),
                  ],
                  selected: {state.theme},
                  onSelectionChanged: (selected) {
                    if (selected.isNotEmpty) {
                      vm.setTheme(selected.first);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),

          // 2. Default Terms
          SectionHeader(title: l10n.settingsDefaults),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownField<String>(
                  label: l10n.studioDefaultCurrency,
                  value: state.defaultCurrency,
                  options: [
                    for (final code in AppCurrencies.common)
                      (code, '$code  ${AppFormatters.currencySymbol(code)}'),
                  ],
                  onChanged: vm.setDefaultCurrency,
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownField<int>(
                  label: l10n.settingsDueDays,
                  value: state.defaultDueDays,
                  options: [
                    for (final days in AppConstants.dueDayPresets)
                      (
                        days,
                        days == 0
                            ? l10n.dueOnReceipt
                            : l10n.dueInDays(format.integer(days)),
                      ),
                  ],
                  onChanged: vm.setDefaultDueDays,
                ),
                const SizedBox(height: AppSpacing.md),
                PercentField(
                  label: l10n.settingsTaxRate,
                  basisPoints: state.defaultTaxRateBasisPoints,
                  onChanged: vm.setDefaultTaxRateBasisPoints,
                ),
                const SizedBox(height: AppSpacing.sm),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.settingsTaxInclusive,
                    style: context.textStyles.bodyMedium,
                  ),
                  value: state.defaultTaxInclusive,
                  activeTrackColor: context.appColors.primary,
                  onChanged: (val) => vm.setDefaultTaxInclusive(value: val),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),

          // 3. Invoice Numbering
          SectionHeader(title: l10n.settingsNumbering),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  label: l10n.settingsPrefix,
                  controller: _prefixController,
                  textCapitalization: TextCapitalization.characters,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: l10n.settingsNextNumber,
                  controller: _seqController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.settingsNumberingHelp(
                    format.integer(state.highestInvoiceSequence),
                  ),
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.appColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: l10n.settingsSaveNumbering,
                  isLoading: state.isSaving,
                  onPressed: () {
                    final prefix = _prefixController.text;
                    final seq = int.tryParse(_seqController.text) ?? 1;
                    vm.updateNumbering(prefix: prefix, nextSequence: seq);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),

          // 4. Backup & Data
          SectionHeader(title: l10n.backupTitle),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            onTap: () => context.pushNamed(RouteNames.backup),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Icon(AppIcons.backup, color: context.appColors.primary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    l10n.backupTitle,
                    style: context.textStyles.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  AppIcons.chevronRight,
                  color: context.appColors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
