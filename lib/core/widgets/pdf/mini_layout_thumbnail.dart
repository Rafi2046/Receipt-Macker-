import 'package:flutter/material.dart';

import '../../services/pdf/pdf_template.dart';
import 'invoice_preview_layouts_a.dart';
import 'invoice_preview_layouts_b.dart';
import 'invoice_preview_layouts_c.dart';
import 'invoice_preview_layouts_d.dart';
import 'invoice_preview_layouts_e.dart';
import 'invoice_preview_layouts_f.dart';
import 'invoice_preview_shared.dart';

/// Full sample-invoice preview for a layout + accent, scaled to [width]×[height].
/// Shows readable FROM / Bill to / lines / totals so users can pick a design.
class MiniLayoutThumbnail extends StatelessWidget {
  const MiniLayoutThumbnail({
    required this.template,
    required this.accentColor,
    this.width = 48,
    this.height = 60,
    this.framed = true,
    super.key,
  });

  /// Logical size of the unscaled A4-ish page before [FittedBox].
  static const double designWidth = 200;
  static const double designHeight = 282;

  final PdfTemplate template;
  final Color accentColor;
  final double width;
  final double height;

  /// Soft paper card chrome. Catalog tiles pass false (they frame themselves).
  final bool framed;

  @override
  Widget build(BuildContext context) {
    final page = switch (template) {
      PdfTemplate.classic => InvoicePreviewClassic(accent: accentColor),
      PdfTemplate.minimal => InvoicePreviewMinimal(accent: accentColor),
      PdfTemplate.modern => InvoicePreviewModern(accent: accentColor),
      PdfTemplate.executive => InvoicePreviewExecutive(accent: accentColor),
      PdfTemplate.studio => InvoicePreviewStudio(accent: accentColor),
      PdfTemplate.editorial => InvoicePreviewEditorial(accent: accentColor),
      PdfTemplate.compact => InvoicePreviewCompact(accent: accentColor),
      PdfTemplate.ledger => InvoicePreviewLedger(accent: accentColor),
      PdfTemplate.nordic => InvoicePreviewNordic(accent: accentColor),
      PdfTemplate.folio => InvoicePreviewFolio(accent: accentColor),
      PdfTemplate.atelier => InvoicePreviewAtelier(accent: accentColor),
      PdfTemplate.lumen => InvoicePreviewLumen(accent: accentColor),
      PdfTemplate.aurora => InvoicePreviewAurora(accent: accentColor),
      PdfTemplate.prestige => InvoicePreviewPrestige(accent: accentColor),
      PdfTemplate.vertex => InvoicePreviewVertex(accent: accentColor),
      PdfTemplate.pillar => InvoicePreviewPillar(accent: accentColor),
      PdfTemplate.crest => InvoicePreviewCrest(accent: accentColor),
      PdfTemplate.orbit => InvoicePreviewOrbit(accent: accentColor),
      PdfTemplate.ribbon => InvoicePreviewRibbon(accent: accentColor),
      PdfTemplate.onyx => InvoicePreviewOnyx(accent: accentColor),
      PdfTemplate.metro => InvoicePreviewMetro(accent: accentColor),
      PdfTemplate.regal => InvoicePreviewRegal(accent: accentColor),
      PdfTemplate.duo => InvoicePreviewDuo(accent: accentColor),
      PdfTemplate.halo => InvoicePreviewHalo(accent: accentColor),
      PdfTemplate.pinstripe => InvoicePreviewPinstripe(accent: accentColor),
      PdfTemplate.impact => InvoicePreviewImpact(accent: accentColor),
    };

    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: InvoicePreviewInk.paper,
        borderRadius: BorderRadius.circular(framed ? 6 : 4),
        border: framed ? Border.all(color: const Color(0xFFDCE2E8)) : null,
        boxShadow: framed
            ? const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: designWidth,
          height: designHeight,
          child: ClipRect(
            child: ColoredBox(color: InvoicePreviewInk.paper, child: page),
          ),
        ),
      ),
    );
  }
}
