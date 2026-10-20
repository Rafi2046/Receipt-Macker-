import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/display/amount_text.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/app_divider.dart';
import '../../domain/models/invoice_totals.dart';

/// Subtotal, discount, tax, shipping and total. Rows that are zero are left
/// out, except subtotal and total. Paid and balance show once a payment
/// exists (M6).
class TotalsSummary extends StatelessWidget {
  const TotalsSummary({
    required this.totals,
    this.taxRateBasisPoints,
    this.taxInclusive = false,
    super.key,
  });

  final InvoiceTotals totals;
  final int? taxRateBasisPoints;
  final bool taxInclusive;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rate = taxRateBasisPoints;
    final rateText = rate == null
        ? ''
        : AppFormatters(Localizations.localeOf(context).languageCode)
              .percent(rate);
    final t = totals;
    return AppCard(
      child: Column(
        spacing: AppSpacing.sm,
        children: [
          _Row(
            label: l10n.totalSubtotal,
            minor: t.subtotal,
            currency: t.currencyCode,
          ),
          if (t.discount != 0)
            _Row(
              label: l10n.totalDiscount,
              minor: -t.discount,
              currency: t.currencyCode,
            ),
          if (t.tax != 0)
            _Row(
              label: taxInclusive
                  ? l10n.totalTaxIncluded(rateText)
                  : l10n.totalTax(rateText),
              minor: t.tax,
              currency: t.currencyCode,
            ),
          if (t.shipping != 0)
            _Row(
              label: l10n.totalShipping,
              minor: t.shipping,
              currency: t.currencyCode,
            ),
          const AppDivider(spacing: AppSpacing.xs),
          _Row(
            label: l10n.totalTotal,
            minor: t.total,
            currency: t.currencyCode,
            strong: true,
          ),
          if (t.paid != 0) ...[
            _Row(
              label: l10n.totalPaid,
              minor: -t.paid,
              currency: t.currencyCode,
            ),
            _Row(
              label: l10n.totalBalance,
              minor: t.balance,
              currency: t.currencyCode,
              strong: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.minor,
    required this.currency,
    this.strong = false,
  });

  final String label;
  final int minor;
  final String currency;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final style = strong
        ? context.textStyles.titleMedium
        : context.textStyles.bodyMedium?.copyWith(
            color: context.appColors.textSecondary,
          );
    return Row(
      spacing: AppSpacing.md,
      children: [
        Expanded(child: Text(label, style: style)),
        Flexible(
          child: AmountText(
            minor: minor,
            currencyCode: currency,
            size: strong ? AmountTextSize.lg : AmountTextSize.md,
            alignment: AlignmentDirectional.centerEnd,
          ),
        ),
      ],
    );
  }
}
