import 'package:flutter/material.dart';

import '../../services/pdf/canvas/art_tones.dart';
import '../../services/pdf/canvas/canvas_design.dart';
import 'canvas_art_painter.dart';
import 'canvas_head_painter.dart';
import 'invoice_preview_shared.dart';

/// Gallery preview of a logo-header canvas design (brand, card or clean):
/// logo and seller beside the title, then the sample invoice.
class InvoicePreviewLogoHead extends StatelessWidget {
  const InvoicePreviewLogoHead({
    required this.design,
    required this.tones,
    required this.accent,
    super.key,
  });

  final CanvasDesign design;
  final ArtTones tones;
  final Color accent;

  /// Preview pixels per millimetre (a 210 mm page is 200 px wide).
  static const double _perMm = 200 / 210;
  static const double _gap = 6;

  @override
  Widget build(BuildContext context) {
    final side = design.marginSideMm * _perMm;
    final top = design.marginTopMm * _perMm;
    final edge = design.edgeMm * _perMm;
    final skeleton = design.skeleton;
    final isCard = skeleton == CanvasSkeleton.card;
    final head = Padding(
      padding: EdgeInsets.fromLTRB(side, top, side, edge + _gap),
      child: _Head(design: design, accent: accent),
    );
    final body = _Body(
      accent: accent,
      tableHead: CanvasArtPainter.colorOf(tones.deep),
      clean: skeleton == CanvasSkeleton.clean,
      fill: !isCard,
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: CanvasArtPainter(design: design, tones: tones),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (skeleton == CanvasSkeleton.brand)
              CustomPaint(
                painter: CanvasHeadPainter(
                  design: design,
                  tones: tones,
                  edgeHeight: edge,
                ),
                child: head,
              )
            else
              head,
            if (isCard)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: side),
                child: _Card(child: body),
              )
            else
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    side,
                    _gap,
                    side,
                    design.marginBottomMm * _perMm * 0.6,
                  ),
                  child: body,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _Head extends StatelessWidget {
  const _Head({required this.design, required this.accent});

  final CanvasDesign design;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    const white = InvoicePreviewInk.paper;
    final clean = design.skeleton == CanvasSkeleton.clean;
    final darkSeller = clean || design.headInk;
    return Row(
      children: [
        _LogoTile(accent: accent, framed: !clean),
        const SizedBox(width: 5),
        Expanded(
          child: PreviewSellerBlock(
            nameColor: darkSeller ? InvoicePreviewInk.ink : white,
            detailColor: darkSeller
                ? InvoicePreviewInk.mute
                : white.withValues(alpha: 0.85),
          ),
        ),
        PreviewTitleBlock(color: clean ? accent : white, onBrand: !clean),
      ],
    );
  }
}

/// Stands in for the business logo: a mark on a white tile.
class _LogoTile extends StatelessWidget {
  const _LogoTile({required this.accent, required this.framed});

  final Color accent;
  final bool framed;

  static const double _size = 20;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      padding: EdgeInsets.all(framed ? 2.5 : 0),
      decoration: BoxDecoration(
        color: InvoicePreviewInk.paper,
        borderRadius: BorderRadius.circular(3),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: accent,
          borderRadius: BorderRadius.circular(2),
        ),
        child: const Center(
          child: Icon(Icons.bolt, size: 11, color: InvoicePreviewInk.paper),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: InvoicePreviewInk.paper,
        borderRadius: BorderRadius.circular(4),
      ),
      child: child,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.accent,
    required this.tableHead,
    required this.clean,
    required this.fill,
  });

  final Color accent;
  final Color tableHead;

  /// Line-only table head and total, as the clean skeleton prints them.
  final bool clean;

  /// Push the signature to the foot of the page.
  final bool fill;

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 6);
    return Column(
      mainAxisSize: fill ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: PreviewBillTo(accent: accent)),
            const PreviewMeta(),
          ],
        ),
        gap,
        ColoredBox(
          color: InvoicePreviewInk.paper,
          child: PreviewItemsTable(
            accent: clean ? accent : tableHead,
            headerOnAccent: !clean,
          ),
        ),
        gap,
        PreviewTotals(accent: accent, filledGrand: !clean),
        if (fill) const Spacer() else gap,
        const PreviewSignature(),
      ],
    );
  }
}
