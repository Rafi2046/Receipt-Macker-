import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/display/amount_text.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../view_models/invoice_detail_state.dart';
import 'invoice_status_chip.dart';

/// Number, status, total and dates at the top of the invoice detail.
class InvoiceDetailHeader extends StatelessWidget {
  const InvoiceDetailHeader({required this.state, super.key});

  final InvoiceDetailState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final invoice = state.invoice;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final secondary = context.textStyles.bodySmall?.copyWith(
      color: context.appColors.textSecondary,
    );
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                format.localizeDigits(invoice.number),
                style: context.textStyles.titleMedium,
              ),
              InvoiceStatusChip(status: state.status),
            ],
          ),
          AmountText(
            minor: state.totals.total,
            currencyCode: invoice.currencyCode,
            size: AmountTextSize.lg,
          ),
          Text(
            l10n.invoiceIssuedOn(format.calendarDate(invoice.issueDate)),
            style: secondary,
          ),
          Text(
            l10n.invoiceDueOn(format.calendarDate(invoice.dueDate)),
            style: secondary,
          ),
        ],
      ),
    );
  }
}
