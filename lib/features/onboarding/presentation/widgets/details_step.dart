import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/inputs/currency_picker_field.dart';
import '../../../business_profile/business_profile.dart';

/// Step 2: business name (required), contact details and default currency.
/// Title sits in the coral hero; this sheet is only the fields.
class DetailsStep extends StatelessWidget {
  const DetailsStep({
    required this.form,
    required this.currencyCode,
    required this.onCurrencyChanged,
    super.key,
  });

  final ProfileFormState form;
  final String currencyCode;
  final ValueChanged<String> onCurrencyChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xxl,
        AppSpacing.xl,
        AppSpacing.lg,
      ),
      children: [
        ProfileDetailsFields(form: form),
        const SizedBox(height: AppSpacing.md),
        CurrencyPickerField(
          label: l10n.fieldDefaultCurrency,
          value: currencyCode,
          onChanged: onCurrencyChanged,
        ),
      ],
    );
  }
}
