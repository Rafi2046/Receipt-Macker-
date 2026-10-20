import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/inputs/amount_field.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/inputs/date_field.dart';
import '../../../../core/widgets/inputs/dropdown_field.dart';
import '../view_models/widget_gallery_state.dart';

class GalleryInputsSection extends StatelessWidget {
  const GalleryInputsSection({
    required this.state,
    required this.currencies,
    required this.onNameChanged,
    required this.onCurrencyChanged,
    required this.onAmountChanged,
    required this.onDueDateChanged,
    super.key,
  });

  final WidgetGalleryState state;
  final List<String> currencies;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onCurrencyChanged;
  final ValueChanged<int?> onAmountChanged;
  final ValueChanged<DateTime> onDueDateChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final minor = state.amountMinor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        AppTextField(
          label: l10n.galleryClientName,
          hint: l10n.galleryClientHint,
          prefixIcon: AppIcons.client,
          textCapitalization: TextCapitalization.words,
          errorText: state.isNameMissing ? l10n.galleryNameError : null,
          onChanged: onNameChanged,
        ),
        DropdownField<String>(
          label: l10n.galleryCurrency,
          value: state.currencyCode,
          options: [
            for (final c in currencies)
              (c, '$c  ${AppFormatters.currencySymbol(c)}'),
          ],
          onChanged: onCurrencyChanged,
        ),
        AmountField(
          label: l10n.galleryAmount,
          currencyCode: state.currencyCode,
          onChanged: onAmountChanged,
        ),
        Text(
          minor == null
              ? l10n.galleryAmountEmpty
              : l10n.galleryStoredValue('$minor'),
          style: context.textStyles.bodySmall?.copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
        DateField(
          label: l10n.galleryDueDate,
          value: state.dueDate,
          onChanged: onDueDateChanged,
        ),
      ],
    );
  }
}
