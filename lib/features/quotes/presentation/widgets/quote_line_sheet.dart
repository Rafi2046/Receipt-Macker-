import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/inputs/amount_field.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/inputs/decimal_field.dart';
import '../../../invoices/domain/models/line_item.dart';

/// Edit one quote line; returns the updated line or null if cancelled.
class QuoteLineSheet extends StatefulWidget {
  const QuoteLineSheet({
    required this.line,
    required this.currencyCode,
    super.key,
  });

  final LineItem line;
  final String currencyCode;

  static Future<LineItem?> show(
    BuildContext context, {
    required LineItem line,
    required String currencyCode,
  }) {
    return showModalBottomSheet<LineItem>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => QuoteLineSheet(line: line, currencyCode: currencyCode),
    );
  }

  @override
  State<QuoteLineSheet> createState() => _QuoteLineSheetState();
}

class _QuoteLineSheetState extends State<QuoteLineSheet> {
  late String _name = widget.line.name;
  late String _description = widget.line.description;
  late int _qtyMilli = widget.line.quantityMilli;
  late int _unitPrice = widget.line.unitPriceMinor;
  late String _unit = widget.line.unit;

  void _save() {
    final name = _name.trim();
    if (name.isEmpty) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pop(
      widget.line.copyWith(
        name: name,
        description: _description.trim(),
        quantityMilli: _qtyMilli <= 0 ? 1000 : _qtyMilli,
        unitPriceMinor: _unitPrice,
        unit: _unit.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.pagePadding,
        right: AppSpacing.pagePadding,
        top: AppSpacing.lg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.quoteAddItem,
            style: context.textStyles.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: l10n.pdfColItem,
            initialValue: _name,
            onChanged: (v) => _name = v,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: l10n.fieldDescription,
            initialValue: _description,
            maxLines: 2,
            onChanged: (v) => _description = v,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: DecimalField(
                  label: l10n.pdfColQty,
                  decimalDigits: 3,
                  value: _qtyMilli,
                  onChanged: (v) => _qtyMilli = v ?? 1000,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppTextField(
                  label: l10n.fieldUnit,
                  initialValue: _unit,
                  onChanged: (v) => _unit = v,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AmountField(
            label: l10n.pdfColPrice,
            currencyCode: widget.currencyCode,
            initialMinor: _unitPrice == 0 ? null : _unitPrice,
            onChanged: (v) => _unitPrice = v ?? 0,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(label: l10n.save, expand: true, onPressed: _save),
        ],
      ),
    );
  }
}
