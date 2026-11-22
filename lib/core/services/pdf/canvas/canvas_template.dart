import '../models/pdf_document.dart';
import '../pdf_blocks.dart';
import '../pdf_html.dart';
import '../pdf_page_size.dart';
import 'art_svg.dart';
import 'art_tones.dart';
import 'canvas_css.dart';
import 'canvas_design.dart';
import 'canvas_logo_css.dart';

/// Lays a document over a [CanvasDesign]'s full-page art. The skeleton
/// decides the header and the colors; the sections below are the same.
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
    final skeletonCss = design.hasLogoHead
        ? CanvasLogoCss.of(design)
        : CanvasCss.skeleton(design);
    final body = design.hasLogoHead ? _logoBody(doc) : _body(doc);
    return PdfHtml.page(
      doc: doc,
      fontsCss: fontsCss,
      templateCss:
          '${PdfBlocks.css}${CanvasCss.base}$skeletonCss'
          '${_pageCss(design, tones, size)}',
      size: size,
      accentColor: accentColor,
      accentSoftColor: accentSoftColor,
      body: '<div class="cv cv-${design.skeleton.name}">$body</div>',
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

  /// Logo and seller in the header beside the title; buyer and dates
  /// below. `cv-body` is the white card of the card skeleton.
  static String _logoBody(PdfDocument doc) {
    final logo = PdfHtml.logo(doc.seller);
    return '''
<div class="cv-bhead keep">
  <div class="cv-who">
    ${logo.isEmpty ? '' : '<div class="cv-logo">$logo</div>'}
    <div class="cv-seller">${PdfHtml.party(doc.seller)}</div>
  </div>
  <div class="cv-doc">
    <div class="cv-title">${PdfHtml.esc(doc.title)}</div>
    <div class="cv-num">${PdfHtml.esc(doc.number)}</div>
    ${PdfBlocks.stamp(doc)}
  </div>
</div>
<div class="cv-body">
<div class="cv-info keep">
  <div class="cv-party">${PdfBlocks.buyer(doc)}</div>
  <div class="cv-meta">${PdfBlocks.meta(doc)}</div>
</div>
${PdfBlocks.rest(doc)}
</div>
''';
  }

  /// Margins and the art as the page background: the first page gets the
  /// full art, later pages a calmer version.
  static String _pageCss(
    CanvasDesign design,
    ArtTones tones,
    PdfPageSize size,
  ) {
    final top = _mm(design.marginTopMm);
    final side = _mm(design.marginSideMm);
    final bottom = _mm(design.marginBottomMm);
    final (w, h) = size.paperMm;
    String art({required bool first}) =>
        'url("${ArtSvg.dataUri(design, tones, firstPage: first)}")';
    final counter = design.footOnColor ? 'rgba(255, 255, 255, 0.7)' : '#6B7280';
    final bleed = design.skeleton == CanvasSkeleton.brand;
    return '''
@page { margin: $top ${bleed ? '0' : side} $bottom ${bleed ? '0' : side};
  background: ${tones.hex(design.base)} ${art(first: false)}
    ${bleed ? '0' : '-$side'} -$top / ${_mm(w)} ${_mm(h)} no-repeat;
  @bottom-center { color: $counter; } }
@page :first { background-image: ${art(first: true)}; }
:root { --cv-hi: ${tones.highlight}; }
${design.headHeightMm > 0 ? '.cv-head { min-height: ${_mm(design.headHeightMm)}; }' : ''}
${bleed ? _bleedCss(design, tones) : ''}
''';
  }

  /// The brand header runs edge to edge and grows with its text. The
  /// browser never paints in the page margin, so the side margins (and the
  /// first page's top margin) become padding the header reaches across.
  static String _bleedCss(CanvasDesign design, ArtTones tones) {
    final top = _mm(design.marginTopMm);
    final side = _mm(design.marginSideMm);
    final edge = design.edgeMm;
    final layers = [
      if (edge > 0)
        // Pushed a hair past the bottom so no line of header color shows.
        'url("${ArtSvg.edgeUri(design, tones)}") left 0 bottom -0.3mm / '
            '100% ${_mm(edge)} no-repeat',
      if (design.headShapes.isNotEmpty)
        'url("${ArtSvg.headUri(design, tones)}") right center / cover '
            'no-repeat',
      tones.hex(design.headBase),
    ];
    return '''
@page :first { margin-top: 0; background-position: 0 0; }
body { padding: 0 $side; }
.cv-bhead { margin: 0 -$side 7mm; padding: $top $side ${_mm(edge + 7)};
  background: ${layers.join(', ')}; }
''';
  }

  static String _mm(double v) =>
      '${v.toStringAsFixed(1).replaceAll('.0', '')}mm';
}
