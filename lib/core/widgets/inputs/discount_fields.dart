import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import '../../utils/extensions/l10n_extension.dart';
import 'amount_field.dart';
import 'dropdown_field.dart';
import 'field_block.dart';
import 'percent_field.dart';

/// The kinds of discount [DiscountFields] offers.
enum DiscountKind { none, percent, flat }

/// "Discount type" (none, percentage, flat amount) and, once a type is
/// chosen, its value: basis points for a percentage, minor units of
/// [currencyCode] for a flat amount. A newly chosen type starts at 0.
class DiscountFields extends StatelessWidget {
  const DiscountFields({
    required this.kind,
    required this.value,
    required this.currencyCode,
    required this.onChanged,
    this.errorText,
    super.key,
  });

  final DiscountKind kind;
  final int value;
  final String currencyCode;
  final void Function(DiscountKind kind, int value) onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final initial = value == 0 ? null : value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.lg,
      children: [
        FieldBlock(
          label: l10n.fieldDiscountType,
          child: DropdownField<DiscountKind>(
            label: '',
            value: kind,
            options: [
              (DiscountKind.none, l10n.discountNone),
              (DiscountKind.percent, l10n.discountPercentage),
              (DiscountKind.flat, l10n.discountFlatAmount),
            ],
            onChanged: (k) {
              if (k != kind) onChanged(k, 0);
            },
          ),
        ),
        if (kind == DiscountKind.percent)
          FieldBlock(
            label: l10n.fieldDiscount,
            child: PercentField(
              key: const ValueKey(DiscountKind.percent),
              label: '',
              basisPoints: initial,
              errorText: errorText,
              onChanged: (v) => onChanged(DiscountKind.percent, v ?? 0),
            ),
          ),
        if (kind == DiscountKind.flat)
          FieldBlock(
            label: l10n.fieldDiscount,
            child: AmountField(
              key: ValueKey('flat-$currencyCode'),
              label: '',
              currencyCode: currencyCode,
              initialMinor: initial,
              errorText: errorText,
              onChanged: (v) => onChanged(DiscountKind.flat, v ?? 0),
            ),
          ),
      ],
    );
  }
}
