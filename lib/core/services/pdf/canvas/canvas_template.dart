import '../models/pdf_document.dart';
import '../pdf_blocks.dart';
import '../pdf_html.dart';
import '../pdf_page_size.dart';
import 'art_svg.dart';
import 'art_tones.dart';
import 'canvas_css.dart';
import 'canvas_design.dart';

/// Lays a document over a [CanvasDesign]'s full-page art. Same sections
/// for every canvas design; the skeleton decides the colors.
abstract final class CanvasTemplate {
  static String render(
    CanvasDesign design,
    PdfDocument doc, {
    required String fontsCss,
    required PdfPageSize size,
    required String accentColor,
    required String accentSoftColor,
  }) {
    final tones = ArtTones(accentColor);
    return PdfHtml.page(
      doc: doc,
      fontsCss: fontsCss,
      templateCss:
          '${PdfBlocks.css}${CanvasCss.base}${CanvasCss.skeleton(design)}'
          '${_pageCss(design, tones, size)}',
      size: size,
      accentColor: accentColor,
      accentSoftColor: accentSoftColor,
      body: '<div class="cv cv-${design.skeleton.name}">${_body(doc)}</div>',
    );
  }

  static String _body(PdfDocument doc) =>
      '''
<div class="cv-head keep">
  <div class="cv-doc">
    <div class="cv-title">${PdfHtml.esc(doc.title)}</div>
    <div class="cv-num">${PdfHtml.esc(doc.number)}</div>
    ${PdfBlocks.stamp(doc)}
  </div>
  <div class="cv-meta">${PdfBlocks.meta(doc)}</div>
</div>
<div class="cv-parties keep">
  <div class="cv-party">${PdfHtml.logo(doc.seller)}${PdfHtml.party(doc.seller)}</div>
  <div class="cv-party">${PdfBlocks.buyer(doc)}</div>
</div>
${PdfBlocks.rest(doc)}
''';

  /// Margins and the art as the page background: the first page gets the
  /// full art, later pages a calmer version.
  static String _pageCss(
    CanvasDesign design,
    ArtTones tones,
    PdfPageSize size,
  ) {
    String mm(double v) => '${v.toStringAsFixed(1).replaceAll('.0', '')}mm';
    final top = mm(design.marginTopMm);
    final side = mm(design.marginSideMm);
    final bottom = mm(design.marginBottomMm);
    final (w, h) = size.paperMm;
    String art({required bool first}) =>
        'url("${ArtSvg.dataUri(design, tones, firstPage: first)}")';
    final counter = design.isDark ? 'rgba(255, 255, 255, 0.7)' : '#6B7280';
    return '''
@page { margin: $top $side $bottom $side;
  background: ${tones.hex(design.base)} ${art(first: false)}
    -$side -$top / ${mm(w)} ${mm(h)} no-repeat;
  @bottom-center { color: $counter; } }
@page :first { background-image: ${art(first: true)}; }
:root { --cv-hi: ${tones.highlight}; }
${design.headHeightMm > 0 ? '.cv-head { min-height: ${mm(design.headHeightMm)}; }' : ''}
''';
  }
}
