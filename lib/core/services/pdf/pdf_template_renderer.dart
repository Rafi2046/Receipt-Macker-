import 'dart:convert';

import 'brand_swatch.dart';
import 'canvas/canvas_designs.dart';
import 'canvas/canvas_template.dart';
import 'models/pdf_document.dart';
import 'pdf_blocks.dart';
import 'pdf_html.dart';
import 'pdf_page_size.dart';
import 'pdf_palette.dart';
import 'pdf_template.dart';
import 'templates/atelier_template.dart';
import 'templates/aurora_template.dart';
import 'templates/classic_template.dart';
import 'templates/compact_template.dart';
import 'templates/crest_template.dart';
import 'templates/duo_template.dart';
import 'templates/editorial_template.dart';
import 'templates/executive_template.dart';
import 'templates/folio_template.dart';
import 'templates/halo_template.dart';
import 'templates/impact_template.dart';
import 'templates/ledger_template.dart';
import 'templates/lumen_template.dart';
import 'templates/metro_template.dart';
import 'templates/minimal_template.dart';
import 'templates/modern_template.dart';
import 'templates/nordic_template.dart';
import 'templates/onyx_template.dart';
import 'templates/orbit_template.dart';
import 'templates/pillar_template.dart';
import 'templates/pinstripe_template.dart';
import 'templates/prestige_template.dart';
import 'templates/regal_template.dart';
import 'templates/ribbon_template.dart';
import 'templates/studio_template.dart';
import 'templates/vertex_template.dart';

/// Turns a [PdfDocument] into HTML with the chosen template and accent color.
abstract final class PdfTemplateRenderer {
  static String render(
    PdfTemplate template,
    PdfDocument doc, {
    required String fontsCss,
    PdfPageSize size = PdfPageSize.a4,
    String? footer,
    String? accentColor,
  }) {
    final hex = accentColor ?? BrandSwatch.coral.hex;
    final soft = BrandSwatch.softFor(hex);

    // Premium layouts share their base CSS and sections (PdfBlocks).
    String premium(String css, String body) => PdfHtml.page(
      doc: doc,
      fontsCss: fontsCss,
      templateCss: '${PdfBlocks.css}$css',
      size: size,
      accentColor: hex,
      accentSoftColor: soft,
      body: body,
    );

    final canvas = CanvasDesigns.of(template);
    final html = canvas != null
        ? CanvasTemplate.render(
            canvas,
            doc,
            fontsCss: fontsCss,
            size: size,
            accentColor: hex,
            accentSoftColor: soft,
          )
        : switch (template) {
            PdfTemplate.classic => ClassicTemplate.render(
              doc,
              fontsCss: fontsCss,
              size: size,
              accentColor: hex,
              accentSoftColor: soft,
            ),
            PdfTemplate.modern => ModernTemplate.render(
              doc,
              fontsCss: fontsCss,
              size: size,
              accentColor: hex,
              accentSoftColor: soft,
            ),
            PdfTemplate.minimal => MinimalTemplate.render(
              doc,
              fontsCss: fontsCss,
              size: size,
              accentColor: hex,
              accentSoftColor: soft,
            ),
            PdfTemplate.executive => ExecutiveTemplate.render(
              doc,
              fontsCss: fontsCss,
              size: size,
              accentColor: hex,
              accentSoftColor: soft,
            ),
            PdfTemplate.studio => StudioTemplate.render(
              doc,
              fontsCss: fontsCss,
              size: size,
              accentColor: hex,
              accentSoftColor: soft,
            ),
            PdfTemplate.editorial => EditorialTemplate.render(
              doc,
              fontsCss: fontsCss,
              size: size,
              accentColor: hex,
              accentSoftColor: soft,
            ),
            PdfTemplate.compact => CompactTemplate.render(
              doc,
              fontsCss: fontsCss,
              size: size,
              accentColor: hex,
              accentSoftColor: soft,
            ),
            PdfTemplate.ledger => LedgerTemplate.render(
              doc,
              fontsCss: fontsCss,
              size: size,
              accentColor: hex,
              accentSoftColor: soft,
            ),
            PdfTemplate.nordic => NordicTemplate.render(
              doc,
              fontsCss: fontsCss,
              size: size,
              accentColor: hex,
              accentSoftColor: soft,
            ),
            PdfTemplate.folio => FolioTemplate.render(
              doc,
              fontsCss: fontsCss,
              size: size,
              accentColor: hex,
              accentSoftColor: soft,
            ),
            PdfTemplate.atelier => AtelierTemplate.render(
              doc,
              fontsCss: fontsCss,
              size: size,
              accentColor: hex,
              accentSoftColor: soft,
            ),
            PdfTemplate.lumen => LumenTemplate.render(
              doc,
              fontsCss: fontsCss,
              size: size,
              accentColor: hex,
              accentSoftColor: soft,
            ),
            PdfTemplate.aurora => premium(
              AuroraTemplate.css,
              AuroraTemplate.body(doc),
            ),
            PdfTemplate.prestige => premium(
              PrestigeTemplate.css,
              PrestigeTemplate.body(doc),
            ),
            PdfTemplate.vertex => premium(
              VertexTemplate.css,
              VertexTemplate.body(doc),
            ),
            PdfTemplate.pillar => premium(
              PillarTemplate.css,
              PillarTemplate.body(doc),
            ),
            PdfTemplate.crest => premium(
              CrestTemplate.css,
              CrestTemplate.body(doc),
            ),
            PdfTemplate.orbit => premium(
              OrbitTemplate.css,
              OrbitTemplate.body(doc),
            ),
            PdfTemplate.ribbon => premium(
              RibbonTemplate.css,
              RibbonTemplate.body(doc),
            ),
            PdfTemplate.onyx => premium(
              OnyxTemplate.css,
              OnyxTemplate.body(doc),
            ),
            PdfTemplate.metro => premium(
              MetroTemplate.css,
              MetroTemplate.body(doc),
            ),
            PdfTemplate.regal => premium(
              RegalTemplate.css,
              RegalTemplate.body(doc),
            ),
            PdfTemplate.duo => premium(DuoTemplate.css, DuoTemplate.body(doc)),
            PdfTemplate.halo => premium(
              HaloTemplate.css,
              HaloTemplate.body(doc),
            ),
            PdfTemplate.pinstripe => premium(
              PinstripeTemplate.css,
              PinstripeTemplate.body(doc),
            ),
            PdfTemplate.impact => premium(
              ImpactTemplate.css,
              ImpactTemplate.body(doc),
            ),
            // Canvas designs are rendered above.
            PdfTemplate.wave ||
            PdfTemplate.prism ||
            PdfTemplate.nocturne ||
            PdfTemplate.mesh ||
            PdfTemplate.corner ||
            PdfTemplate.sash ||
            PdfTemplate.peak ||
            PdfTemplate.bubble ||
            PdfTemplate.hive ||
            PdfTemplate.tide ||
            PdfTemplate.halftone ||
            PdfTemplate.frame ||
            PdfTemplate.lattice ||
            PdfTemplate.shard ||
            PdfTemplate.dusk ||
            PdfTemplate.carbon ||
            PdfTemplate.swoosh ||
            PdfTemplate.slant ||
            PdfTemplate.capsule ||
            PdfTemplate.pixel ||
            PdfTemplate.silk ||
            PdfTemplate.confetti ||
            PdfTemplate.plaque ||
            PdfTemplate.trio ||
            PdfTemplate.fold ||
            PdfTemplate.linea ||
            PdfTemplate.margin ||
            PdfTemplate.quartz ||
            PdfTemplate.pearl => throw StateError('canvas'),
          };
    final line = footer?.trim();
    if (line == null || line.isEmpty) return html;
    final safe = const HtmlEscape().convert(line);
    return html.replaceFirst(
      '</body>',
      '<p style="margin:8mm 0 0;font-size:8pt;text-align:center;'
          'color:${PdfPalette.muted}">$safe</p></body>',
    );
  }
}
