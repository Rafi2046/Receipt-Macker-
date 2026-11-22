import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/ticket_divider.dart';
import '../../domain/logic/invoice_calculator.dart';
import '../../domain/models/line_item.dart';
import 'editor_amount_row.dart';

/// The discount fields (when shown), then the line amount on a ticket stub.
class LineAmountCard extends StatelessWidget {
  const LineAmountCard({
    required this.line,
    required this.currency,
    this.discount,
    this.error,
    super.key,
  });

  final LineItem line;
  final String currency;
  final Widget? discount;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final totals = InvoiceCalculator.line(line, currency);
    final message = error;
    final discount = this.discount;
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (discount != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: discount,
            ),
            const TicketDivider(),
          ],
          EditorAmountRow(
            label: context.l10n.lineTotal,
            minor: totals.net,
            currencyCode: currency,
            strong: true,
          ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                message,
                style: context.textStyles.bodySmall?.copyWith(
                  color: context.appColors.danger,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
