import 'package:flutter/services.dart';

import '../../utils/money_input_parser.dart';

/// Lets through only text that [MoneyInputParser] can parse: digits (Latin or
/// Bangla, converted to Latin), grouping commas, one `.` and at most
/// [decimalDigits] decimals.
class AmountInputFormatter extends TextInputFormatter {
  AmountInputFormatter({required this.decimalDigits});

  final int decimalDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = MoneyInputParser.normalize(newValue.text);
    if (text.isEmpty) return newValue.copyWith(text: text);
    final valid = text == '.'
        ? decimalDigits > 0
        : MoneyInputParser.parse(text, decimalDigits: decimalDigits) != null;
    return valid ? newValue.copyWith(text: text) : oldValue;
  }
}
