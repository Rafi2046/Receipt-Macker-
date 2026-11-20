import '../models/pdf_document.dart';
import '../pdf_blocks.dart';
import '../pdf_html.dart';
import '../pdf_palette.dart';

/// Onyx: black header and table bars with the brand color kept to thin,
/// sharp highlights.
abstract final class OnyxTemplate {
  static String body(PdfDocument doc) =>
      '''
<div class="ox-head on-dark keep">
  <div>
    <div class="ox-title">${PdfHtml.esc(doc.title)}</div>
    <div class="ox-bar"></div>
    <div class="ox-num">${PdfHtml.esc(doc.number)}</div>
    ${PdfBlocks.stamp(doc)}
  </div>
  <div class="ox-seller">
    ${PdfHtml.logo(doc.seller)}
    <div class="ox-name">${PdfHtml.esc(doc.seller.name)}</div>
    ${PdfBlocks.sellerLines(doc, cls: 'ox-line')}
  </div>
</div>
<div class="ox-strip keep">
  <div>${PdfBlocks.buyer(doc)}</div>
  <div class="ox-meta">${PdfBlocks.meta(doc)}</div>
</div>
${PdfBlocks.rest(doc)}
''';

  static const String css =
      '''
${PdfBlocks.bleedCss}.ox-head { margin: -14mm -14mm 0; padding: 12mm 14mm 10mm;
  background: #0B0F19; color: #FFFFFF; display: flex;
  justify-content: space-between; gap: 8mm; }
.ox-title { font-size: 28pt; font-weight: 700; text-transform: uppercase;
  letter-spacing: 2px; line-height: 1.1; }
.ox-bar { width: 20mm; height: 1.6mm; background: ${PdfPalette.brand}; margin: 2.5mm 0; }
.ox-num { font-size: 11pt; color: rgba(255, 255, 255, 0.85); }
.ox-seller { text-align: right; max-width: 46%; }
.ox-name { font-size: 12.5pt; font-weight: 700; margin-top: 1mm; }
.ox-line { font-size: 8.5pt; color: rgba(255, 255, 255, 0.7); }
.ox-strip { margin: 0 -14mm 6mm; padding: 5mm 14mm; background: #F4F4F5;
  border-bottom: 1mm solid ${PdfPalette.brand}; display: flex;
  justify-content: space-between; gap: 10mm; }
.ox-meta { min-width: 64mm; }
.items th { background: #0B0F19; color: #FFFFFF; }
.items th:first-child { border-left: 1.6mm solid ${PdfPalette.brand}; }
.totals .grand td { background: #0B0F19; color: #FFFFFF; }
.totals .grand td:first-child { border-left: 1.6mm solid ${PdfPalette.brand}; }
.note-h { color: ${PdfPalette.ink}; }
''';
}
