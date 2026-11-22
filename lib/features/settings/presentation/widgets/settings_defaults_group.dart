import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_currencies.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/inputs/app_switch.dart';
import '../../../../core/widgets/inputs/choice_sheet.dart';
import '../../../../core/widgets/inputs/currency_picker_sheet.dart';
import '../../../../core/widgets/layout/editor_row.dart';
import '../view_models/app_settings_view_model.dart';
import 'settings_group.dart';
import 'tax_rate_sheet.dart';

/// Defaults for new invoices: currency, due date, tax rate and whether
/// prices include tax.
class SettingsDefaultsGroup extends ConsumerWidget {
  const SettingsDefaultsGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(appSettingsViewModelProvider);
    final vm = ref.read(appSettingsViewModelProvider.notifier);
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    String dueLabel(int days) =>
        days == 0 ? l10n.dueOnReceipt : l10n.dueInDays(format.integer(days));
    final tax = state.defaultTaxRateBasisPoints;
    final currency = state.defaultCurrency;

    return SettingsGroup(
      title: l10n.settingsDefaults,
      children: [
        EditorRow(
          icon: AppIcons.setCurrency,
          iconSize: AppSizes.iconRow,
          title: l10n.studioDefaultCurrency,
          value:
              '${AppCurrencies.flag(currency)} $currency '
              '${AppFormatters.currencySymbol(currency)}',
          onTap: () async {
            final picked = await showCurrencyPicker(
              context: context,
              selectedCode: currency,
              codes: AppCurrencies.common,
            );
            if (picked != null) await vm.setDefaultCurrency(picked);
          },
        ),
        EditorRow(
          icon: AppIcons.setDueDate,
          iconSize: AppSizes.iconRow,
          title: l10n.settingsDueDays,
          value: dueLabel(state.defaultDueDays),
          onTap: () async {
            final picked = await ChoiceSheet.show(
              context,
              title: l10n.settingsDueDays,
              selected: state.defaultDueDays,
              options: [
                for (final days in AppConstants.dueDayPresets)
                  (value: days, label: dueLabel(days), icon: null),
              ],
            );
            if (picked != null) await vm.setDefaultDueDays(picked);
          },
        ),
        EditorRow(
          icon: AppIcons.setTax,
          iconSize: AppSizes.iconRow,
          title: l10n.settingsTaxRate,
          value: tax == null || tax == 0
              ? l10n.settingsTaxNone
              : format.percent(tax),
          onTap: () async {
            final picked = await TaxRateSheet.show(context, basisPoints: tax);
            if (picked != null) {
              await vm.setDefaultTaxRateBasisPoints(picked.basisPoints);
            }
          },
        ),
        EditorRow(
          icon: AppIcons.setTaxInclusive,
          iconSize: AppSizes.iconRow,
          title: l10n.settingsTaxInclusive,
          subtitle: l10n.settingsTaxInclusiveHint,
          onTap: () =>
              vm.setDefaultTaxInclusive(value: !state.defaultTaxInclusive),
          trailing: AppSwitch(
            value: state.defaultTaxInclusive,
            onChanged: (v) => vm.setDefaultTaxInclusive(value: v),
          ),
        ),
      ],
    );
  }
}
