import 'package:flutter/material.dart';

import 'invoice_preview_shared.dart';

/// Classic: seller left, accent title right, accent table + total.
class InvoicePreviewClassic extends StatelessWidget {
  const InvoicePreviewClassic({required this.accent, super.key});

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: PreviewSellerBlock(
                    nameColor: accent,
                    detailColor: InvoicePreviewInk.mute,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(child: PreviewTitleBlock(color: accent)),
              ],
            ),
            const SizedBox(height: 4),
            Container(height: 1.5, color: accent),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: PreviewBillTo(accent: accent)),
                const PreviewMeta(),
              ],
            ),
            const SizedBox(height: 6),
            PreviewItemsTable(accent: accent),
            const SizedBox(height: 6),
            PreviewTotals(accent: accent),
            const Spacer(),
            const PreviewSignature(),
          ],
        ),
      ),
    );
  }
}

/// Minimal: sparse rules, no filled header.
class InvoicePreviewMinimal extends StatelessWidget {
  const InvoicePreviewMinimal({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: InvoicePreviewInk.paper,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Expanded(
                  child: PreviewSellerBlock(
                    nameColor: InvoicePreviewInk.ink,
                    detailColor: InvoicePreviewInk.mute,
                  ),
                ),
                SizedBox(width: 6),
                Flexible(
                  child: PreviewTitleBlock(
                    color: InvoicePreviewInk.ink,
                    align: CrossAxisAlignment.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(height: 1, color: InvoicePreviewInk.ink),
            const SizedBox(height: 8),
            PreviewBillTo(accent: accent),
            const SizedBox(height: 4),
            const PreviewMeta(),
            const SizedBox(height: 8),
            PreviewItemsTable(accent: accent, headerOnAccent: false),
            const SizedBox(height: 8),
            PreviewTotals(accent: accent, filledGrand: false),
            const Spacer(),
            const PreviewSignature(),
          ],
        ),
      ),
    );
  }
}

/// Modern: accent top bar, soft bill-to box.
class InvoicePreviewModern extends StatelessWidget {
  const InvoicePreviewModern({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: InvoicePreviewInk.paper,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 6, color: accent),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PreviewTitleBlock(
                          color: InvoicePreviewInk.ink,
                          align: CrossAxisAlignment.start,
                        ),
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: PreviewSellerBlock(
                          nameColor: InvoicePreviewInk.ink,
                          detailColor: InvoicePreviewInk.mute,
                          align: CrossAxisAlignment.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          color: accent.withValues(alpha: 0.12),
                          child: PreviewBillTo(accent: accent),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Expanded(
                        child: ColoredBox(
                          color: InvoicePreviewInk.wash,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: PreviewMeta(align: CrossAxisAlignment.start),
                          ),
                        ),
                      ),
                    ],
                  ),
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

/// Executive: tall accent brand header.
class InvoicePreviewExecutive extends StatelessWidget {
  const InvoicePreviewExecutive({required this.accent, super.key});

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
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PreviewSellerBlock(
                  nameColor: InvoicePreviewInk.paper,
                  detailColor: InvoicePreviewInk.paper.withValues(alpha: 0.85),
                ),
                const SizedBox(height: 6),
                PreviewTitleBlock(
                  color: InvoicePreviewInk.paper,
                  align: CrossAxisAlignment.start,
                ),
              ],
            ),
          ),
          Container(height: 3, color: accent.withValues(alpha: 0.55)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
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
