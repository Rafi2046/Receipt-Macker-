import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/inputs/amount_field.dart';
import '../../../../core/widgets/inputs/dropdown_field.dart';
import '../../../../core/widgets/inputs/field_block.dart';
import '../../../../core/widgets/inputs/percent_field.dart';
import '../../domain/models/discount.dart';
import '../../domain/models/discount_type.dart';

/// "Discount type" (none, percentage, flat amount) and, once a type is
/// chosen, its value. Reports null for no discount.
class LineDiscountBlock extends StatelessWidget {
  const LineDiscountBlock({
    required this.currencyCode,
    required this.discount,
    required this.onChanged,
    this.errorText,
    super.key,
  });

  final String currencyCode;
  final Discount? discount;
  final ValueChanged<Discount?> onChanged;
  final String? errorText;

  /// Dropdown values: 0 is "none", then the types in order.
  static int _index(DiscountType? type) =>
      type == null ? 0 : DiscountType.values.indexOf(type) + 1;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = discount;
    final type = current?.type;
    final initial = current == null || current.value == 0
        ? null
        : current.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.lg,
      children: [
        FieldBlock(
          label: l10n.fieldDiscountType,
          child: DropdownField<int>(
            label: '',
            value: _index(type),
            options: [
              (0, l10n.discountNone),
              (_index(DiscountType.percent), l10n.discountPercentage),
              (_index(DiscountType.flat), l10n.discountFlatAmount),
            ],
            onChanged: (i) {
              if (i == _index(type)) return;
              onChanged(
                i == 0
                    ? null
                    : Discount(type: DiscountType.values[i - 1], value: 0),
              );
            },
          ),
        ),
        if (type == DiscountType.percent)
          FieldBlock(
            label: l10n.fieldDiscount,
            child: PercentField(
              key: const ValueKey(DiscountType.percent),
              label: '',
              basisPoints: initial,
              errorText: errorText,
              onChanged: (v) => onChanged(
                Discount(type: DiscountType.percent, value: v ?? 0),
              ),
            ),
          ),
        if (type == DiscountType.flat)
          FieldBlock(
            label: l10n.fieldDiscount,
            child: AmountField(
              key: const ValueKey(DiscountType.flat),
              label: '',
              currencyCode: currencyCode,
              initialMinor: initial,
              errorText: errorText,
              onChanged: (v) =>
                  onChanged(Discount(type: DiscountType.flat, value: v ?? 0)),
            ),
          ),
      ],
    );
  }
}
