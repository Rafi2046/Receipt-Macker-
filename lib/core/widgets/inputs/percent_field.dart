import 'package:flutter/material.dart';

import '../../utils/extensions/l10n_extension.dart';
import '../../utils/formatters.dart';
import 'decimal_field.dart';

/// Percentage input (tax, discount). Reports basis points (1500 = 15%),
/// null when empty; up to two decimals. Follows [basisPoints] when it is
/// changed from outside. Range checks live in the ViewModel.
class PercentField extends StatelessWidget {
  const PercentField({
    required this.label,
    required this.onChanged,
    this.basisPoints,
    this.hint,
    this.errorText,
    super.key,
  });

  final String label;
  final ValueChanged<int?> onChanged;
  final int? basisPoints;
  final String? hint;
  final String? errorText;

  @override
  Widget build(BuildContext context) => DecimalField(
    label: label,
    decimalDigits: AppFormatters.percentDecimalDigits,
    value: basisPoints,
    hint: hint,
    suffixText: context.l10n.percentSymbol,
    errorText: errorText,
    onChanged: onChanged,
  );
}
