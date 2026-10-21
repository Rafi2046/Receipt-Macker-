import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../../core/utils/formatters.dart';
import '../studio_money.dart';
import 'studio_choice_row.dart';
import 'studio_settings_field.dart';
import 'studio_settings_heading.dart';
import 'studio_signature_sample.dart';

const List<int> _dueDays = [0, 7, 15, 30];
const List<String> _currencies = ['BDT', 'USD', 'EUR'];

/// Payment details, tax, signature, due terms, and currency.
class StudioSettingsPayments extends StatelessWidget {
  const StudioSettingsPayments({
    required this.payment,
    required this.tax,
    required this.terms,
    required this.inclusive,
    required this.due,
    required this.currency,
    required this.onInclusive,
    required this.onDue,
    required this.onCurrency,
    super.key,
  });

  final TextEditingController payment;
  final TextEditingController tax;
  final TextEditingController terms;
  final bool inclusive;
  final int due;
  final int currency;
  final ValueChanged<int> onInclusive;
  final ValueChanged<int> onDue;
  final ValueChanged<int> onCurrency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StudioSettingsField(
          label: l10n.studioPayDetails,
          controller: payment,
          maxLines: 3,
          keyboardType: TextInputType.multiline,
        ),
        const SizedBox(height: AppSpacing.lg),
        StudioSettingsField(
          label: l10n.fieldTaxRate,
          controller: tax,
          keyboardType: TextInputType.number,
          suffix: l10n.percentSymbol,
        ),
        const SizedBox(height: AppSpacing.sm),
        StudioChoiceRow(
          labels: [l10n.studioTaxExclusive, l10n.studioTaxInclusive],
          selected: inclusive ? 1 : 0,
          onSelected: onInclusive,
        ),
        const SizedBox(height: AppSpacing.lg),
        const StudioSignatureSample(),
        const SizedBox(height: AppSpacing.lg),
        StudioSettingsHeading(l10n.fieldDueTerm),
        StudioChoiceRow(
          labels: _dueLabels(context),
          selected: due,
          onSelected: onDue,
        ),
        const SizedBox(height: AppSpacing.lg),
        StudioSettingsField(
          label: l10n.fieldTerms,
          controller: terms,
          maxLines: 3,
          keyboardType: TextInputType.multiline,
        ),
        const SizedBox(height: AppSpacing.lg),
        StudioSettingsHeading(l10n.studioDefaultCurrency),
        StudioChoiceRow(
          labels: [
            for (final code in _currencies)
              '$code ${AppFormatters.currencySymbol(code)}',
          ],
          selected: currency,
          onSelected: onCurrency,
        ),
      ],
    );
  }
}

List<String> _dueLabels(BuildContext context) {
  final l10n = context.l10n;
  final format = studioFormat(context);
  return [
    for (final days in _dueDays)
      days == 0 ? l10n.dueOnReceipt : l10n.dueInDays(format.integer(days)),
  ];
}
