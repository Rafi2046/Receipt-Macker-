import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/extensions/validation_message_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/ticket_divider.dart';
import '../../domain/models/invoice_field.dart';
import '../view_models/invoice_editor_state.dart';
import 'editor_add_dot.dart';
import 'editor_amount_row.dart';
import 'editor_row.dart';
import 'line_item_row.dart';

/// The invoice's lines under an "Items" row that adds one, then the
/// subtotal on a ticket stub.
class InvoiceItemsCard extends StatelessWidget {
  const InvoiceItemsCard({
    required this.form,
    required this.onAdd,
    required this.onEditLine,
    super.key,
  });

  final InvoiceEditorState form;
  final VoidCallback onAdd;
  final ValueChanged<String> onEditLine;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final draft = form.draft;
    final totals = form.totals;
    final digits = AppFormatters(Localizations.localeOf(context).languageCode);
    final error = l10n.validationMessage(form.errorFor(InvoiceField.lines));
    return AppCard(
      padding: EdgeInsets.zero,
      borderColor: error == null ? null : colors.danger,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EditorRow(
            icon: AppIcons.invoice,
            tone: colors.success,
            title: l10n.itemsTitle,
            subtitle:
                error ??
                (draft.lines.isEmpty
                    ? l10n.editorAddItems
                    : l10n.editorItemsCount(
                        draft.lines.length,
                        digits.integer(draft.lines.length),
                      )),
            hasError: error != null,
            trailing: const EditorAddDot(),
            onTap: onAdd,
          ),
          for (final (i, line) in draft.lines.indexed) ...[
            const Divider(
              height: AppSizes.borderWidth,
              indent: AppSpacing.lg,
              endIndent: AppSpacing.lg,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: LineItemRow(
                line: line,
                totals: totals.lines[i],
                currencyCode: draft.currencyCode,
                hasError: form.lineErrors(line.id).isNotEmpty,
                onTap: () => onEditLine(line.id),
              ),
            ),
          ],
          const TicketDivider(),
          EditorAmountRow(
            label: l10n.totalSubtotal,
            minor: totals.subtotal,
            currencyCode: totals.currencyCode,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
