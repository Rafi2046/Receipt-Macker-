import 'package:flutter/material.dart';

import '../../services/pdf/canvas/art_tones.dart';
import '../../services/pdf/canvas/canvas_design.dart';
import 'canvas_art_painter.dart';
import 'invoice_preview_shared.dart';

/// Gallery preview of a canvas design: the full-page art with the sample
/// invoice laid over it, in the skeleton's colors.
class InvoicePreviewCanvas extends StatelessWidget {
  const InvoicePreviewCanvas({
    required this.design,
    required this.accent,
    super.key,
  });

  final CanvasDesign design;
  final Color accent;

  /// Preview pixels per millimetre (a 210 mm page is 200 px wide).
  static const double _perMm = 200 / 210;

  @override
  Widget build(BuildContext context) {
    final rgb = accent.toARGB32() & 0xFFFFFF;
    final tones = ArtTones('#${rgb.toRadixString(16).padLeft(6, '0')}');
    final colors = _CanvasColors.of(design.skeleton, tones, accent);
    final side = design.marginSideMm * _perMm;
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: CanvasArtPainter(design: design, tones: tones),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            side,
            design.marginTopMm * _perMm,
            side,
            design.marginBottomMm * _perMm * 0.6,
          ),
          child: _Content(
            colors: colors,
            headHeight: design.headHeightMm * _perMm,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.colors, required this.headHeight});

  final _CanvasColors colors;
  final double headHeight;

  @override
  Widget build(BuildContext context) {
    final c = colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: headHeight),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PreviewTitleBlock(
                  color: c.title,
                  onBrand: c.titleOnColor,
                  align: CrossAxisAlignment.start,
                ),
              ),
              PreviewMeta(color: c.meta),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PreviewSellerBlock(nameColor: c.text, detailColor: c.soft),
            ),
            Expanded(
              child: PreviewBillTo(
                accent: c.label,
                nameColor: c.text,
                detailColor: c.soft,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ColoredBox(
          color: InvoicePreviewInk.paper,
          child: PreviewItemsTable(accent: c.tableHead),
        ),
        const SizedBox(height: 6),
        PreviewTotals(
          accent: c.grand,
          textColor: c.text,
          grandTextColor: c.grandText,
        ),
        const Spacer(),
        const PreviewSignature(),
      ],
    );
  }
}

/// The colors of each skeleton, matching `CanvasCss`.
class _CanvasColors {
  const _CanvasColors({
    required this.title,
    required this.titleOnColor,
    required this.meta,
    required this.text,
    required this.soft,
    required this.label,
    required this.tableHead,
    required this.grand,
    required this.grandText,
  });

  factory _CanvasColors.of(
    CanvasSkeleton skeleton,
    ArtTones tones,
    Color accent,
  ) {
    final deep = _parse(tones.deep);
    const white = InvoicePreviewInk.paper;
    final whiteSoft = white.withValues(alpha: 0.75);
    return switch (skeleton) {
      CanvasSkeleton.sheet || CanvasSkeleton.band => _CanvasColors(
        title: skeleton == CanvasSkeleton.band ? white : accent,
        titleOnColor: skeleton == CanvasSkeleton.band,
        meta: skeleton == CanvasSkeleton.band
            ? whiteSoft
            : InvoicePreviewInk.mute,
        text: InvoicePreviewInk.ink,
        soft: InvoicePreviewInk.mute,
        label: accent,
        tableHead: deep,
        grand: accent,
        grandText: white,
      ),
      CanvasSkeleton.dark => _CanvasColors(
        title: _parse(tones.highlight),
        titleOnColor: false,
        meta: whiteSoft,
        text: white,
        soft: whiteSoft,
        label: _parse(tones.highlight),
        tableHead: accent,
        grand: _parse(tones.highlight),
        grandText: InvoicePreviewInk.ink,
      ),
    };
  }

  final Color title;
  final bool titleOnColor;
  final Color meta;
  final Color text;
  final Color soft;
  final Color label;
  final Color tableHead;
  final Color grand;
  final Color grandText;

  static Color _parse(String hex) {
    final rgb = int.tryParse(
      hex.replaceAll('#', '').substring(0, 6),
      radix: 16,
    );
    return Color(0xFF000000 | (rgb ?? 0));
  }
}
