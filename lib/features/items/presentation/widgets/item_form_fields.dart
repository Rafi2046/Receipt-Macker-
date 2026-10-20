import 'package:flutter/material.dart';

import '../../../../core/constants/app_currencies.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/extensions/validation_message_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/inputs/amount_field.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/inputs/dropdown_field.dart';
import '../../../../core/widgets/inputs/percent_field.dart';
import '../../domain/models/item_field.dart';
import '../view_models/item_editor_state.dart';
import '../view_models/item_editor_view_model.dart';

/// The item editor's fields, in a scrollable page.
class ItemFormFields extends StatelessWidget {
  const ItemFormFields({required this.form, required this.vm, super.key});

  final ItemEditorState form;
  final ItemEditorViewModel vm;

  static const int _descriptionLines = 3;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final draft = form.draft;
    String? error(ItemField f) => l10n.validationMessage(form.errorFor(f));
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      children: [
        AppTextField(
          label: l10n.fieldItemName,
          hint: l10n.fieldItemNameHint,
          initialValue: draft.name,
          errorText: error(ItemField.name),
          prefixIcon: AppIcons.item,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          onChanged: vm.setName,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: l10n.fieldDescription,
          initialValue: draft.description,
          errorText: error(ItemField.description),
          maxLines: _descriptionLines,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          onChanged: vm.setDescription,
        ),
        const SizedBox(height: AppSpacing.md),
        AmountField(
          label: l10n.fieldUnitPrice,
          currencyCode: draft.currencyCode,
          initialMinor: form.hasPrice ? draft.unitPriceMinor : null,
          errorText: error(ItemField.unitPrice),
          onChanged: vm.setUnitPrice,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownField<String>(
          label: l10n.fieldCurrency,
          value: draft.currencyCode,
          options: [
            for (final code in {...AppCurrencies.common, draft.currencyCode})
              (code, '$code  ${AppFormatters.currencySymbol(code)}'),
          ],
          onChanged: vm.setCurrency,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: l10n.fieldUnit,
          hint: l10n.fieldUnitHint,
          initialValue: draft.unit,
          errorText: error(ItemField.unit),
          textInputAction: TextInputAction.next,
          onChanged: vm.setUnit,
        ),
        const SizedBox(height: AppSpacing.md),
        PercentField(
          label: l10n.fieldDefaultTax,
          hint: l10n.fieldDefaultTaxHint,
          initialBasisPoints: draft.defaultTaxBasisPoints,
          errorText: error(ItemField.defaultTax),
          onChanged: vm.setDefaultTax,
        ),
      ],
    );
  }
}
