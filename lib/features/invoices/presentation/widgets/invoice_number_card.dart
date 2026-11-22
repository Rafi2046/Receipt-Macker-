import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/extensions/validation_message_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../domain/models/invoice_field.dart';
import '../view_models/invoice_editor_state.dart';

/// The invoice number and its dates; tap to edit them.
class InvoiceNumberCard extends StatelessWidget {
  const InvoiceNumberCard({required this.form, required this.onTap, super.key});

  final InvoiceEditorState form;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final text = context.textStyles;
    final draft = form.draft;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final error =
        l10n.validationMessage(form.errorFor(InvoiceField.number)) ??
        l10n.validationMessage(form.errorFor(InvoiceField.dueDate));
    final secondary = text.bodySmall?.copyWith(color: colors.textSecondary);
    return AppCard(
      onTap: onTap,
      borderColor: error == null ? null : colors.danger,
      child: Row(
        spacing: AppSpacing.md,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Text(
                  draft.number,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleLarge,
                ),
                if (error != null)
                  Text(
                    error,
                    style: text.bodySmall?.copyWith(color: colors.danger),
                  )
                else
                  Wrap(
                    spacing: AppSpacing.sm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        format.calendarDate(draft.issueDate),
                        style: secondary,
                      ),
                      Icon(
                        AppIcons.forward,
                        size: AppSpacing.md,
                        color: colors.textSecondary,
                      ),
                      Text(
                        '${l10n.fieldDueDate}: '
                        '${format.calendarDate(draft.dueDate)}',
                        style: secondary,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Icon(AppIcons.chevronRight, color: colors.textSecondary),
        ],
      ),
    );
  }
}
