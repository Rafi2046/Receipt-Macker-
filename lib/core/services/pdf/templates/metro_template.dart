import '../models/pdf_document.dart';
import '../pdf_blocks.dart';
import '../pdf_html.dart';
import '../pdf_palette.dart';

/// Metro: a row of flat color tiles for the title, the amount and the
/// dates, above a clean grid.
abstract final class MetroTemplate {
  static String body(PdfDocument doc) =>
      '''
<div class="mt-grid keep">
  <div class="mt-tile mt-a">
    <div class="mt-title">${PdfHtml.esc(doc.title)}</div>
    <div class="mt-num">${PdfHtml.esc(doc.number)}</div>
    ${PdfBlocks.stamp(doc)}
  </div>
  <div class="mt-tile mt-b">
    <div class="mt-cap">${PdfHtml.esc(doc.grandTotal.label)}</div>
    <div class="mt-amount">${PdfHtml.esc(doc.grandTotal.value)}</div>
  </div>
  <div class="mt-tile mt-c">${PdfBlocks.meta(doc)}</div>
</div>
<div class="mt-row keep">
  <div class="mt-col">${PdfHtml.logo(doc.seller)}${PdfHtml.party(doc.seller)}</div>
  <div class="mt-col">${PdfBlocks.buyer(doc)}</div>
</div>
${PdfBlocks.rest(doc)}
''';

  static const String css =
      '''
.mt-grid { display: flex; gap: 2mm; margin-bottom: 7mm; }
.mt-tile { padding: 5mm; min-height: 30mm; display: flex;
  flex-direction: column; justify-content: flex-end; }
.mt-a { flex: 1.15; background: ${PdfPalette.brand}; color: #FFFFFF; }
.mt-b { flex: 1; background: ${PdfPalette.deep}; color: #FFFFFF; }
.mt-c { flex: 1.25; background: ${PdfPalette.brandSoft}; justify-content: center; }
.mt-tile .stamp { align-self: flex-start; }
.mt-title { font-size: 19pt; font-weight: 700; text-transform: uppercase;
  letter-spacing: 1px; line-height: 1.1; }
.mt-num { font-size: 10.5pt; color: rgba(255, 255, 255, 0.9); }
.mt-cap { font-size: 7.5pt; font-weight: 700; text-transform: uppercase;
  letter-spacing: 1px; color: ${PdfPalette.pair}; }
.mt-amount { font-size: 15pt; font-weight: 700; line-height: 1.2;
  font-variant-numeric: tabular-nums; }
.mt-row { display: flex; gap: 8mm; margin-bottom: 6mm; }
.mt-col { flex: 1; border-top: 0.8mm solid ${PdfPalette.brand}; padding-top: 3mm; }
.items th { background: ${PdfPalette.brandSoft}; color: ${PdfPalette.deep}; }
.items td { border-bottom: 1px solid ${PdfPalette.line}; }
.totals .grand td { background: ${PdfPalette.brand}; color: #FFFFFF; }
''';
}
