import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../view_models/invoice_editor_state.dart';
import '../view_models/invoice_editor_view_model.dart';

/// Notes, terms and payment instructions, prefilled from the profile.
class InvoiceNotesSection extends StatelessWidget {
  const InvoiceNotesSection({required this.form, required this.vm, super.key});

  final InvoiceEditorState form;
  final InvoiceEditorViewModel vm;

  static const int _lines = 3;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final draft = form.draft;
    Widget field(String label, String value, ValueChanged<String> onChanged) =>
        AppTextField(
          label: label,
          initialValue: value,
          maxLines: _lines,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          onChanged: onChanged,
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        field(l10n.fieldNotes, draft.notes, vm.setNotes),
        field(l10n.fieldTerms, draft.terms, vm.setTerms),
        field(
          l10n.fieldPaymentInstructions,
          draft.paymentInstructions,
          vm.setPaymentInstructions,
        ),
      ],
    );
  }
}
