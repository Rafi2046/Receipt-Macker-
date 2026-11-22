import 'package:flutter/material.dart';

import '../../../../core/constants/app_currencies.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/extensions/validation_message_extension.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/buttons/more_fields_toggle.dart';
import '../../../../core/widgets/inputs/amount_field.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/inputs/currency_picker_field.dart';
import '../../../../core/widgets/inputs/field_block.dart';
import '../../../../core/widgets/inputs/percent_field.dart';
import '../../../../core/widgets/inputs/soft_input_theme.dart';
import '../../../../core/widgets/inputs/unit_field.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../domain/models/item_field.dart';
import '../view_models/item_editor_state.dart';
import '../view_models/item_editor_view_model.dart';

/// The item editor's fields, one card per group: name and description,
/// price and currency, then the unit and default tax, which "Show less
/// fields" folds away.
class ItemFormFields extends StatefulWidget {
  const ItemFormFields({required this.form, required this.vm, super.key});

  final ItemEditorState form;
  final ItemEditorViewModel vm;

  @override
  State<ItemFormFields> createState() => _ItemFormFieldsState();
}

class _ItemFormFieldsState extends State<ItemFormFields> {
  bool _showMore = true;

  static const int _descriptionLines = 4;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final form = widget.form;
    final vm = widget.vm;
    final draft = form.draft;
    String? error(ItemField f) => l10n.validationMessage(form.errorFor(f));
    const gap = SizedBox(height: AppSpacing.md);
    return SoftInputTheme(
      style: SoftInputStyle.boxed,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          _Group(
            children: [
              FieldBlock(
                label: l10n.fieldItemName,
                required: true,
                child: AppTextField(
                  label: '',
                  hint: l10n.fieldItemNamePlaceholder,
                  initialValue: draft.name,
                  errorText: error(ItemField.name),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  onChanged: vm.setName,
                ),
              ),
              FieldBlock(
                label: l10n.fieldDescription,
                child: AppTextField(
                  label: '',
                  hint: l10n.fieldDescriptionHint,
                  initialValue: draft.description,
                  errorText: error(ItemField.description),
                  maxLines: _descriptionLines,
                  maxLength: Validators.maxLongText,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: vm.setDescription,
                ),
              ),
            ],
          ),
          gap,
          _Group(
            children: [
              FieldBlock(
                label: l10n.fieldPrice,
                required: true,
                child: AmountField(
                  label: '',
                  currencyCode: draft.currencyCode,
                  initialMinor: form.hasPrice ? draft.unitPriceMinor : null,
                  errorText: error(ItemField.unitPrice),
                  onChanged: vm.setUnitPrice,
                ),
              ),
              FieldBlock(
                label: l10n.fieldCurrency,
                child: CurrencyPickerField(
                  label: '',
                  value: draft.currencyCode,
                  codes: {...AppCurrencies.common, draft.currencyCode}.toList(),
                  onChanged: vm.setCurrency,
                ),
              ),
            ],
          ),
          if (_showMore) ...[
            gap,
            _Group(
              children: [
                FieldBlock(
                  label: l10n.unitOfMeasure,
                  child: UnitField(
                    value: draft.unit,
                    errorText: error(ItemField.unit),
                    onChanged: vm.setUnit,
                  ),
                ),
              ],
            ),
            gap,
            _Group(
              children: [
                FieldBlock(
                  label: l10n.fieldDefaultTax,
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
          ],
          gap,
          MoreFieldsToggle(
            expanded: _showMore,
            onPressed: () => setState(() => _showMore = !_showMore),
          ),
        ],
      ),
    );
  }
}

/// One card of the form.
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
