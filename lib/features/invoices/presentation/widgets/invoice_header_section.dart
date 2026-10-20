import 'package:flutter/material.dart';

import '../../../../core/constants/app_currencies.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/calendar_date.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/extensions/validation_message_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/inputs/date_field.dart';
import '../../../../core/widgets/inputs/dropdown_field.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/models/due_term.dart';
import '../../domain/models/invoice_field.dart';
import '../view_models/invoice_editor_state.dart';
import '../view_models/invoice_editor_view_model.dart';

/// Invoice number, issue date, payment term, due date and currency.
class InvoiceHeaderSection extends StatelessWidget {
  const InvoiceHeaderSection({required this.form, required this.vm, super.key});

  final InvoiceEditorState form;
  final InvoiceEditorViewModel vm;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final draft = form.draft;
    final digits = AppFormatters(Localizations.localeOf(context).languageCode);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        AppTextField(
          label: l10n.fieldInvoiceNumber,
          initialValue: draft.number,
          prefixIcon: AppIcons.invoice,
          errorText: l10n.validationMessage(form.errorFor(InvoiceField.number)),
          onChanged: vm.setNumber,
        ),
        DateField(
          label: l10n.fieldIssueDate,
          value: draft.issueDate.toLocalDateTime(),
          onChanged: (d) => vm.setIssueDate(CalendarDate.fromLocal(d)),
        ),
        DropdownField<DueTerm>(
          label: l10n.fieldDueTerm,
          value: form.dueTerm,
          options: [
            for (final t in DueTerm.values) (t, _termLabel(l10n, digits, t)),
          ],
          onChanged: (t) =>
              t == DueTerm.custom ? _pickDueDate(context) : vm.setDueTerm(t),
        ),
        DateField(
          label: l10n.fieldDueDate,
          value: draft.dueDate.toLocalDateTime(),
          errorText: l10n.validationMessage(
            form.errorFor(InvoiceField.dueDate),
          ),
          onChanged: (d) => vm.setDueDate(CalendarDate.fromLocal(d)),
        ),
        DropdownField<String>(
          label: l10n.fieldCurrency,
          value: draft.currencyCode,
          options: [
            for (final code in {...AppCurrencies.common, draft.currencyCode})
              (code, '$code  ${AppFormatters.currencySymbol(code)}'),
          ],
          onChanged: vm.setCurrency,
        ),
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
