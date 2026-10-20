import 'package:flutter/material.dart';

import '../../utils/money_input_parser.dart';
import 'amount_input_formatter.dart';
import 'app_text_field.dart';

/// Number input with up to [decimalDigits] decimals (quantity, percent).
/// Reports the value scaled to an integer (1.5 with 3 digits is 1500), null
/// when empty. Accepts Bangla digits. Never goes through `double`.
///
/// When [value] is changed from outside (e.g. a default tax filled in by
/// picking an item), the text follows; while the user types it is left
/// alone.
class DecimalField extends StatefulWidget {
  const DecimalField({
    required this.label,
    required this.decimalDigits,
    required this.onChanged,
    this.value,
    this.hint,
    this.suffixText,
    this.errorText,
    super.key,
  });

  final String label;
  final int decimalDigits;
  final ValueChanged<int?> onChanged;
  final int? value;
  final String? hint;
  final String? suffixText;
  final String? errorText;

  @override
  State<DecimalField> createState() => _DecimalFieldState();
}

class _DecimalFieldState extends State<DecimalField> {
  late final TextEditingController _controller = TextEditingController(
    text: _format(widget.value),
  );

  String _format(int? scaled) => scaled == null
      ? ''
      : MoneyInputParser.formatCompact(
          scaled,
          decimalDigits: widget.decimalDigits,
        );

  int? _parse(String text) =>
      MoneyInputParser.parse(text, decimalDigits: widget.decimalDigits);

  @override
  void didUpdateWidget(DecimalField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final value = widget.value;
    // Empty and zero count as the same number, so "0." is never wiped.
    final typed = _parse(_controller.text) ?? 0;
    if (value != oldWidget.value && (value ?? 0) != typed) {
      _controller.text = _format(value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: _controller,
      label: widget.label,
      hint: widget.hint,
      errorText: widget.errorText,
      suffixText: widget.suffixText,
      keyboardType: TextInputType.numberWithOptions(
        decimal: widget.decimalDigits > 0,
      ),
      inputFormatters: [
        AmountInputFormatter(decimalDigits: widget.decimalDigits),
      ],
      onChanged: (text) => widget.onChanged(_parse(text)),
    );
  }
}
