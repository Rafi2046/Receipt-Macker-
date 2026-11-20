import 'package:flutter/material.dart';

import 'invoice_preview_premium.dart';
import 'invoice_preview_sample.dart';
import 'invoice_preview_shared.dart';

const _white = PreviewTones.onDark;

/// Duo: header split into a soft half and a solid half.
class InvoicePreviewDuo extends StatelessWidget {
  const InvoicePreviewDuo({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tones = PreviewTones.of(accent);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 58,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  color: tones.soft,
                  padding: const EdgeInsets.fromLTRB(8, 10, 4, 0),
                  child: PreviewSellerBlock(
                    nameColor: tones.deep,
                    detailColor: InvoicePreviewInk.mute,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(6, 10, 8, 0),
                  decoration: BoxDecoration(
                    color: accent,
                    border: Border(
                      bottom: BorderSide(color: tones.pair, width: 2.5),
                    ),
                  ),
                  child: const PreviewTitleBlock(
                    color: _white,
                    onBrand: true,
                    align: CrossAxisAlignment.start,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: PreviewBody(
            accent: accent,
            headerOnAccent: false,
            filledGrand: false,
          ),
        ),
      ],
    );
  }
}

/// Halo: soft rounded cards and pill bars.
class InvoicePreviewHalo extends StatelessWidget {
  const InvoicePreviewHalo({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tones = PreviewTones.of(accent);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: tones.soft,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PreviewSellerBlock(
                  nameColor: tones.deep,
                  detailColor: InvoicePreviewInk.mute,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  InvoicePreviewSample.number,
                  style: InvoicePreviewType.heading(_white),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: PreviewBody(accent: accent)),
      ],
    );
  }
}

/// Pinstripe: three-tone stripe and a light oversized title.
class InvoicePreviewPinstripe extends StatelessWidget {
  const InvoicePreviewPinstripe({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tones = PreviewTones.of(accent);
    Widget stripe(Color color, int flex) => Expanded(
      flex: flex,
      child: Container(height: 4, color: color),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            stripe(accent, 62),
            stripe(tones.pair, 12),
            stripe(tones.deep, 26),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PreviewTitleBlock(
                  color: tones.deep,
                  align: CrossAxisAlignment.start,
                ),
              ),
              const PreviewSellerBlock(
                nameColor: InvoicePreviewInk.ink,
                detailColor: InvoicePreviewInk.mute,
                align: CrossAxisAlignment.end,
              ),
            ],
          ),
        ),
        Container(
          height: 0.8,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          color: InvoicePreviewInk.ink,
        ),
        Expanded(
          child: PreviewBody(
            accent: accent,
            headerOnAccent: false,
            filledGrand: false,
          ),
        ),
      ],
    );
  }
}

/// Impact: the amount leads on a full-width banner.
class InvoicePreviewImpact extends StatelessWidget {
  const InvoicePreviewImpact({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tones = PreviewTones.of(accent);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PreviewSellerBlock(
                  nameColor: InvoicePreviewInk.ink,
                  detailColor: InvoicePreviewInk.mute,
                ),
              ),
              PreviewTitleBlock(color: InvoicePreviewInk.mute),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
          decoration: BoxDecoration(
            color: accent,
            border: Border(bottom: BorderSide(color: tones.pair, width: 2.5)),
          ),
          child: Text(
            InvoicePreviewSample.total,
            style: InvoicePreviewType.title(_white).copyWith(fontSize: 20),
          ),
        ),
        Expanded(
          child: PreviewBody(accent: accent, tableColor: tones.deep),
        ),
      ],
    );
  }
}
