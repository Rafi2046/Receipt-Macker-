import 'package:flutter/material.dart';

import '../../../../core/constants/app_currencies.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/calendar_date.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/extensions/validation_message_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/inputs/currency_picker_field.dart';
import '../../../../core/widgets/inputs/date_field.dart';
import '../../../../core/widgets/inputs/dropdown_field.dart';
import '../../../../core/widgets/layout/form_group_card.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/models/due_term.dart';
import '../../domain/models/invoice_field.dart';
import '../view_models/invoice_editor_state.dart';
import '../view_models/invoice_editor_view_model.dart';

/// Invoice number, issue date, payment term, due date and currency.
class InvoiceHeaderSection extends StatelessWidget {
  const InvoiceHeaderSection({
    required this.form,
    required this.vm,
    this.showCurrency = true,
    super.key,
  });

  final InvoiceEditorState form;
  final InvoiceEditorViewModel vm;

  /// False when the currency has its own row elsewhere.
  final bool showCurrency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final draft = form.draft;
    final digits = AppFormatters(Localizations.localeOf(context).languageCode);
    final term = DropdownField<DueTerm>(
      label: l10n.fieldDueTerm,
      value: form.dueTerm,
      options: [
        for (final t in DueTerm.values) (t, _termLabel(l10n, digits, t)),
      ],
      onChanged: (t) =>
          t == DueTerm.custom ? _pickDueDate(context) : vm.setDueTerm(t),
    );
    final currency = CurrencyPickerField(
      label: l10n.fieldCurrency,
      value: draft.currencyCode,
      codes: {...AppCurrencies.common, draft.currencyCode}.toList(),
      onChanged: vm.setCurrency,
    );
    return FormGroupCard(
      children: [
        AppTextField(
          label: l10n.fieldInvoiceNumber,
          initialValue: draft.number,
          errorText: l10n.validationMessage(form.errorFor(InvoiceField.number)),
          onChanged: vm.setNumber,
        ),
        _FieldPair(
          first: DateField(
            label: l10n.fieldIssueDate,
            value: draft.issueDate.toLocalDateTime(),
            onChanged: (d) => vm.setIssueDate(CalendarDate.fromLocal(d)),
          ),
          second: DateField(
            label: l10n.fieldDueDate,
            value: draft.dueDate.toLocalDateTime(),
            errorText: l10n.validationMessage(
              form.errorFor(InvoiceField.dueDate),
            ),
            onChanged: (d) => vm.setDueDate(CalendarDate.fromLocal(d)),
          ),
        ),
        if (showCurrency) _FieldPair(first: term, second: currency) else term,
      ],
    );
  }

  Future<void> _pickDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: form.draft.dueDate.toLocalDateTime(),
      firstDate: form.draft.issueDate.toLocalDateTime(),
      lastDate: form.draft.issueDate.addDays(_maxDueDays).toLocalDateTime(),
      helpText: context.l10n.fieldDueDate,
    );
    if (picked != null) vm.setDueDate(CalendarDate.fromLocal(picked));
  }

  static const int _maxDueDays = 3650;

  static String _termLabel(
    AppLocalizations l10n,
    AppFormatters digits,
    DueTerm term,
  ) => switch (term) {
    DueTerm.onReceipt => l10n.dueOnReceipt,
    DueTerm.custom => l10n.dueCustom,
    _ => l10n.dueInDays(digits.integer(term.days ?? 0)),
  };
}

/// Two fields side by side, or stacked when the row is too narrow or the
/// system font is large.
class _FieldPair extends StatelessWidget {
  const _FieldPair({required this.first, required this.second});

  final Widget first;
  final Widget second;

  /// Narrowest row that still fits a date and its icon in each half.
  static const double _minRowWidth = 320;
  static const double _maxTextScale = 1.15;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    return LayoutBuilder(
      builder: (context, box) {
        if (box.maxWidth < _minRowWidth || scale > _maxTextScale) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              first,
              const Divider(
                height: AppSizes.borderWidth,
                indent: AppSpacing.lg,
                endIndent: AppSpacing.lg,
              ),
              second,
            ],
          );
        }
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: first),
              const VerticalDivider(
                width: AppSizes.borderWidth,
                indent: AppSpacing.md,
                endIndent: AppSpacing.md,
              ),
              Expanded(child: second),
            ],
          ),
        );
      },
    );
  }
}
