import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/extensions/validation_message_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/display/amount_text.dart';
import '../../../../core/widgets/inputs/amount_field.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/inputs/decimal_field.dart';
import '../../domain/logic/invoice_calculator.dart';
import '../../domain/models/line_field.dart';
import '../../domain/models/line_item.dart';
import '../view_models/invoice_editor_view_model.dart';
import 'discount_input.dart';

/// Edits one line of the invoice draft in place. Use [LineItemSheet.show];
/// a line left empty is dropped when the sheet closes.
class LineItemSheet extends ConsumerWidget {
  const LineItemSheet({
    required this.provider,
    required this.lineId,
    super.key,
  });

  final InvoiceEditorViewModelProvider provider;
  final String lineId;

  static Future<void> show(
    BuildContext context,
    WidgetRef ref, {
    required InvoiceEditorViewModelProvider provider,
    required String lineId,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => LineItemSheet(provider: provider, lineId: lineId),
    );
    ref.read(provider.notifier).discardLineIfBlank(lineId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(provider).value;
    final line = form?.draft.lines.where((l) => l.id == lineId).firstOrNull;
    if (form == null || line == null) return const SizedBox.shrink();
    final vm = ref.read(provider.notifier);
    final l10n = context.l10n;
    final currency = form.draft.currencyCode;
    final errors = form.lineErrors(lineId);
    String? error(LineField f) => l10n.validationMessage(errors[f]);
    final foreign = form.foreignPriceLines[lineId];
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.md,
          children: [
            Text(l10n.lineEditTitle, style: context.textStyles.titleMedium),
            AppTextField(
              label: l10n.fieldItemName,
              initialValue: line.name,
              errorText: error(LineField.name),
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              onChanged: (v) => vm.setLineName(lineId, v),
            ),
            AppTextField(
              label: l10n.fieldDescription,
              initialValue: line.description,
              maxLines: _descriptionLines,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (v) => vm.setLineDescription(lineId, v),
            ),
            _QuantityAndUnit(
              line: line,
              vm: vm,
              error: error(LineField.quantity),
            ),
            if (foreign != null)
              Text(
                l10n.lineCurrencyNote(foreign, currency),
                style: context.textStyles.bodySmall?.copyWith(
                  color: context.appColors.warning,
                ),
              ),
            AmountField(
              label: l10n.fieldUnitPrice,
              currencyCode: currency,
              initialMinor: line.unitPriceMinor == 0
                  ? null
                  : line.unitPriceMinor,
              onChanged: (v) => vm.setLinePrice(lineId, v),
            ),
            DiscountInput(
              label: l10n.fieldDiscount,
              currencyCode: currency,
              discount: line.discount,
              errorText: error(LineField.discount),
              onChanged: (d) => vm.setLineDiscount(lineId, d),
            ),
            _LineTotal(
              line: line,
              currency: currency,
              error: error(LineField.total),
            ),
            _Actions(
              onRemove: () {
                vm.removeLine(lineId);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  static const int _descriptionLines = 2;
}

class _QuantityAndUnit extends StatelessWidget {
  const _QuantityAndUnit({required this.line, required this.vm, this.error});

  final LineItem line;
  final InvoiceEditorViewModel vm;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        Expanded(
          child: DecimalField(
            label: l10n.fieldQuantity,
            decimalDigits: AppFormatters.quantityDecimalDigits,
            initialScaled: line.quantityMilli,
            errorText: error,
            onChanged: (v) => vm.setLineQuantity(line.id, v),
          ),
        ),
        Expanded(
          child: AppTextField(
            label: l10n.fieldUnit,
            hint: l10n.fieldUnitHint,
            initialValue: line.unit,
            onChanged: (v) => vm.setLineUnit(line.id, v),
          ),
        ),
      ],
    );
  }
}

class _LineTotal extends StatelessWidget {
  const _LineTotal({required this.line, required this.currency, this.error});

  final LineItem line;
  final String currency;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final totals = InvoiceCalculator.line(line, currency);
    final message = error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.lineTotal,
                style: context.textStyles.titleSmall,
              ),
            ),
            Flexible(
              child: AmountText(
                minor: totals.net,
                currencyCode: currency,
                alignment: AlignmentDirectional.centerEnd,
              ),
            ),
          ],
        ),
        if (message != null)
          Text(
            message,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.appColors.danger,
            ),
          ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.onRemove});

  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        AppButton(
          label: l10n.removeFromInvoice,
          variant: AppButtonVariant.text,
          onPressed: onRemove,
        ),
        AppButton(
          label: l10n.done,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
