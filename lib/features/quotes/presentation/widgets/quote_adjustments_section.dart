import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/inputs/amount_field.dart';
import '../../../../core/widgets/inputs/app_switch.dart';
import '../../../../core/widgets/inputs/percent_field.dart';
import '../../../invoices/presentation/widgets/discount_input.dart';
import '../../domain/models/quote.dart';
import '../view_models/quote_editor_view_model.dart';

class QuoteAdjustmentsSection extends StatelessWidget {
  const QuoteAdjustmentsSection({
    required this.draft,
    required this.vm,
    super.key,
  });

  final Quote draft;
  final QuoteEditorViewModel vm;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        DiscountInput(
          key: ValueKey(draft.currencyCode),
          label: l10n.fieldDiscount,
          currencyCode: draft.currencyCode,
          discount: draft.discount,
          onChanged: vm.setDiscount,
        ),
        PercentField(
          label: l10n.fieldTaxRate,
          hint: l10n.fieldDefaultTaxHint,
          basisPoints: draft.taxRateBasisPoints,
          onChanged: vm.setTaxRate,
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.taxInclusiveLabel),
          onTap: () => vm.setTaxInclusive(inclusive: !draft.taxInclusive),
          trailing: AppSwitch(
            value: draft.taxInclusive,
            onChanged: (v) => vm.setTaxInclusive(inclusive: v),
          ),
        ),
        AmountField(
          key: ValueKey('shipping-${draft.currencyCode}'),
          label: l10n.fieldShipping,
          currencyCode: draft.currencyCode,
          initialMinor: draft.shippingMinor == 0 ? null : draft.shippingMinor,
          onChanged: vm.setShipping,
        ),
      ],
    );
  }
}
