import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/inputs/amount_field.dart';
import '../../../../core/widgets/inputs/decimal_field.dart';
import '../../../../core/widgets/inputs/field_block.dart';
import '../../domain/models/line_item.dart';
import '../view_models/invoice_editor_view_model.dart';

/// A line's unit price and quantity, side by side.
class LinePriceQuantity extends StatelessWidget {
  const LinePriceQuantity({
    required this.line,
    required this.vm,
    required this.currency,
    this.quantityError,
    super.key,
  });

  final LineItem line;
  final InvoiceEditorViewModel vm;
  final String currency;
  final String? quantityError;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        Expanded(
          child: FieldBlock(
            label: l10n.fieldPrice,
            required: true,
            child: AmountField(
              label: '',
              currencyCode: currency,
              initialMinor: line.unitPriceMinor == 0
                  ? null
                  : line.unitPriceMinor,
              onChanged: (v) => vm.setLinePrice(line.id, v),
            ),
          ),
        ),
        Expanded(
          child: FieldBlock(
            label: l10n.fieldQuantity,
            child: DecimalField(
              label: '',
              decimalDigits: AppFormatters.quantityDecimalDigits,
              value: line.quantityMilli,
              errorText: quantityError,
              onChanged: (v) => vm.setLineQuantity(line.id, v),
            ),
          ),
        ),
      ],
    );
  }
}
