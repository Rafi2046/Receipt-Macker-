import '../models/pdf_document.dart';
import '../pdf_blocks.dart';
import '../pdf_html.dart';
import '../pdf_palette.dart';

/// Pinstripe: a slim three-tone stripe, a light oversized title and a
/// ruled table with column lines.
abstract final class PinstripeTemplate {
  static String body(PdfDocument doc) =>
      '''
<div class="ps-stripe"></div>
<div class="ps-head keep">
  <div>
    <div class="ps-title">${PdfHtml.esc(doc.title)}</div>
    <div class="ps-num">${PdfHtml.esc(doc.number)}</div>
    ${PdfBlocks.stamp(doc)}
  </div>
  <div class="ps-seller">${PdfHtml.logo(doc.seller)}${PdfHtml.party(doc.seller)}</div>
</div>
<div class="ps-row keep">
  <div class="ps-col">${PdfBlocks.buyer(doc)}</div>
  <div class="ps-col">${PdfBlocks.meta(doc)}</div>
</div>
${PdfBlocks.rest(doc)}
''';

  static const String css =
      '''
${PdfBlocks.bleedCss}.ps-stripe { margin: -14mm -14mm 9mm; height: 3.2mm;
  background: linear-gradient(90deg, ${PdfPalette.brand} 0%, ${PdfPalette.brand} 62%, ${PdfPalette.pair} 62%, ${PdfPalette.pair} 74%,
    ${PdfPalette.deep} 74%, ${PdfPalette.deep} 100%); }
.ps-head { display: flex; justify-content: space-between; gap: 10mm;
  margin-bottom: 7mm; }
.ps-title { font-size: 30pt; font-weight: 400; letter-spacing: 3px;
  text-transform: uppercase; color: ${PdfPalette.deep}; line-height: 1.1; }
.ps-num { font-size: 11pt; font-weight: 700; color: ${PdfPalette.brand}; margin-top: 1mm; }
.stamp { color: ${PdfPalette.muted}; }
.ps-seller { text-align: right; max-width: 48%; }
.ps-row { display: flex; border-top: 1px solid ${PdfPalette.ink};
  border-bottom: 1px solid ${PdfPalette.ink}; margin-bottom: 6mm; }
.ps-col { flex: 1; padding: 4mm 5mm 4mm 0; }
.ps-col + .ps-col { border-left: 1px solid ${PdfPalette.line}; padding-left: 5mm; }
.items th { color: ${PdfPalette.ink}; border-bottom: 1px solid ${PdfPalette.ink}; }
.items td { border-right: 1px solid ${PdfPalette.line}; }
.items td:last-child { border-right: 0; }
.totals .grand td { color: ${PdfPalette.brand}; border-top: 2px solid ${PdfPalette.brand}; font-size: 13pt; }
.note-h { color: ${PdfPalette.ink}; }
''';
}
