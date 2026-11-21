import 'package:flutter/material.dart';

import 'invoice_preview_premium.dart';
import 'invoice_preview_sample.dart';
import 'invoice_preview_shared.dart';

const _white = PreviewTones.onDark;
final _whiteSoft = _white.withValues(alpha: 0.85);

Widget _sellerAndTitle({bool titleFirst = false}) {
  final seller = PreviewSellerBlock(
    nameColor: _white,
    detailColor: _whiteSoft,
    align: titleFirst ? CrossAxisAlignment.end : CrossAxisAlignment.start,
  );
  final title = PreviewTitleBlock(
    color: _white,
    onBrand: true,
    align: titleFirst ? CrossAxisAlignment.start : CrossAxisAlignment.end,
  );
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: titleFirst ? title : seller),
      const SizedBox(width: 6),
      Flexible(child: titleFirst ? seller : title),
    ],
  );
}

/// Aurora: gradient hero with overlapping cards.
class InvoicePreviewAurora extends StatelessWidget {
  const InvoicePreviewAurora({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tones = PreviewTones.of(accent);
    Widget card(Widget child) => Expanded(
      // A border with mixed colors cannot take a borderRadius, so the
      // rounding comes from the clip instead.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: InvoicePreviewInk.paper,
            border: Border(
              top: BorderSide(color: tones.pair, width: 2),
              bottom: const BorderSide(color: InvoicePreviewInk.line),
            ),
          ),
          child: child,
        ),
      ),
    );
    return Stack(
      children: [
        Container(
          height: 66,
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
          decoration: BoxDecoration(gradient: tones.gradient),
          child: _sellerAndTitle(),
        ),
        Positioned(
          left: 8,
          right: 8,
          top: 50,
          child: Row(
            children: [
              card(PreviewBillTo(accent: accent)),
              const SizedBox(width: 5),
              card(const PreviewMeta(align: CrossAxisAlignment.start)),
            ],
          ),
        ),
        Positioned.fill(
          top: 88,
          child: PreviewBody(
            accent: accent,
            showParties: false,
            headerOnAccent: false,
          ),
        ),
      ],
    );
  }
}

/// Prestige: dark band, centered letterhead, highlight rules.
class InvoicePreviewPrestige extends StatelessWidget {
  const InvoicePreviewPrestige({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tones = PreviewTones.of(accent);
    final rule = Expanded(child: Container(height: 0.8, color: tones.pair));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(height: 8, color: tones.deep),
        Container(height: 1.5, color: tones.pair),
        const SizedBox(height: 8),
        PreviewSellerBlock(
          nameColor: tones.deep,
          detailColor: InvoicePreviewInk.mute,
          align: CrossAxisAlignment.center,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
          child: Row(
            children: [
              rule,
              const SizedBox(width: 6),
              PreviewTitleBlock(
                color: accent,
                align: CrossAxisAlignment.center,
              ),
              const SizedBox(width: 6),
              rule,
            ],
          ),
        ),
        Expanded(
          child: PreviewBody(accent: tones.pair, tableColor: tones.deep),
        ),
      ],
    );
  }
}

/// Vertex: angled two-tone header with a slanted edge.
class InvoicePreviewVertex extends StatelessWidget {
  const InvoicePreviewVertex({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tones = PreviewTones.of(accent);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipPath(
          clipper: const PreviewEdgeClipper.slant(),
          child: Container(
            height: 62,
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(-1, -0.25),
                end: const Alignment(1, 0.25),
                colors: [
                  accent,
                  accent,
                  tones.pair,
                  tones.pair,
                  tones.deep,
                  tones.deep,
                ],
                stops: const [0, 0.52, 0.52, 0.54, 0.54, 1],
              ),
            ),
            child: _sellerAndTitle(titleFirst: true),
          ),
        ),
        Expanded(
          child: PreviewBody(accent: accent, tableColor: tones.deep),
        ),
      ],
    );
  }
}

/// Pillar: tall rounded side panel.
class InvoicePreviewPillar extends StatelessWidget {
  const InvoicePreviewPillar({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tones = PreviewTones.of(accent);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 56,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [accent, tones.deep],
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PreviewSellerBlock(nameColor: _white, detailColor: _whiteSoft),
                Container(
                  width: 14,
                  height: 1.5,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  color: tones.pair,
                ),
                Text(
                  InvoicePreviewSample.buyerText,
                  style: InvoicePreviewType.body(_white),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PreviewTitleBlock(
                  color: accent,
                  align: CrossAxisAlignment.start,
                ),
                Expanded(
                  child: PreviewBody(
                    accent: accent,
                    showParties: false,
                    headerOnAccent: false,
                    filledGrand: false,
                    padding: const EdgeInsets.only(top: 8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Crest: header ending in a double wave.
class InvoicePreviewCrest extends StatelessWidget {
  const InvoicePreviewCrest({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tones = PreviewTones.of(accent);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 66,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipPath(
                clipper: const PreviewEdgeClipper.wave(),
                child: ColoredBox(color: tones.pair),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: ClipPath(
                  clipper: const PreviewEdgeClipper.wave(),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                    decoration: BoxDecoration(gradient: tones.gradient),
                    child: _sellerAndTitle(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: PreviewBody(accent: accent, headerOnAccent: false)),
      ],
    );
  }
}
