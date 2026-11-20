import '../models/pdf_document.dart';
import '../pdf_blocks.dart';
import '../pdf_html.dart';
import '../pdf_palette.dart';

/// Impact: the amount due leads the page on a full-width color banner.
abstract final class ImpactTemplate {
  static String body(PdfDocument doc) =>
      '''
<div class="im-head keep">
  <div>${PdfHtml.logo(doc.seller)}${PdfHtml.party(doc.seller)}</div>
  <div class="im-doc">
    <div class="im-title">${PdfHtml.esc(doc.title)}</div>
    <div class="im-num">${PdfHtml.esc(doc.number)}</div>
    ${PdfBlocks.stamp(doc)}
  </div>
</div>
<div class="im-banner keep">
  <div>
    <div class="im-cap">${PdfHtml.esc(doc.grandTotal.label)}</div>
    <div class="im-amount">${PdfHtml.esc(doc.grandTotal.value)}</div>
  </div>
  <div class="im-meta">${PdfBlocks.meta(doc)}</div>
</div>
<div class="im-buyer keep">${PdfBlocks.buyer(doc)}</div>
${PdfBlocks.rest(doc)}
''';

  static const String css =
      '''
${PdfBlocks.bleedCss}.im-head { display: flex; justify-content: space-between; gap: 10mm;
  margin-bottom: 6mm; }
.im-head .party-name { font-size: 14pt; margin-top: 1mm; }
.im-doc { text-align: right; }
.im-title { font-size: 11pt; font-weight: 700; letter-spacing: 4px;
  text-transform: uppercase; color: ${PdfPalette.muted}; }
.im-num { font-size: 15pt; font-weight: 700; color: ${PdfPalette.deep}; }
.stamp { color: ${PdfPalette.muted}; }
.im-banner { margin: 0 -14mm 6mm; padding: 7mm 14mm; background: ${PdfPalette.brand};
  color: #FFFFFF; border-bottom: 1.6mm solid ${PdfPalette.pair}; display: flex;
  justify-content: space-between; align-items: center; gap: 10mm; }
.im-cap { font-size: 8pt; font-weight: 700; text-transform: uppercase;
  letter-spacing: 1.5px; color: rgba(255, 255, 255, 0.8); }
.im-amount { font-size: 30pt; font-weight: 700; line-height: 1.15;
  font-variant-numeric: tabular-nums; }
.im-meta { min-width: 62mm; }
.im-meta .meta td, .im-meta .meta td:first-child { color: #FFFFFF; }
.im-meta .meta td:first-child { opacity: 0.8; }
.im-buyer { margin-bottom: 6mm; }
.label { color: ${PdfPalette.brand}; }
.items th { background: ${PdfPalette.deep}; color: #FFFFFF; }
.totals .grand td { background: ${PdfPalette.brandSoft}; color: ${PdfPalette.brand};
  border-bottom: 1mm solid ${PdfPalette.brand}; }
''';
}
