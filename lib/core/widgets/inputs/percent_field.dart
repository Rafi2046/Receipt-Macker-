import 'package:flutter/material.dart';

import '../../utils/extensions/l10n_extension.dart';
import '../../utils/formatters.dart';
import '../../utils/money_input_parser.dart';
import 'amount_input_formatter.dart';
import 'app_text_field.dart';

/// Percentage input (tax, discount). Reports basis points (1500 = 15%),
/// null when empty; up to two decimals. Range checks live in the ViewModel.
class PercentField extends StatelessWidget {
  const PercentField({
    required this.label,
    required this.onChanged,
    this.initialBasisPoints,
    this.hint,
    this.errorText,
    super.key,
  });

  final String label;
  final ValueChanged<int?> onChanged;
  final int? initialBasisPoints;
  final String? hint;
  final String? errorText;

  static const int _decimals = AppFormatters.percentDecimalDigits;

  @override
  Widget build(BuildContext context) {
    final initial = initialBasisPoints;
    return AppTextField(
      label: label,
      hint: hint,
      initialValue: initial == null
          ? null
          : MoneyInputParser.formatCompact(initial, decimalDigits: _decimals),
      errorText: errorText,
      suffixText: context.l10n.percentSymbol,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [AmountInputFormatter(decimalDigits: _decimals)],
      onChanged: (text) =>
          onChanged(MoneyInputParser.parse(text, decimalDigits: _decimals)),
    );
  }
}
