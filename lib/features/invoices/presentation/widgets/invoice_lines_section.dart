import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/extensions/validation_message_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/layout/app_divider.dart';
import '../../domain/models/invoice_field.dart';
import '../view_models/invoice_editor_state.dart';
import 'line_item_row.dart';

/// The invoice's lines and an "Add an item" button.
class InvoiceLinesSection extends StatelessWidget {
  const InvoiceLinesSection({
    required this.form,
    required this.onEditLine,
    required this.onAdd,
    super.key,
  });

  final InvoiceEditorState form;
  final ValueChanged<String> onEditLine;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final draft = form.draft;
    final totals = form.totals;
    final error = l10n.validationMessage(form.errorFor(InvoiceField.lines));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, line) in draft.lines.indexed) ...[
          if (i > 0) const AppDivider(spacing: AppSpacing.xxs),
          LineItemRow(
            line: line,
            totals: totals.lines[i],
            currencyCode: draft.currencyCode,
            hasError: form.lineErrors(line.id).isNotEmpty,
            onTap: () => onEditLine(line.id),
          ),
        ],
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(
              error,
              style: context.textStyles.bodySmall?.copyWith(
                color: context.appColors.danger,
              ),
            ),
          ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: AppButton(
            label: l10n.chooseItem,
            icon: AppIcons.add,
            variant: AppButtonVariant.secondary,
            onPressed: onAdd,
          ),
        ),
      ],
    );
  }
}
