import '../models/pdf_document.dart';
import '../pdf_blocks.dart';
import '../pdf_html.dart';
import '../pdf_palette.dart';

/// Aurora: full-bleed gradient hero with the bill-to and date cards
/// overlapping its lower edge.
abstract final class AuroraTemplate {
  static String body(PdfDocument doc) =>
      '''
<div class="hero on-dark keep">
  <div>
    ${PdfHtml.logo(doc.seller)}
    <div class="hero-name">${PdfHtml.esc(doc.seller.name)}</div>
    ${PdfBlocks.sellerLines(doc, cls: 'hero-line')}
  </div>
  <div class="hero-doc">
    <div class="hero-title">${PdfHtml.esc(doc.title)}</div>
    <div class="hero-num">${PdfHtml.esc(doc.number)}</div>
    ${PdfBlocks.stamp(doc)}
  </div>
</div>
<div class="cards keep">
  <div class="card">${PdfBlocks.buyer(doc)}</div>
  <div class="card">${PdfBlocks.meta(doc)}</div>
</div>
${PdfBlocks.rest(doc)}
''';

  static const String css =
      '''
${PdfBlocks.bleedCss}.hero { position: relative; overflow: hidden; margin: -14mm -14mm 0;
  padding: 11mm 14mm 17mm; color: #FFFFFF; display: flex;
  justify-content: space-between; gap: 8mm;
  background: linear-gradient(120deg, ${PdfPalette.brand} 0%, ${PdfPalette.deep} 100%); }
.hero::after { content: ''; position: absolute; right: -18mm; top: -30mm;
  width: 80mm; height: 80mm; border-radius: 50%;
  background: rgba(255, 255, 255, 0.08); }
.hero::before { content: ''; position: absolute; right: 30mm; bottom: -34mm;
  width: 56mm; height: 56mm; border-radius: 50%;
  border: 1.2mm solid rgba(255, 255, 255, 0.10); }
.hero-name { font-size: 14pt; font-weight: 700; margin-top: 1mm; }
.hero-line { font-size: 8.5pt; color: rgba(255, 255, 255, 0.85); }
.hero-doc { text-align: right; position: relative; z-index: 1; }
.hero-title { font-size: 24pt; font-weight: 700; letter-spacing: 1.5px;
  text-transform: uppercase; line-height: 1.1; }
.hero-num { font-size: 11pt; color: rgba(255, 255, 255, 0.9); }
.cards { display: flex; gap: 5mm; margin: -9mm 0 6mm; position: relative; }
.card { flex: 1; background: #FFFFFF; border: 1px solid ${PdfPalette.line};
  border-top: 0.9mm solid ${PdfPalette.pair}; border-radius: 2.5mm; padding: 4mm 5mm; }
.items th { background: ${PdfPalette.brandSoft}; color: ${PdfPalette.brand}; border-bottom: 2px solid ${PdfPalette.brand}; }
.totals .grand td { color: #FFFFFF; background: ${PdfPalette.brand}; }
.totals .grand td:first-child { border-radius: 2mm 0 0 2mm; }
.totals .grand td:last-child { border-radius: 0 2mm 2mm 0; }
''';
}
