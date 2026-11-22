import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/extensions/validation_message_extension.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/buttons/more_fields_toggle.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/inputs/discount_fields.dart';
import '../../../../core/widgets/inputs/field_block.dart';
import '../../../../core/widgets/inputs/soft_input_theme.dart';
import '../../../../core/widgets/inputs/unit_field.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../domain/models/discount.dart';
import '../../domain/models/discount_type.dart';
import '../../domain/models/line_field.dart';
import '../view_models/invoice_editor_view_model.dart';
import 'line_amount_card.dart';
import 'line_price_quantity.dart';

/// Edits one line of the invoice draft in place, one card per group: name
/// and description, price and quantity, the unit, then the discount with
/// the line amount on a ticket stub. Use [LineItemSheet.show]; a line left
/// empty is dropped when the sheet closes.
class LineItemSheet extends ConsumerStatefulWidget {
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
      showDragHandle: true,
      backgroundColor: context.appColors.background,
      builder: (_) => LineItemSheet(provider: provider, lineId: lineId),
    );
    ref.read(provider.notifier).discardLineIfBlank(lineId);
  }

  @override
  ConsumerState<LineItemSheet> createState() => _LineItemSheetState();
}

class _LineItemSheetState extends ConsumerState<LineItemSheet> {
  bool _showMore = true;

  /// Whether the line was still unnamed when the sheet opened.
  bool? _isNew;

  static const int _descriptionLines = 3;

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
    final lineId = widget.lineId;
    final form = ref.watch(provider).value;
    final line = form?.draft.lines.where((l) => l.id == lineId).firstOrNull;
    if (form == null || line == null) return const SizedBox.shrink();
    final vm = ref.read(provider.notifier);
    final l10n = context.l10n;
    final currency = form.draft.currencyCode;
    final errors = form.lineErrors(lineId);
    String? error(LineField f) => l10n.validationMessage(errors[f]);
    final foreign = form.foreignPriceLines[lineId];
    final isNew = _isNew ??= line.name.trim().isEmpty;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SoftInputTheme(
        style: SoftInputStyle.boxed,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            0,
            AppSpacing.pagePadding,
            AppSpacing.pagePadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.md,
            children: [
              Text(
                isNew ? l10n.lineNewTitle : l10n.lineEditTitle,
                style: context.textStyles.titleLarge,
              ),
              _Group(
                children: [
                  FieldBlock(
                    label: l10n.fieldItemName,
                    required: true,
                    child: AppTextField(
                      label: '',
                      hint: l10n.fieldItemNamePlaceholder,
                      initialValue: line.name,
                      errorText: error(LineField.name),
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      onChanged: (v) => vm.setLineName(lineId, v),
                    ),
                  ),
                  FieldBlock(
                    label: l10n.fieldDescription,
                    child: AppTextField(
                      label: '',
                      hint: l10n.fieldDescriptionHint,
                      initialValue: line.description,
                      maxLines: _descriptionLines,
                      maxLength: Validators.maxLongText,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (v) => vm.setLineDescription(lineId, v),
                    ),
                  ),
                ],
              ),
              _Group(
                children: [
                  LinePriceQuantity(
                    line: line,
                    vm: vm,
                    currency: currency,
                    quantityError: error(LineField.quantity),
                  ),
                  if (foreign != null)
                    Text(
                      l10n.lineCurrencyNote(foreign, currency),
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.appColors.warning,
                      ),
                    ),
                ],
              ),
              if (_showMore)
                _Group(
                  children: [
                    FieldBlock(
                      label: l10n.unitOfMeasure,
                      child: UnitField(
                        value: line.unit,
                        onChanged: (v) => vm.setLineUnit(lineId, v),
                      ),
                    ),
                  ],
                ),
              LineAmountCard(
                line: line,
                currency: currency,
                error: error(LineField.total),
                discount: _showMore
                    ? DiscountFields(
                        kind: switch (line.discount?.type) {
                          null => DiscountKind.none,
                          DiscountType.percent => DiscountKind.percent,
                          DiscountType.flat => DiscountKind.flat,
                        },
                        value: line.discount?.value ?? 0,
                        currencyCode: currency,
                        errorText: error(LineField.discount),
                        onChanged: (kind, value) =>
                            vm.setLineDiscount(lineId, switch (kind) {
                              DiscountKind.none => null,
                              DiscountKind.percent => Discount(
                                type: DiscountType.percent,
                                value: value,
                              ),
                              DiscountKind.flat => Discount(
                                type: DiscountType.flat,
                                value: value,
                              ),
                            }),
                      )
                    : null,
              ),
              MoreFieldsToggle(
                expanded: _showMore,
                onPressed: () => setState(() => _showMore = !_showMore),
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
      ),
    );
  }
}

/// One card of the sheet.
class _Group extends StatelessWidget {
  const _Group({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.lg,
        children: children,
      ),
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
