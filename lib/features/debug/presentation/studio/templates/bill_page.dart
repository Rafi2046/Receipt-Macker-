import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../studio_demo.dart';
import '../studio_money.dart';
import '../studio_scope.dart';
import 'bill_colors.dart';
import 'bill_kinds.dart';
import 'bill_lines.dart';
import 'bill_mast.dart';
import 'bill_sample.dart';
import 'bill_template.dart';

/// One page of a template, with sample data in the current language.
class BillPage extends StatelessWidget {
  const BillPage({
    required this.template,
    required this.paper,
    required this.page,
    required this.pageCount,
    super.key,
  });

  final BillTemplate template;
  final BillPaper paper;
  final int page;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    final lines = _lines(context);
    final perPage = paper.linesPerPage;
    final slice = billLinesForPage(lines, page, perPage);
    final last = page == pageCount - 1;
    final colors = template.colors;
    final layout = template.layoutFor(paper);
    final body = Padding(
      padding: EdgeInsets.all(paper.isThermal ? AppSpacing.sm : AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (page == 0)
            BillMast(
              layout: layout,
              header: template.header,
              colors: colors,
              title: context.l10n.pdfInvoiceTitle,
              number: studioFormat(context).localizeDigits('INV-0005'),
              seller: StudioDemo.business,
              detail: studioFormat(context).localizeDigits('01712345678'),
            ),
          if (page == 0 && layout == BillLayout.statement)
            _Dates(colors: colors),
          if (page == 0) _Buyer(colors: colors),
          BillLines(
            lines: slice,
            colors: colors,
            ruled: layout == BillLayout.ruled,
            paper: paper,
          ),
          if (last) _Totals(colors: colors, lines: lines),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.l10n.studioPageOf(
              studioFormat(context).integer(page + 1),
              studioFormat(context).integer(pageCount),
            ),
            textAlign: TextAlign.center,
            style: context.studioType.label(colors.muted),
          ),
        ],
      ),
    );
    final pageBody = layout == BillLayout.sidebar && !paper.isThermal
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: AppSpacing.sm, color: colors.brand),
              Expanded(child: body),
            ],
          )
        : body;
    return ColoredBox(
      color: colors.paper,
      child: SizedBox(width: paper.width, child: pageBody),
    );
  }
}

List<BillLine> _lines(BuildContext context) {
  final l10n = context.l10n;
  final format = studioFormat(context);
  BillLine line(String name, int qty, String unit, int price, int total) {
    final detail =
        '${format.quantity(qty)} $unit × ${format.currency(price, 'BDT')}';
    return BillLine(name: name, detail: detail, totalMinor: total);
  }

  final first = [
    line(l10n.studioItemLogo, 1000, l10n.studioUnitPiece, 500000, 500000),
    line(l10n.studioLineLong, 1000, l10n.studioUnitJob, 1200000, 1200000),
    line(l10n.studioItemConsulting, 2500, l10n.studioUnitHour, 120000, 270000),
    line(l10n.studioItemDelivery, 1000, l10n.studioUnitJob, 50000, 50000),
  ];
  return [...first, ...first];
}

class _Buyer extends StatelessWidget {
  const _Buyer({required this.colors});

  final BillColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.studioBillTo,
            style: context.studioType.label(colors.muted),
          ),
          Text(
            StudioDemo.editorClient,
            style: context.studioType.label(colors.ink),
          ),
        ],
      ),
    );
  }
}

class _Dates extends StatelessWidget {
  const _Dates({required this.colors});

  final BillColors colors;

  @override
  Widget build(BuildContext context) {
    final format = studioFormat(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: _DateBox(
              label: context.l10n.fieldIssueDate,
              value: format.date(DateTime(2026, 10, 21)),
              colors: colors,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _DateBox(
              label: context.l10n.fieldDueDate,
              value: format.date(DateTime(2026, 11, 4)),
              colors: colors,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({
    required this.label,
    required this.value,
    required this.colors,
  });

  final String label;
  final String value;
  final BillColors colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.soft,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: context.studioType.label(colors.muted)),
            Text(value, style: context.studioType.label(colors.ink)),
          ],
        ),
      ),
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.colors, required this.lines});

  final BillColors colors;
  final List<BillLine> lines;

  @override
  Widget build(BuildContext context) {
    final subtotal = lines.fold<int>(0, (sum, line) => sum + line.totalMinor);
    final tax = (subtotal * 15) ~/ 100;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Column(
        children: [
          _Row(
            label: context.l10n.totalSubtotal,
            minor: subtotal,
            colors: colors,
          ),
          _Row(
            label: context.l10n.totalTax(studioFormat(context).percent(1500)),
            minor: tax,
            colors: colors,
          ),
          _Row(
            label: context.l10n.totalTotal,
            minor: subtotal + tax,
            colors: colors,
            strong: true,
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.minor,
    required this.colors,
    this.strong = false,
  });

  final String label;
  final int minor;
  final BillColors colors;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final color = strong ? colors.onBrand : colors.ink;
    return ColoredBox(
      color: strong ? colors.brand : colors.paper,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: context.studioType.label(color)),
            ),
            Text(
              studioMoney(context, minor),
              style: context.studioType.amountSm(color),
            ),
          ],
        ),
      ),
    );
  }
}
