import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/inputs/amount_field.dart';
import '../../../../core/widgets/inputs/percent_field.dart';
import '../../domain/models/discount.dart';
import '../../domain/models/discount_type.dart';

/// No discount, a percentage, or a fixed amount in [currencyCode].
/// Reports null for no discount.
class DiscountInput extends StatelessWidget {
  const DiscountInput({
    required this.label,
    required this.currencyCode,
    required this.discount,
    required this.onChanged,
    this.errorText,
    super.key,
  });

  final String label;
  final String currencyCode;
  final Discount? discount;
  final ValueChanged<Discount?> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = discount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        Text(label, style: context.textStyles.labelLarge),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            _DiscountChip(
              label: l10n.discountNone,
              selected: current == null,
              onTap: () => onChanged(null),
            ),
            _DiscountChip(
              label: l10n.percentSymbol,
              selected: current?.type == DiscountType.percent,
              onTap: () => onChanged(
                const Discount(type: DiscountType.percent, value: 0),
              ),
            ),
            _DiscountChip(
              label: l10n.discountFlat,
              selected: current?.type == DiscountType.flat,
              onTap: () =>
                  onChanged(const Discount(type: DiscountType.flat, value: 0)),
            ),
          ],
        ),
        switch (current?.type) {
          null => const SizedBox.shrink(),
          DiscountType.percent => PercentField(
            key: const ValueKey(DiscountType.percent),
            label: label,
            basisPoints: _initial(current),
            errorText: errorText,
            onChanged: (v) =>
                onChanged(Discount(type: DiscountType.percent, value: v ?? 0)),
          ),
          DiscountType.flat => AmountField(
            key: const ValueKey(DiscountType.flat),
            label: label,
            currencyCode: currencyCode,
            initialMinor: _initial(current),
            errorText: errorText,
            onChanged: (v) =>
                onChanged(Discount(type: DiscountType.flat, value: v ?? 0)),
          ),
        },
      ],
    );
  }

  /// A just-chosen type starts empty rather than showing 0.
  static int? _initial(Discount? d) =>
      d == null || d.value == 0 ? null : d.value;
}

class _DiscountChip extends StatelessWidget {
  const _DiscountChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? colors.primary.withValues(alpha: 0.12)
              : colors.surfaceAlt,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? colors.primary : colors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: context.textStyles.labelMedium?.copyWith(
            color: selected ? colors.primary : colors.textSecondary,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
