import 'package:flutter/material.dart';

import 'invoice_preview_shared.dart';

/// Nordic: quiet hairlines, accent only under total.
class InvoicePreviewNordic extends StatelessWidget {
  const InvoicePreviewNordic({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: InvoicePreviewInk.paper,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: InvoicePreviewInk.mute,
                    align: CrossAxisAlignment.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(height: 0.6, color: InvoicePreviewInk.line),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: PreviewBillTo(accent: accent)),
                const PreviewMeta(),
              ],
            ),
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

/// Folio: large title masthead, soft gray table head.
class InvoicePreviewFolio extends StatelessWidget {
  const InvoicePreviewFolio({required this.accent, super.key});

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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: PreviewTitleBlock(
                    color: InvoicePreviewInk.ink,
                    align: CrossAxisAlignment.start,
                  ),
                ),
                const SizedBox(width: 6),
                const PreviewMeta(),
              ],
            ),
            const SizedBox(height: 5),
            Container(height: 1, color: InvoicePreviewInk.line),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: PreviewSellerBlock(
                    nameColor: InvoicePreviewInk.ink,
                    detailColor: InvoicePreviewInk.mute,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(child: PreviewBillTo(accent: accent)),
              ],
            ),
            const SizedBox(height: 6),
            PreviewItemsTable(accent: accent, headerOnAccent: false),
            const SizedBox(height: 6),
            PreviewTotals(accent: accent, filledGrand: false),
            const Spacer(),
            const PreviewSignature(),
          ],
        ),
      ),
    );
  }
}

/// Atelier: thin left rail + soft info wash.
class InvoicePreviewAtelier extends StatelessWidget {
  const InvoicePreviewAtelier({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: InvoicePreviewInk.paper,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 4,
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PreviewTitleBlock(
                          color: InvoicePreviewInk.ink,
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
                  Container(
                    padding: const EdgeInsets.all(5),
                    color: accent.withValues(alpha: 0.08),
                    child: Row(
                      children: [
                        Expanded(child: PreviewBillTo(accent: accent)),
                        const PreviewMeta(align: CrossAxisAlignment.start),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  PreviewItemsTable(accent: accent, headerOnAccent: false),
                  const SizedBox(height: 6),
                  PreviewTotals(accent: accent, filledGrand: false),
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

/// Lumen: soft wash hero with thin accent edge.
class InvoicePreviewLumen extends StatelessWidget {
  const InvoicePreviewLumen({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: InvoicePreviewInk.paper,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(3),
                border: Border(left: BorderSide(color: accent, width: 2.5)),
              ),
              padding: const EdgeInsets.fromLTRB(7, 6, 7, 6),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: InvoicePreviewInk.line),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: PreviewBillTo(accent: accent),
                  ),
                ),
                const SizedBox(width: 4),
                const Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                        BorderSide(color: InvoicePreviewInk.line),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: PreviewMeta(align: CrossAxisAlignment.start),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            PreviewItemsTable(accent: accent, headerOnAccent: false),
            const SizedBox(height: 6),
            PreviewTotals(accent: accent, filledGrand: false),
            const Spacer(),
            const PreviewSignature(),
          ],
        ),
      ),
    );
  }
}
