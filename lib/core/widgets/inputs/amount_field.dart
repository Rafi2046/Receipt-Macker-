import 'package:flutter/material.dart';

import '../../utils/formatters.dart';
import '../../utils/money_input_parser.dart';
import 'amount_input_formatter.dart';
import 'app_text_field.dart';

/// Money input. Reports integer minor units (null when empty), never a double.
/// Decimals follow the currency (2 for BDT, 0 for JPY).
class AmountField extends StatefulWidget {
  const AmountField({
    required this.label,
    required this.currencyCode,
    required this.onChanged,
    this.initialMinor,
    this.errorText,
    this.enabled = true,
    super.key,
  });

  final String label;
  final String currencyCode;
  final ValueChanged<int?> onChanged;
  final int? initialMinor;
  final String? errorText;
  final bool enabled;

  @override
  State<AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<AmountField> {
  late final TextEditingController _controller;

  int get _decimals => AppFormatters.currencyDecimalDigits(widget.currencyCode);

  @override
  void initState() {
    super.initState();
    final initial = widget.initialMinor;
    _controller = TextEditingController(
      text: initial == null
          ? ''
          : MoneyInputParser.format(initial, decimalDigits: _decimals),
    );
  }

  @override
  void didUpdateWidget(AmountField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currencyCode == widget.currencyCode) return;
    // Different decimals: drop extra fraction digits and report the new value.
    _controller.text = MoneyInputParser.clampFraction(
      _controller.text,
      decimalDigits: _decimals,
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _emit(_controller.text),
    );
  }

  void _emit(String text) =>
      widget.onChanged(MoneyInputParser.parse(text, decimalDigits: _decimals));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      key: ValueKey(_decimals),
      controller: _controller,
      label: widget.label,
      errorText: widget.errorText,
      enabled: widget.enabled,
      prefixText: AppFormatters.currencySymbol(widget.currencyCode),
      keyboardType: TextInputType.numberWithOptions(decimal: _decimals > 0),
      inputFormatters: [AmountInputFormatter(decimalDigits: _decimals)],
      onChanged: _emit,
    );
  }
}
