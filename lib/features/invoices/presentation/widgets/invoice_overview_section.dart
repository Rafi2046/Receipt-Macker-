import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/inputs/choice_sheet.dart';
import '../../domain/logic/invoice_overview.dart';
import '../../domain/models/invoice_list_filter.dart';
import '../../domain/models/invoice_period.dart';

/// "Overview · This month ▾" and three totals: Paid, Unpaid, Overdue.
/// Tapping a total filters the list to it; tapping it again shows all.
class InvoiceOverviewSection extends StatelessWidget {
  const InvoiceOverviewSection({
    required this.overview,
    required this.period,
    required this.filter,
    required this.onPeriod,
    required this.onFilter,
    super.key,
  });

  final InvoiceOverview overview;
  final InvoicePeriod period;
  final InvoiceListFilter filter;
  final ValueChanged<InvoicePeriod> onPeriod;
  final ValueChanged<InvoiceListFilter> onFilter;

  static String periodLabel(BuildContext context, InvoicePeriod period) {
    final l10n = context.l10n;
    return switch (period) {
      InvoicePeriod.thisMonth => l10n.periodThisMonth,
      InvoicePeriod.lastMonth => l10n.periodLastMonth,
      InvoicePeriod.thisYear => l10n.periodThisYear,
      InvoicePeriod.allTime => l10n.periodAllTime,
    };
  }

  Future<void> _pickPeriod(BuildContext context) async {
    final picked = await ChoiceSheet.show(
      context,
      title: context.l10n.periodTitle,
      selected: period,
      options: [
        for (final p in InvoicePeriod.values)
          (value: p, label: periodLabel(context, p), icon: null),
      ],
    );
    if (picked != null) onPeriod(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    Widget stat(String label, int minor, Color tone, InvoiceListFilter f) =>
        Expanded(
          child: _Stat(
            label: label,
            minor: minor,
            currencyCode: overview.currencyCode,
            tone: tone,
            selected: filter == f,
            onTap: () => onFilter(filter == f ? InvoiceListFilter.all : f),
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.homeOverview,
                style: context.textStyles.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () => _pickPeriod(context),
              iconAlignment: IconAlignment.end,
              icon: const Icon(AppIcons.dropdown, size: AppSizes.iconSm),
              label: Text(periodLabel(context, period)),
              style: TextButton.styleFrom(
                foregroundColor: colors.textSecondary,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
        Row(
          spacing: AppSpacing.sm,
          children: [
            stat(
              l10n.filterPaid,
              overview.paidMinor,
              colors.success,
              InvoiceListFilter.paid,
            ),
            stat(
              l10n.filterUnpaid,
              overview.unpaidMinor,
              colors.textPrimary,
              InvoiceListFilter.unpaid,
            ),
            stat(
              l10n.filterOverdue,
              overview.overdueMinor,
              colors.danger,
              InvoiceListFilter.overdue,
            ),
          ],
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.minor,
    required this.currencyCode,
    required this.tone,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int minor;
  final String currencyCode;
  final Color tone;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? tone.withValues(alpha: 0.10) : colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(color: selected ? tone : colors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.labelMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    format.currency(minor, currencyCode),
                    maxLines: 1,
                    style: context.textStyles.titleMedium?.copyWith(
                      color: tone,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
