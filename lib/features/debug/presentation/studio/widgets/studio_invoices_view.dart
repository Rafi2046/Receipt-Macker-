import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../studio_demo.dart';
import '../studio_icons.dart';
import '../studio_invoice.dart';
import '../studio_money.dart';
import '../studio_scope.dart';
import '../studio_status.dart';
import 'studio_card.dart';
import 'studio_filter_chips.dart';
import 'studio_invoice_tile.dart';
import 'studio_search_field.dart';
import 'studio_swipe_row.dart';

/// Search, status counts, month groups, and swipe actions.
class StudioInvoicesView extends StatefulWidget {
  const StudioInvoicesView({required this.onOpen, super.key});

  final ValueChanged<StudioInvoice> onOpen;

  @override
  State<StudioInvoicesView> createState() => _StudioInvoicesViewState();
}

class _StudioInvoicesViewState extends State<StudioInvoicesView> {
  final List<StudioInvoice> _items = [...StudioDemo.invoices];
  String _query = '';
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = [
      l10n.studioFilterAll,
      l10n.studioFilterUnpaid,
      l10n.statusOverdue,
      l10n.statusPaid,
      l10n.statusDraft,
    ];
    final counts = [
      for (final count in StudioDemo.filterCounts)
        studioFormat(context).integer(count),
    ];
    final shown = _shown();
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        AppSpacing.sm,
        AppSpacing.pagePadding,
        AppSizes.fabClearance,
      ),
      children: [
        Text(
          l10n.invoicesTitle,
          style: context.studioType.title(context.studio.ink),
        ),
        const SizedBox(height: AppSpacing.md),
        StudioSearchField(hint: l10n.studioSearchInvoices, onChanged: _search),
        const SizedBox(height: AppSpacing.md),
        StudioFilterChips(
          labels: labels,
          counts: counts,
          selected: _filter,
          onSelected: (index) => setState(() => _filter = index),
        ),
        const SizedBox(height: AppSpacing.lg),
        _MonthGroup(
          title: _monthTitle(DateTime(2026, 10)),
          invoices: shown.where((invoice) => invoice.inOctober).toList(),
          onOpen: widget.onOpen,
          onPaid: _markPaid,
          onDelete: _delete,
        ),
        const SizedBox(height: AppSpacing.lg),
        _MonthGroup(
          title: _monthTitle(DateTime(2026, 9)),
          invoices: shown.where((invoice) => !invoice.inOctober).toList(),
          onOpen: widget.onOpen,
          onPaid: _markPaid,
          onDelete: _delete,
        ),
      ],
    );
  }

  String _monthTitle(DateTime month) =>
      DateFormat.yMMMM(Localizations.localeOf(context).toString())
          .format(month);

  void _search(String value) =>
      setState(() => _query = value.trim().toLowerCase());

  List<StudioInvoice> _shown() {
    return [
      for (final invoice in _items)
        if (_matchesFilter(invoice) && _matchesQuery(invoice)) invoice,
    ];
  }

  bool _matchesQuery(StudioInvoice invoice) {
    if (_query.isEmpty) return true;
    final haystack = '${invoice.client} ${invoice.number}'.toLowerCase();
    return haystack.contains(_query);
  }

  bool _matchesFilter(StudioInvoice invoice) {
    return switch (_filter) {
      1 =>
        invoice.status != StudioStatus.paid &&
            invoice.status != StudioStatus.draft,
      2 => invoice.status == StudioStatus.overdue,
      3 => invoice.status == StudioStatus.paid,
      4 => invoice.status == StudioStatus.draft,
      _ => true,
    };
  }

  void _markPaid(StudioInvoice invoice) {
    setState(() {
      final index = _items.indexWhere((item) => item.number == invoice.number);
      if (index < 0) return;
      _items[index] = StudioInvoice(
        client: invoice.client,
        number: invoice.number,
        phone: invoice.phone,
        totalMinor: invoice.totalMinor,
        paidMinor: invoice.totalMinor,
        dueInDays: invoice.dueInDays,
        status: StudioStatus.paid,
        inOctober: invoice.inOctober,
      );
    });
  }

  void _delete(StudioInvoice invoice) {
    setState(() => _items.removeWhere((item) => item.number == invoice.number));
  }
}

class _MonthGroup extends StatelessWidget {
  const _MonthGroup({
    required this.title,
    required this.invoices,
    required this.onOpen,
    required this.onPaid,
    required this.onDelete,
  });

  final String title;
  final List<StudioInvoice> invoices;
  final ValueChanged<StudioInvoice> onOpen;
  final ValueChanged<StudioInvoice> onPaid;
  final ValueChanged<StudioInvoice> onDelete;

  @override
  Widget build(BuildContext context) {
    if (invoices.isEmpty) return const SizedBox.shrink();
    final l10n = context.l10n;
    final palette = context.studio;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.studioType.label(palette.muted)),
        const SizedBox(height: AppSpacing.sm),
        DecoratedBox(
          decoration: studioCardDecoration(palette),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                for (final invoice in invoices)
                  StudioSwipeRow(
                    actions: [
                      StudioSwipeAction(
                        icon: StudioIcons.paid,
                        label: l10n.studioMarkPaid,
                        color: palette.paid,
                        onPressed: () => onPaid(invoice),
                      ),
                      StudioSwipeAction(
                        icon: StudioIcons.share,
                        label: l10n.studioShare,
                        color: palette.sent,
                        onPressed: () {},
                      ),
                      StudioSwipeAction(
                        icon: StudioIcons.delete,
                        label: l10n.delete,
                        color: palette.overdue,
                        onPressed: () => onDelete(invoice),
                      ),
                    ],
                    child: StudioInvoiceTile(
                      invoice: invoice,
                      onTap: () => onOpen(invoice),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
