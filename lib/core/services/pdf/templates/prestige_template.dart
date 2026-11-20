import '../models/pdf_document.dart';
import '../pdf_blocks.dart';
import '../pdf_html.dart';
import '../pdf_palette.dart';

/// Prestige: centered luxury letterhead under a dark band, with fine
/// highlight rules and a dark total.
abstract final class PrestigeTemplate {
  static String body(PdfDocument doc) =>
      '''
<div class="p-band"></div>
<div class="p-crest keep">
  ${PdfHtml.logo(doc.seller)}
  <div class="p-name">${PdfHtml.esc(doc.seller.name)}</div>
  ${PdfBlocks.sellerLines(doc, cls: 'p-line')}
</div>
<div class="p-title keep"><i></i><span>${PdfHtml.esc(doc.title)}</span><i></i></div>
<div class="p-row keep">
  <div>${PdfBlocks.buyer(doc)}</div>
  <div class="p-meta"><div class="p-num">${PdfHtml.esc(doc.number)}</div>${PdfBlocks.stamp(doc)}${PdfBlocks.meta(doc)}</div>
</div>
${PdfBlocks.rest(doc)}
''';

  static const String css =
      '''
${PdfBlocks.bleedCss}.p-band { margin: -14mm -14mm 7mm; height: 9mm; background: ${PdfPalette.deep};
  border-bottom: 1mm solid ${PdfPalette.pair}; }
.p-crest { text-align: center; }
.p-name { font-size: 17pt; font-weight: 700; letter-spacing: 2.5px;
  text-transform: uppercase; color: ${PdfPalette.deep}; margin-top: 1.5mm; }
.p-line { font-size: 8.5pt; color: ${PdfPalette.muted}; }
.p-title { display: flex; align-items: center; gap: 5mm; margin: 6mm 0; }
.p-title i { flex: 1; height: 1px; background: ${PdfPalette.pair}; }
.p-title span { font-size: 12pt; font-weight: 700; letter-spacing: 5px;
  text-transform: uppercase; color: ${PdfPalette.brand}; }
.p-row { display: flex; justify-content: space-between; gap: 10mm;
  margin-bottom: 6mm; }
.p-meta { text-align: right; min-width: 62mm; }
.p-num { font-size: 12pt; font-weight: 700; color: ${PdfPalette.deep}; }
.label { color: ${PdfPalette.pair}; }
.items th { color: ${PdfPalette.deep}; border-top: 1px solid ${PdfPalette.pair}; border-bottom: 1px solid ${PdfPalette.pair};
  letter-spacing: 1.2px; }
.totals .grand td { background: ${PdfPalette.deep}; color: #FFFFFF; }
.totals .grand td:last-child { color: ${PdfPalette.pair}; }
.note-h { color: ${PdfPalette.deep}; }
.sign-line { border-top-color: ${PdfPalette.pair}; }
''';
}
