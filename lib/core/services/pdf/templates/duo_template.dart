import '../models/pdf_document.dart';
import '../pdf_blocks.dart';
import '../pdf_html.dart';
import '../pdf_palette.dart';

/// Duo: a header split in two halves, the seller on a soft wash and the
/// document on solid color with the amount called out.
abstract final class DuoTemplate {
  static String body(PdfDocument doc) =>
      '''
<div class="du-head keep">
  <div class="du-l">${PdfHtml.logo(doc.seller)}${PdfHtml.party(doc.seller)}</div>
  <div class="du-r">
    <div class="du-title">${PdfHtml.esc(doc.title)}</div>
    <div class="du-num">${PdfHtml.esc(doc.number)}</div>
    ${PdfBlocks.stamp(doc)}
    <div class="du-cap">${PdfHtml.esc(doc.grandTotal.label)}</div>
    <div class="du-amount">${PdfHtml.esc(doc.grandTotal.value)}</div>
  </div>
</div>
<div class="du-row keep">
  <div>${PdfBlocks.buyer(doc)}</div>
  <div class="du-meta">${PdfBlocks.meta(doc)}</div>
</div>
${PdfBlocks.rest(doc)}
''';

  static const String css =
      '''
${PdfBlocks.bleedCss}.du-head { display: flex; margin: -14mm -14mm 7mm; }
.du-l { flex: 1; background: ${PdfPalette.brandSoft}; padding: 11mm 8mm 9mm 14mm; }
.du-l .party-name { font-size: 14pt; color: ${PdfPalette.deep}; margin-top: 1mm; }
.du-r { flex: 1; background: ${PdfPalette.brand}; color: #FFFFFF;
  padding: 11mm 14mm 9mm 9mm; border-bottom: 1.4mm solid ${PdfPalette.pair}; }
.du-title { font-size: 22pt; font-weight: 700; text-transform: uppercase;
  letter-spacing: 1.5px; line-height: 1.1; }
.du-num { font-size: 10.5pt; color: rgba(255, 255, 255, 0.9); }
.du-cap { margin-top: 5mm; font-size: 7.5pt; font-weight: 700;
  text-transform: uppercase; letter-spacing: 1px;
  color: rgba(255, 255, 255, 0.75); }
.du-amount { font-size: 17pt; font-weight: 700; line-height: 1.2;
  font-variant-numeric: tabular-nums; }
.du-row { display: flex; justify-content: space-between; gap: 10mm;
  margin-bottom: 6mm; }
.du-meta { min-width: 64mm; }
.label { color: ${PdfPalette.brand}; }
.items th { color: ${PdfPalette.deep}; border-bottom: 2px solid ${PdfPalette.brand}; }
.items td { border-bottom: 0; }
.items tbody tr:nth-child(even) td { background: ${PdfPalette.brandSoft}; }
.totals .grand td { background: ${PdfPalette.brandSoft}; color: ${PdfPalette.brand}; }
.totals .grand td:first-child { border-left: 1.4mm solid ${PdfPalette.brand}; }
''';
}
