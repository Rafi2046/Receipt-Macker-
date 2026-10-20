import 'package:flutter/material.dart';

import '../../utils/money_input_parser.dart';
import 'amount_input_formatter.dart';
import 'app_text_field.dart';

/// Number input with up to [decimalDigits] decimals (quantity, percent).
/// Reports the value scaled to an integer (1.5 with 3 digits is 1500), null
/// when empty. Accepts Bangla digits. Never goes through `double`.
class DecimalField extends StatelessWidget {
  const DecimalField({
    required this.label,
    required this.decimalDigits,
    required this.onChanged,
    this.initialScaled,
    this.hint,
    this.suffixText,
    this.errorText,
    super.key,
  });

  final String label;
  final int decimalDigits;
  final ValueChanged<int?> onChanged;
  final int? initialScaled;
  final String? hint;
  final String? suffixText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final initial = initialScaled;
    return AppTextField(
      label: label,
      hint: hint,
      initialValue: initial == null
          ? null
          : MoneyInputParser.formatCompact(
              initial,
              decimalDigits: decimalDigits,
            ),
      errorText: errorText,
      suffixText: suffixText,
      keyboardType: TextInputType.numberWithOptions(decimal: decimalDigits > 0),
      inputFormatters: [AmountInputFormatter(decimalDigits: decimalDigits)],
      onChanged: (text) =>
          onChanged(MoneyInputParser.parse(text, decimalDigits: decimalDigits)),
    );
  }
}
