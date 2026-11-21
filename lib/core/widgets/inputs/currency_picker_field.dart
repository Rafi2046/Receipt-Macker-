import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_currencies.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_spacing.dart';
import '../../utils/formatters.dart';
import 'currency_picker_sheet.dart';
import 'reveal_on_error.dart';

/// Tappable currency field: flag, code, symbol — opens a premium picker.
class CurrencyPickerField extends StatelessWidget {
  const CurrencyPickerField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.codes = AppCurrencies.common,
    this.errorText,
    super.key,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final List<String> codes;
  final String? errorText;

  Future<void> _open(BuildContext context) async {
    final picked = await showCurrencyPicker(
      context: context,
      selectedCode: value,
      codes: codes,
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final symbol = AppFormatters.currencySymbol(value);
    return RevealOnError(
      errorText: errorText,
      child: InkWell(
        onTap: () => _open(context),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            errorText: errorText,
            suffixIcon: Icon(AppIcons.dropdown, color: colors.textSecondary),
          ),
          child: Row(
            children: [
              Text(
                AppCurrencies.flag(value),
                // Tight line height, so the flag does not make the field
                // taller than the ones beside it.
                style: const TextStyle(fontSize: 22, height: 1),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  '$value  $symbol',
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.bodyLarge?.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
