import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/display/amount_text.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/ticket_divider.dart';
import '../../domain/models/invoice_totals.dart';
import 'editor_amount_row.dart';
import 'editor_row.dart';

/// Discount, tax and shipping as they stand, then the total on a ticket
/// stub (and paid / balance once a payment exists). Tap to change them.
class InvoiceAdjustmentCard extends StatelessWidget {
  const InvoiceAdjustmentCard({
    required this.totals,
    required this.taxRateBasisPoints,
    required this.taxInclusive,
    required this.onTap,
    super.key,
  });

  final InvoiceTotals totals;
  final int? taxRateBasisPoints;
  final bool taxInclusive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = totals;
    final rate = taxRateBasisPoints;
    final rateText = rate == null
        ? ''
        : AppFormatters(Localizations.localeOf(context).languageCode)
              .percent(rate);
    final taxLabel = taxInclusive
        ? l10n.totalTaxIncluded(rateText)
        : l10n.totalTax(rateText);
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EditorRow(
            icon: AppIcons.adjust,
            title: l10n.editorAdjustment,
            onTap: onTap,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Material(
              color: context.appColors.surfaceAlt,
              borderRadius: AppRadius.card,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  _Line(
                    label: l10n.totalDiscount,
                    minor: -t.discount,
                    currency: t.currencyCode,
                    onTap: onTap,
                  ),
                  const _Hairline(),
                  _Line(
                    label: taxLabel.trim(),
                    minor: t.tax,
                    currency: t.currencyCode,
                    onTap: onTap,
                  ),
                  const _Hairline(),
                  _Line(
                    label: l10n.totalShipping,
                    minor: t.shipping,
                    currency: t.currencyCode,
                    onTap: onTap,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const TicketDivider(),
          EditorAmountRow(
            label: l10n.totalTotal,
            minor: t.total,
            currencyCode: t.currencyCode,
            strong: true,
          ),
          if (t.paid != 0) ...[
            EditorAmountRow(
              label: l10n.totalPaid,
              minor: -t.paid,
              currencyCode: t.currencyCode,
            ),
            EditorAmountRow(
              label: l10n.totalBalance,
              minor: t.balance,
              currencyCode: t.currencyCode,
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

class _Hairline extends StatelessWidget {
  const _Hairline();

  @override
  Widget build(BuildContext context) => const Divider(
    height: AppSizes.borderWidth,
    indent: AppSpacing.lg,
    endIndent: AppSpacing.lg,
  );
}

class _Line extends StatelessWidget {
  const _Line({
    required this.label,
    required this.minor,
    required this.currency,
    required this.onTap,
  });

  final String label;
  final int minor;
  final String currency;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg,
            end: AppSpacing.sm,
          ),
          child: Row(
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: Text(label, style: context.textStyles.bodyMedium),
              ),
              AmountText(
                minor: minor,
                currencyCode: currency,
                alignment: AlignmentDirectional.centerEnd,
              ),
              Icon(AppIcons.chevronRight, color: colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
