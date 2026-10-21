import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/display/amount_text.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../invoices/presentation/widgets/invoice_status_chip.dart';
import '../home_invoice.dart';

/// A recent invoice on Home.
class HomeInvoiceRow extends StatelessWidget {
  const HomeInvoiceRow({required this.invoice, required this.onTap, super.key});

  final HomeInvoice invoice;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final summary = invoice.summary;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final muted = context.textStyles.bodySmall?.copyWith(
      color: context.appColors.textSecondary,
    );
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summary.clientName ?? context.l10n.noClient,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.titleSmall,
                ),
                Text(format.localizeDigits(summary.number), style: muted),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AmountText(
                minor: summary.totalMinor,
                currencyCode: summary.currencyCode,
              ),
              const SizedBox(height: AppSpacing.xs),
              InvoiceStatusChip(status: invoice.status),
            ],
          ),
        ],
      ),
    );
  }
}
