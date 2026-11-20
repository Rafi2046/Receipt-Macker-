import '../models/pdf_document.dart';
import '../pdf_blocks.dart';
import '../pdf_html.dart';
import '../pdf_palette.dart';

/// Vertex: sharp angled two-tone header split by a highlight stripe,
/// with a slanted lower edge.
abstract final class VertexTemplate {
  static String body(PdfDocument doc) =>
      '''
<div class="vx-head on-dark keep">
  <div>
    <div class="vx-title">${PdfHtml.esc(doc.title)}</div>
    <div class="vx-num">${PdfHtml.esc(doc.number)}</div>
    ${PdfBlocks.stamp(doc)}
  </div>
  <div class="vx-seller">
    ${PdfHtml.logo(doc.seller)}
    <div class="vx-name">${PdfHtml.esc(doc.seller.name)}</div>
    ${PdfBlocks.sellerLines(doc, cls: 'vx-line')}
  </div>
</div>
<div class="vx-row keep">
  <div class="vx-box">${PdfBlocks.buyer(doc)}</div>
  <div class="vx-box">${PdfBlocks.meta(doc)}</div>
</div>
${PdfBlocks.rest(doc)}
''';

  static const String css =
      '''
${PdfBlocks.bleedCss}.vx-head { position: relative; margin: -14mm -14mm 7mm;
  padding: 12mm 14mm 17mm; color: #FFFFFF; display: flex;
  justify-content: space-between; gap: 8mm;
  background: linear-gradient(105deg, ${PdfPalette.brand} 0%, ${PdfPalette.brand} 52%, ${PdfPalette.pair} 52%, ${PdfPalette.pair} 53.4%,
    ${PdfPalette.deep} 53.4%, ${PdfPalette.deep} 100%); }
.vx-head::after { content: ''; position: absolute; left: 0; right: 0;
  bottom: -0.2mm; height: 9mm;
  background: linear-gradient(to bottom right, transparent 49.7%,
    #FFFFFF 50%); }
.vx-title { font-size: 26pt; font-weight: 700; text-transform: uppercase;
  letter-spacing: 1px; line-height: 1.1; }
.vx-num { font-size: 11pt; color: rgba(255, 255, 255, 0.9); }
.vx-seller { text-align: right; max-width: 42%; }
.vx-name { font-size: 12.5pt; font-weight: 700; margin-top: 1mm; }
.vx-line { font-size: 8.5pt; color: rgba(255, 255, 255, 0.82); }
.vx-row { display: flex; gap: 8mm; margin-bottom: 6mm; }
.vx-box { flex: 1; border-left: 1.2mm solid ${PdfPalette.brand}; padding-left: 4mm; }
.items th { background: ${PdfPalette.deep}; color: #FFFFFF; }
.items th:first-child { border-left: 1.6mm solid ${PdfPalette.pair}; }
.totals .grand td { background: ${PdfPalette.brand}; color: #FFFFFF;
  border-bottom: 1mm solid ${PdfPalette.pair}; }
''';
}
