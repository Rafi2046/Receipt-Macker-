import '../models/pdf_document.dart';
import '../pdf_blocks.dart';
import '../pdf_html.dart';
import '../pdf_palette.dart';

/// Crest: brand header ending in a soft double wave, with striped rows
/// and a pill-shaped total.
abstract final class CrestTemplate {
  static String body(PdfDocument doc) =>
      '''
<div class="cr-head on-dark keep">
  <div class="cr-in">
    <div>
      ${PdfHtml.logo(doc.seller)}
      <div class="cr-name">${PdfHtml.esc(doc.seller.name)}</div>
      ${PdfBlocks.sellerLines(doc, cls: 'cr-line')}
    </div>
    <div class="cr-doc">
      <div class="cr-title">${PdfHtml.esc(doc.title)}</div>
      <div class="cr-num">${PdfHtml.esc(doc.number)}</div>
      ${PdfBlocks.stamp(doc)}
    </div>
  </div>
  <svg class="cr-wave" viewBox="0 0 1200 120" preserveAspectRatio="none">
    <path d="M0,120 L0,52 C300,128 720,-12 1200,60 L1200,120 Z"
      style="fill: var(--brand-pair)"/>
    <path d="M0,120 L0,68 C300,140 720,4 1200,76 L1200,120 Z"
      style="fill: #FFFFFF"/>
  </svg>
</div>
<div class="cr-row keep">
  <div>${PdfBlocks.buyer(doc)}</div>
  <div class="cr-meta">${PdfBlocks.meta(doc)}</div>
</div>
${PdfBlocks.rest(doc)}
''';

  static const String css =
      '''
${PdfBlocks.bleedCss}.cr-head { position: relative; margin: -14mm -14mm 4mm; color: #FFFFFF;
  background: linear-gradient(100deg, ${PdfPalette.deep} 0%, ${PdfPalette.brand} 70%); }
.cr-in { display: flex; justify-content: space-between; gap: 8mm;
  padding: 11mm 14mm 20mm; }
.cr-wave { position: absolute; left: 0; bottom: -0.3mm; width: 100%;
  height: 15mm; display: block; }
.cr-name { font-size: 14pt; font-weight: 700; margin-top: 1mm; }
.cr-line { font-size: 8.5pt; color: rgba(255, 255, 255, 0.85); }
.cr-doc { text-align: right; }
.cr-title { font-size: 23pt; font-weight: 700; text-transform: uppercase;
  letter-spacing: 1.5px; line-height: 1.1; }
.cr-num { font-size: 11pt; color: rgba(255, 255, 255, 0.9); }
.cr-row { display: flex; justify-content: space-between; gap: 10mm;
  margin-bottom: 6mm; }
.cr-meta { min-width: 64mm; }
.label { color: ${PdfPalette.brand}; }
.items th { color: ${PdfPalette.brand}; border-bottom: 2px solid ${PdfPalette.brand}; }
.items td { border-bottom: 0; }
.items tbody tr:nth-child(even) td { background: ${PdfPalette.brandSoft}; }
.totals .grand td { background: ${PdfPalette.brand}; color: #FFFFFF; }
.totals .grand td:first-child { border-radius: 99mm 0 0 99mm;
  padding-left: 5mm; }
.totals .grand td:last-child { border-radius: 0 99mm 99mm 0;
  padding-right: 5mm; }
''';
}
