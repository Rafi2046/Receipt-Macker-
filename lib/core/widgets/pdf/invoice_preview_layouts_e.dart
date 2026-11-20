import 'package:flutter/material.dart';

import 'invoice_preview_premium.dart';
import 'invoice_preview_sample.dart';
import 'invoice_preview_shared.dart';

const _white = PreviewTones.onDark;

/// Orbit: overlapping circles in the corner, oversized title.
class InvoicePreviewOrbit extends StatelessWidget {
  const InvoicePreviewOrbit({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tones = PreviewTones.of(accent);
    Widget dot(double size, Color color) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
    return Stack(
      children: [
        Positioned(top: -44, right: -26, child: dot(88, accent)),
        Positioned(top: 16, right: 44, child: dot(34, tones.pair)),
        Positioned.fill(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 14, 8, 18),
                child: PreviewTitleBlock(
                  color: tones.deep,
                  align: CrossAxisAlignment.start,
                ),
              ),
              Expanded(
                child: PreviewBody(accent: accent, headerOnAccent: false),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Ribbon: title on a swallow-tail ribbon from the page edge.
class InvoicePreviewRibbon extends StatelessWidget {
  const InvoicePreviewRibbon({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tones = PreviewTones.of(accent);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipPath(
                clipper: const PreviewEdgeClipper.tail(),
                child: Container(
                  color: accent,
                  padding: const EdgeInsets.fromLTRB(8, 5, 16, 5),
                  child: const PreviewTitleBlock(
                    color: _white,
                    onBrand: true,
                    align: CrossAxisAlignment.start,
                  ),
                ),
              ),
              const Spacer(),
              PreviewSellerBlock(
                nameColor: tones.deep,
                detailColor: InvoicePreviewInk.mute,
                align: CrossAxisAlignment.end,
              ),
            ],
          ),
        ),
        Expanded(
          child: PreviewBody(
            accent: accent,
            headerOnAccent: false,
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
          ),
        ),
      ],
    );
  }
}

/// Onyx: black header and bars, thin brand highlights.
class InvoicePreviewOnyx extends StatelessWidget {
  const InvoicePreviewOnyx({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: PreviewTones.onyx,
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PreviewTitleBlock(
                      color: _white,
                      onBrand: true,
                      align: CrossAxisAlignment.start,
                    ),
                    const SizedBox(height: 3),
                    Container(width: 22, height: 2.5, color: accent),
                  ],
                ),
              ),
              PreviewSellerBlock(
                nameColor: _white,
                detailColor: _white.withValues(alpha: 0.7),
                align: CrossAxisAlignment.end,
              ),
            ],
          ),
        ),
        Container(height: 2, color: accent),
        const Expanded(
          child: PreviewBody(
            accent: InvoicePreviewInk.ink,
            tableColor: PreviewTones.onyx,
          ),
        ),
      ],
    );
  }
}

/// Metro: flat color tiles for title, amount and dates.
class InvoicePreviewMetro extends StatelessWidget {
  const InvoicePreviewMetro({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tones = PreviewTones.of(accent);
    Widget tile(Color color, Widget child, {int flex = 5}) => Expanded(
      flex: flex,
      child: Container(
        height: 46,
        color: color,
        padding: const EdgeInsets.all(5),
        alignment: Alignment.bottomLeft,
        child: child,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Row(
            spacing: 2,
            children: [
              tile(
                accent,
                const PreviewTitleBlock(
                  color: _white,
                  onBrand: true,
                  align: CrossAxisAlignment.start,
                ),
                flex: 6,
              ),
              tile(
                tones.deep,
                Text(
                  InvoicePreviewSample.total,
                  style: InvoicePreviewType.heading(_white),
                ),
                flex: 4,
              ),
              tile(
                tones.soft,
                const PreviewMeta(align: CrossAxisAlignment.start),
                flex: 6,
              ),
            ],
          ),
        ),
        Expanded(child: PreviewBody(accent: accent)),
      ],
    );
  }
}

/// Regal: centered letterhead inside a fine double frame.
class InvoicePreviewRegal extends StatelessWidget {
  const InvoicePreviewRegal({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tones = PreviewTones.of(accent);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          padding: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(border: Border.all(color: accent)),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: tones.pair, width: 0.6),
            ),
            child: Column(
              children: [
                PreviewSellerBlock(
                  nameColor: accent,
                  detailColor: InvoicePreviewInk.mute,
                  align: CrossAxisAlignment.center,
                ),
                Container(
                  width: 46,
                  height: 0.8,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: tones.pair,
                ),
                const PreviewTitleBlock(
                  color: InvoicePreviewInk.ink,
                  align: CrossAxisAlignment.center,
                ),
              ],
            ),
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
