import 'package:flutter/material.dart';

import '../../utils/extensions/l10n_extension.dart';
import 'invoice_preview_sample.dart';

/// Tiny print-like type for the unscaled A4 preview (~200px wide).
abstract final class InvoicePreviewType {
  static TextStyle title(Color c) => TextStyle(
    color: c,
    fontSize: 13,
    fontWeight: FontWeight.w800,
    height: 1.1,
    letterSpacing: 0.4,
  );

  static TextStyle heading(Color c) => TextStyle(
    color: c,
    fontSize: 8,
    fontWeight: FontWeight.w700,
    height: 1.15,
  );

  static TextStyle body(Color c) => TextStyle(
    color: c,
    fontSize: 6.5,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  static TextStyle label(Color c) => TextStyle(
    color: c,
    fontSize: 5.5,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.3,
  );

  static TextStyle amount(Color c) => TextStyle(
    color: c,
    fontSize: 7,
    fontWeight: FontWeight.w700,
    height: 1.15,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}

abstract final class InvoicePreviewInk {
  static const Color ink = Color(0xFF1A2332);
  static const Color mute = Color(0xFF6B7280);
  static const Color line = Color(0xFFE5E7EB);
  static const Color wash = Color(0xFFF3F4F6);
  static const Color paper = Color(0xFFFFFFFF);
}

class PreviewSellerBlock extends StatelessWidget {
  const PreviewSellerBlock({
    required this.nameColor,
    required this.detailColor,
    this.align = CrossAxisAlignment.start,
    super.key,
  });

  final Color nameColor;
  final Color detailColor;
  final CrossAxisAlignment align;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          InvoicePreviewSample.seller,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: InvoicePreviewType.heading(nameColor),
        ),
        const SizedBox(height: 2),
        Text(
          InvoicePreviewSample.sellerDetail,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: InvoicePreviewType.body(detailColor),
        ),
      ],
    );
  }
}

class PreviewTitleBlock extends StatelessWidget {
  const PreviewTitleBlock({
    required this.color,
    this.align = CrossAxisAlignment.end,
    this.onBrand = false,
    super.key,
  });

  final Color color;
  final CrossAxisAlignment align;
  final bool onBrand;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          context.l10n.pdfInvoiceTitle.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: InvoicePreviewType.title(color),
        ),
        const SizedBox(height: 2),
        Text(
          InvoicePreviewSample.number,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: InvoicePreviewType.heading(
            onBrand ? color : InvoicePreviewInk.ink,
          ),
        ),
      ],
    );
  }
}

class PreviewBillTo extends StatelessWidget {
  const PreviewBillTo({
    required this.accent,
    this.nameColor = InvoicePreviewInk.ink,
    this.detailColor = InvoicePreviewInk.mute,
    super.key,
  });

  final Color accent;
  final Color nameColor;
  final Color detailColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.sectionBillTo.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: InvoicePreviewType.label(accent),
        ),
        const SizedBox(height: 2),
        Text(
          InvoicePreviewSample.buyer,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: InvoicePreviewType.heading(nameColor),
        ),
        Text(
          InvoicePreviewSample.buyerDetail,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: InvoicePreviewType.body(detailColor),
        ),
      ],
    );
  }
}

class PreviewMeta extends StatelessWidget {
  const PreviewMeta({
    this.align = CrossAxisAlignment.end,
    this.color = InvoicePreviewInk.mute,
    super.key,
  });

  final CrossAxisAlignment align;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          '${l10n.fieldIssueDate}: ${InvoicePreviewSample.issueDate}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: InvoicePreviewType.body(color),
        ),
        const SizedBox(height: 2),
        Text(
          '${l10n.fieldDueDate}: ${InvoicePreviewSample.dueDate}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: InvoicePreviewType.body(color),
        ),
      ],
    );
  }
}

class PreviewItemsTable extends StatelessWidget {
  const PreviewItemsTable({
    required this.accent,
    this.headerOnAccent = true,
    super.key,
  });

  final Color accent;
  final bool headerOnAccent;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final headColor = headerOnAccent
        ? InvoicePreviewInk.paper
        : InvoicePreviewInk.ink;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          color: headerOnAccent ? accent : InvoicePreviewInk.wash,
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  l10n.pdfColItem,
                  style: InvoicePreviewType.label(headColor),
                ),
              ),
              Expanded(
                child: Text(
                  l10n.pdfColQty,
                  textAlign: TextAlign.center,
                  style: InvoicePreviewType.label(headColor),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  l10n.pdfColAmount,
                  textAlign: TextAlign.right,
                  style: InvoicePreviewType.label(headColor),
                ),
              ),
            ],
          ),
        ),
        for (final line in InvoicePreviewSample.lines)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: InvoicePreviewInk.line)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    line.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: InvoicePreviewType.body(InvoicePreviewInk.ink),
                  ),
                ),
                Expanded(
                  child: Text(
                    line.qty,
                    textAlign: TextAlign.center,
                    style: InvoicePreviewType.body(InvoicePreviewInk.mute),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    line.amount,
                    textAlign: TextAlign.right,
                    style: InvoicePreviewType.amount(InvoicePreviewInk.ink),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class PreviewTotals extends StatelessWidget {
  const PreviewTotals({
    required this.accent,
    this.filledGrand = true,
    this.textColor = InvoicePreviewInk.ink,
    this.grandTextColor,
    super.key,
  });

  final Color accent;
  final bool filledGrand;

  /// Subtotal and tax values; labels are a softer version of it.
  final Color textColor;

  /// The total row's text; defaults to white on a filled bar.
  final Color? grandTextColor;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 110,
        child: Column(
          children: [
            _TotalRow(
              label: l10n.totalSubtotal,
              value: InvoicePreviewSample.subtotal,
              color: textColor,
            ),
            _TotalRow(
              label: l10n.totalTax('5%'),
              value: InvoicePreviewSample.tax,
              color: textColor,
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              decoration: BoxDecoration(
                color: filledGrand ? accent : null,
                border: filledGrand
                    ? null
                    : Border(top: BorderSide(color: accent, width: 1.5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.totalTotal,
                      style: InvoicePreviewType.heading(
                        grandTextColor ??
                            (filledGrand ? InvoicePreviewInk.paper : accent),
                      ),
                    ),
                  ),
                  Text(
                    InvoicePreviewSample.total,
                    style: InvoicePreviewType.amount(
                      grandTextColor ??
                          (filledGrand ? InvoicePreviewInk.paper : accent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: InvoicePreviewType.label(color.withValues(alpha: 0.7)),
            ),
          ),
          Text(value, style: InvoicePreviewType.amount(color)),
        ],
      ),
    );
  }
}

class PreviewSignature extends StatelessWidget {
  const PreviewSignature({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 56, height: 1, color: InvoicePreviewInk.mute),
        const SizedBox(height: 2),
        Text(
          context.l10n.pdfSignature,
          style: InvoicePreviewType.label(InvoicePreviewInk.mute),
        ),
      ],
    );
  }
}
