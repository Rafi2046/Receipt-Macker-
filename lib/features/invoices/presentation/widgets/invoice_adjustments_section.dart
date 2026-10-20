import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/extensions/validation_message_extension.dart';
import '../../../../core/widgets/inputs/amount_field.dart';
import '../../../../core/widgets/inputs/percent_field.dart';
import '../../domain/models/invoice_field.dart';
import '../view_models/invoice_editor_state.dart';
import '../view_models/invoice_editor_view_model.dart';
import 'discount_input.dart';

/// Invoice discount, tax rate (inclusive or not) and shipping.
class InvoiceAdjustmentsSection extends StatelessWidget {
  const InvoiceAdjustmentsSection({
    required this.form,
    required this.vm,
    super.key,
  });

  final InvoiceEditorState form;
  final InvoiceEditorViewModel vm;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final draft = form.draft;
    String? error(InvoiceField f) => l10n.validationMessage(form.errorFor(f));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        DiscountInput(
          // Rebuild the field when the currency changes the amount's scale.
          key: ValueKey(draft.currencyCode),
          label: l10n.fieldDiscount,
          currencyCode: draft.currencyCode,
          discount: draft.discount,
          errorText: error(InvoiceField.discount),
          onChanged: vm.setDiscount,
        ),
        PercentField(
          label: l10n.fieldTaxRate,
          hint: l10n.fieldDefaultTaxHint,
          basisPoints: draft.taxRateBasisPoints,
          errorText: error(InvoiceField.tax),
          onChanged: vm.setTaxRate,
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.taxInclusiveLabel),
          value: draft.taxInclusive,
          onChanged: (v) => vm.setTaxInclusive(inclusive: v),
        ),
        AmountField(
          key: ValueKey('shipping-${draft.currencyCode}'),
          label: l10n.fieldShipping,
          currencyCode: draft.currencyCode,
          initialMinor: draft.shippingMinor == 0 ? null : draft.shippingMinor,
          errorText: error(InvoiceField.total),
          onChanged: vm.setShipping,
        ),
      ],
    );
  }
}
