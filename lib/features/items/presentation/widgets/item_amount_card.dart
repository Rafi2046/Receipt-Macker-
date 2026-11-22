import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/extensions/validation_message_extension.dart';
import '../../../../core/widgets/display/amount_text.dart';
import '../../../../core/widgets/inputs/discount_fields.dart';
import '../../../../core/widgets/inputs/field_block.dart';
import '../../../../core/widgets/inputs/percent_field.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/ticket_divider.dart';
import '../../domain/logic/item_pricing.dart';
import '../../domain/models/item_discount_type.dart';
import '../../domain/models/item_field.dart';
import '../view_models/item_editor_state.dart';
import '../view_models/item_editor_view_model.dart';

/// The item's default discount and tax rate (when [showFields]), then what
/// it comes to on a ticket stub.
class ItemAmountCard extends StatelessWidget {
  const ItemAmountCard({
    required this.form,
    required this.vm,
    required this.showFields,
    super.key,
  });

  final ItemEditorState form;
  final ItemEditorViewModel vm;
  final bool showFields;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final draft = form.draft;
    String? error(ItemField f) => l10n.validationMessage(form.errorFor(f));
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showFields) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSpacing.lg,
                children: [
                  DiscountFields(
                    kind: switch (draft.discountType) {
                      null => DiscountKind.none,
                      ItemDiscountType.percent => DiscountKind.percent,
                      ItemDiscountType.flat => DiscountKind.flat,
                    },
                    value: draft.discountValue,
                    currencyCode: draft.currencyCode,
                    errorText: error(ItemField.discount),
                    onChanged: (kind, value) => vm.setDiscount(switch (kind) {
                      DiscountKind.none => null,
                      DiscountKind.percent => ItemDiscountType.percent,
                      DiscountKind.flat => ItemDiscountType.flat,
                    }, value),
                  ),
                  FieldBlock(
                    label: l10n.fieldTaxRate,
                    child: PercentField(
                      label: '',
                      hint: l10n.fieldDefaultTaxHint,
                      basisPoints: draft.defaultTaxBasisPoints,
                      errorText: error(ItemField.defaultTax),
                      onChanged: vm.setDefaultTax,
                    ),
                  ),
                ],
              ),
            ),
            const TicketDivider(),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              spacing: AppSpacing.md,
              children: [
                Expanded(
                  child: Text(
                    l10n.itemAmount,
                    style: context.textStyles.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                AmountText(
                  minor: ItemPricing.amount(draft).minor,
                  currencyCode: draft.currencyCode,
                  size: AmountTextSize.lg,
                  alignment: AlignmentDirectional.centerEnd,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
