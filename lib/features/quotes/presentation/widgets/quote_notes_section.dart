import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../domain/models/quote.dart';
import '../view_models/quote_editor_view_model.dart';

class QuoteNotesSection extends StatelessWidget {
  const QuoteNotesSection({required this.draft, required this.vm, super.key});

  final Quote draft;
  final QuoteEditorViewModel vm;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        AppTextField(
          label: l10n.fieldNotes,
          initialValue: draft.notes,
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          onChanged: vm.setNotes,
        ),
        AppTextField(
          label: l10n.fieldTerms,
          initialValue: draft.terms,
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          onChanged: vm.setTerms,
        ),
        AppTextField(
          label: l10n.fieldPaymentInstructions,
          initialValue: draft.paymentInstructions,
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          onChanged: vm.setPaymentInstructions,
        ),
      ],
    );
  }
}
