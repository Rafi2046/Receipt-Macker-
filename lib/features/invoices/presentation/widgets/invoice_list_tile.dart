import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/display/amount_text.dart';
import '../view_models/invoice_list_state.dart';
import 'invoice_status_chip.dart';

/// One invoice: number, client and due date on the left; total and status
/// on the right.
class InvoiceListTile extends StatelessWidget {
  const InvoiceListTile({required this.entry, required this.onTap, super.key});

  final InvoiceListEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = entry.summary;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final secondary = context.textStyles.bodySmall?.copyWith(
      color: context.appColors.textSecondary,
    );
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePadding,
          vertical: AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.md,
          children: [
            Expanded(
              flex: _detailsFlex,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.clientName ?? l10n.noClient,
                    style: context.textStyles.bodyLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(format.localizeDigits(s.number), style: secondary),
                  Text(
                    l10n.invoiceDueOn(format.calendarDate(s.dueDate)),
                    style: secondary,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: _amountFlex,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: AppSpacing.xs,
                children: [
                  AmountText(
                    minor: s.totalMinor,
                    currencyCode: s.currencyCode,
                    alignment: AlignmentDirectional.centerEnd,
                  ),
                  InvoiceStatusChip(status: entry.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const int _detailsFlex = 3;
  static const int _amountFlex = 2;
}
