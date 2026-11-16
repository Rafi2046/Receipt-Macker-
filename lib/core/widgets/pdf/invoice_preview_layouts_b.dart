import 'package:flutter/material.dart';

import 'invoice_preview_sample.dart';
import 'invoice_preview_shared.dart';

/// Studio: thick left accent rail.
class InvoicePreviewStudio extends StatelessWidget {
  const InvoicePreviewStudio({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: InvoicePreviewInk.paper,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(width: 10, color: accent),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(7, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PreviewTitleBlock(
                          color: accent,
                          align: CrossAxisAlignment.start,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: PreviewSellerBlock(
                          nameColor: InvoicePreviewInk.ink,
                          detailColor: InvoicePreviewInk.mute,
                          align: CrossAxisAlignment.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  PreviewBillTo(accent: accent),
                  const SizedBox(height: 4),
                  const PreviewMeta(),
                  const SizedBox(height: 6),
                  PreviewItemsTable(accent: accent),
                  const SizedBox(height: 6),
                  PreviewTotals(accent: accent),
                  const Spacer(),
                  const PreviewSignature(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Editorial: centered masthead with double accent rules.
class InvoicePreviewEditorial extends StatelessWidget {
  const InvoicePreviewEditorial({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: InvoicePreviewInk.paper,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 2.5, color: accent),
            const SizedBox(height: 2),
            Container(height: 1, color: accent.withValues(alpha: 0.45)),
            const SizedBox(height: 8),
            PreviewTitleBlock(
              color: InvoicePreviewInk.ink,
              align: CrossAxisAlignment.center,
            ),
            const SizedBox(height: 4),
            PreviewSellerBlock(
              nameColor: InvoicePreviewInk.ink,
              detailColor: InvoicePreviewInk.mute,
              align: CrossAxisAlignment.center,
            ),
            const SizedBox(height: 6),
            Container(height: 1, color: InvoicePreviewInk.line),
            const SizedBox(height: 6),
            PreviewBillTo(accent: accent),
            const SizedBox(height: 6),
            PreviewItemsTable(accent: accent),
            const SizedBox(height: 6),
            PreviewTotals(accent: accent),
            const Spacer(),
            Container(height: 1, color: accent.withValues(alpha: 0.45)),
            const SizedBox(height: 2),
            Container(height: 2.5, color: accent),
            const SizedBox(height: 4),
            const PreviewSignature(),
          ],
        ),
      ),
    );
  }
}

/// Compact: dense accent strip + tight rows.
class InvoicePreviewCompact extends StatelessWidget {
  const InvoicePreviewCompact({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: InvoicePreviewInk.paper,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: accent,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: PreviewSellerBlock(
                    nameColor: InvoicePreviewInk.paper,
                    detailColor: InvoicePreviewInk.paper.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: PreviewTitleBlock(
                    color: InvoicePreviewInk.paper,
                    onBrand: true,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 5, 6, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PreviewBillTo(accent: InvoicePreviewInk.ink),
                      ),
                      PreviewMeta(),
                    ],
                  ),
                  const SizedBox(height: 4),
                  PreviewItemsTable(accent: accent),
                  const SizedBox(height: 4),
                  PreviewTotals(accent: accent),
                  const Spacer(),
                  const PreviewSignature(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ledger: bordered split header + accent footer band.
class InvoicePreviewLedger extends StatelessWidget {
  const InvoicePreviewLedger({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: InvoicePreviewInk.paper,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: InvoicePreviewInk.mute, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: PreviewSellerBlock(
                          nameColor: accent,
                          detailColor: InvoicePreviewInk.mute,
                        ),
                      ),
                    ),
                    Container(width: 1, color: InvoicePreviewInk.mute),
                    Expanded(
                      child: Container(
                        color: InvoicePreviewInk.wash,
                        padding: const EdgeInsets.all(5),
                        child: PreviewTitleBlock(
                          color: InvoicePreviewInk.ink,
                          align: CrossAxisAlignment.start,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: InvoicePreviewInk.mute),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PreviewBillTo(accent: accent),
                      const SizedBox(height: 4),
                      PreviewItemsTable(accent: accent),
                      const SizedBox(height: 4),
                      PreviewTotals(accent: accent),
                      const Spacer(),
                      const PreviewSignature(),
                    ],
                  ),
                ),
              ),
              Container(
                height: 14,
                color: accent.withValues(alpha: 0.2),
                alignment: Alignment.center,
                child: Text(
                  InvoicePreviewSample.total,
                  style: InvoicePreviewType.amount(accent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
