import 'package:flutter/material.dart';

import '../../../../core/constants/app_currencies.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/inputs/dropdown_field.dart';
import '../../../business_profile/business_profile.dart';
import 'step_intro.dart';

/// Step 2: business name (required), contact details and default currency.
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
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      children: [
        StepIntro(
          title: l10n.onboardingDetailsTitle,
          body: l10n.onboardingDetailsBody,
        ),
        const SizedBox(height: AppSpacing.xl),
        ProfileDetailsFields(form: form),
        const SizedBox(height: AppSpacing.md),
        DropdownField<String>(
          label: l10n.fieldDefaultCurrency,
          value: currencyCode,
          options: [
            for (final code in AppCurrencies.common)
              (code, '$code  ${AppFormatters.currencySymbol(code)}'),
          ],
          onChanged: onCurrencyChanged,
        ),
      ],
    );
  }
}
