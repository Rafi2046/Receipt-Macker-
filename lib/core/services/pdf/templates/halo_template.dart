import '../models/pdf_document.dart';
import '../pdf_blocks.dart';
import '../pdf_html.dart';
import '../pdf_palette.dart';

/// Halo: everything on soft rounded cards, with pill-shaped table bars.
abstract final class HaloTemplate {
  static String body(PdfDocument doc) =>
      '''
<div class="hl-head keep">
  <div>${PdfHtml.logo(doc.seller)}${PdfHtml.party(doc.seller)}</div>
  <div class="hl-doc">
    <span class="hl-title">${PdfHtml.esc(doc.title)}</span>
    <div class="hl-num">${PdfHtml.esc(doc.number)}</div>
    ${PdfBlocks.stamp(doc)}
  </div>
</div>
<div class="hl-cards keep">
  <div class="hl-card">${PdfBlocks.buyer(doc)}</div>
  <div class="hl-card">${PdfBlocks.meta(doc)}</div>
</div>
${PdfBlocks.rest(doc)}
''';

  static const String css =
      '''
.hl-head { background: ${PdfPalette.brandSoft}; border-radius: 5mm; padding: 7mm 8mm;
  display: flex; justify-content: space-between; gap: 8mm;
  margin-bottom: 4mm; }
.hl-head .party-name { font-size: 13.5pt; color: ${PdfPalette.deep}; margin-top: 1mm; }
.hl-doc { text-align: right; }
.hl-title { display: inline-block; background: ${PdfPalette.brand}; color: #FFFFFF;
  font-size: 13pt; font-weight: 700; text-transform: uppercase;
  letter-spacing: 1.5px; padding: 1.4mm 6mm; border-radius: 99mm; }
.hl-num { font-size: 12pt; font-weight: 700; color: ${PdfPalette.deep}; margin-top: 2mm; }
.stamp { color: ${PdfPalette.muted}; }
.hl-cards { display: flex; gap: 4mm; margin-bottom: 6mm; }
.hl-card { flex: 1; border: 1px solid ${PdfPalette.line}; border-radius: 4mm;
  padding: 4.5mm 6mm; }
.label { color: ${PdfPalette.brand}; }
.items th { background: ${PdfPalette.brand}; color: #FFFFFF; }
.items th:first-child { border-radius: 99mm 0 0 99mm; padding-left: 6mm; }
.items th:last-child { border-radius: 0 99mm 99mm 0; padding-right: 6mm; }
.items td { border-bottom: 1px dashed ${PdfPalette.line}; }
.items td:first-child { padding-left: 6mm; }
.items td:last-child { padding-right: 6mm; }
.totals { background: ${PdfPalette.brandSoft}; border-radius: 4mm; border-collapse: separate;
  border-spacing: 0; padding: 2.5mm; }
.totals .grand td { background: ${PdfPalette.brand}; color: #FFFFFF; }
.totals .grand td:first-child { border-radius: 99mm 0 0 99mm;
  padding-left: 5mm; }
.totals .grand td:last-child { border-radius: 0 99mm 99mm 0;
  padding-right: 5mm; }
''';
}
