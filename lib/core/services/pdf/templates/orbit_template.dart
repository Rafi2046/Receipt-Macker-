import '../models/pdf_document.dart';
import '../pdf_blocks.dart';
import '../pdf_html.dart';
import '../pdf_palette.dart';

/// Orbit: overlapping circles in the top corner, an oversized title and
/// rounded table bars.
abstract final class OrbitTemplate {
  static String body(PdfDocument doc) =>
      '''
<div class="ob-art"><i class="ob-a"></i><i class="ob-b"></i><i class="ob-c"></i></div>
<div class="ob-head keep">
  <div class="ob-title">${PdfHtml.esc(doc.title)}</div>
  <span class="ob-num">${PdfHtml.esc(doc.number)}</span>
  ${PdfBlocks.stamp(doc)}
</div>
<div class="ob-row keep">
  <div class="ob-col">${PdfHtml.logo(doc.seller)}${PdfHtml.party(doc.seller)}</div>
  <div class="ob-col">${PdfBlocks.buyer(doc)}</div>
  <div class="ob-col">${PdfBlocks.meta(doc)}</div>
</div>
${PdfBlocks.rest(doc)}
''';

  static const String css =
      '''
${PdfBlocks.bleedCss}.ob-art { position: absolute; top: 0; right: 0; width: 86mm;
  height: 56mm; overflow: hidden; }
.ob-art i { position: absolute; border-radius: 50%; display: block; }
.ob-a { width: 78mm; height: 78mm; top: -40mm; right: -24mm;
  background: ${PdfPalette.brand}; }
.ob-b { width: 32mm; height: 32mm; top: 14mm; right: 40mm;
  background: ${PdfPalette.pair}; opacity: 0.92; }
.ob-c { width: 52mm; height: 52mm; top: -10mm; right: 18mm;
  border: 1mm solid ${PdfPalette.deep}; opacity: 0.35; }
.ob-head { position: relative; padding-top: 4mm; margin-bottom: 6mm;
  max-width: 100mm; min-height: 42mm; }
.ob-title { font-size: 32pt; font-weight: 700; color: ${PdfPalette.deep};
  line-height: 1.05; letter-spacing: -0.5px; }
.ob-num { display: inline-block; margin-top: 2mm; background: ${PdfPalette.brandSoft};
  color: ${PdfPalette.brand}; font-weight: 700; font-size: 10pt; padding: 0.8mm 4mm;
  border-radius: 99mm; }
.stamp { color: ${PdfPalette.muted}; margin-left: 2mm; }
.ob-row { display: flex; gap: 7mm; margin-bottom: 6mm; position: relative; }
.ob-col { flex: 1; }
.ob-col .party-name { font-size: 10.5pt; }
.items th { background: ${PdfPalette.brandSoft}; color: ${PdfPalette.brand}; }
.items th:first-child { border-radius: 99mm 0 0 99mm; padding-left: 5mm; }
.items th:last-child { border-radius: 0 99mm 99mm 0; padding-right: 5mm; }
.items td:first-child { padding-left: 5mm; }
.items td:last-child { padding-right: 5mm; }
.totals .grand td { background: ${PdfPalette.brand}; color: #FFFFFF; }
.totals .grand td:first-child { border-radius: 99mm 0 0 99mm;
  padding-left: 5mm; }
.totals .grand td:last-child { border-radius: 0 99mm 99mm 0;
  padding-right: 5mm; }
.totals td:last-child { padding-right: 5mm; }
''';
}
