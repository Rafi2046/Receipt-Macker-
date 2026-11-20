import '../models/pdf_document.dart';
import '../pdf_blocks.dart';
import '../pdf_html.dart';
import '../pdf_palette.dart';

/// Ribbon: the title on a swallow-tail ribbon from the page edge, and
/// the total on a band running off the other side.
abstract final class RibbonTemplate {
  static String body(PdfDocument doc) =>
      '''
<div class="rb-head keep">
  <div class="rb-tab">
    <div class="rb-title">${PdfHtml.esc(doc.title)}</div>
    <div class="rb-num">${PdfHtml.esc(doc.number)}</div>
  </div>
  <div class="rb-seller">${PdfHtml.logo(doc.seller)}${PdfHtml.party(doc.seller)}${PdfBlocks.stamp(doc)}</div>
</div>
<div class="rb-row keep">
  <div>${PdfBlocks.buyer(doc)}</div>
  <div class="rb-meta">${PdfBlocks.meta(doc)}</div>
</div>
${PdfBlocks.rest(doc)}
''';

  static const String css =
      '''
${PdfBlocks.bleedCss}.rb-head { display: flex; justify-content: space-between; gap: 12mm;
  align-items: flex-start; margin-bottom: 7mm; }
.rb-tab { position: relative; margin-left: -14mm; padding: 5mm 9mm 5mm 14mm;
  background: ${PdfPalette.brand}; color: #FFFFFF; }
.rb-tab::before, .rb-tab::after { content: ''; position: absolute;
  right: -7.9mm; width: 8mm; height: 50.5%; }
.rb-tab::before { top: 0; background: linear-gradient(to bottom right,
  ${PdfPalette.brand} 50%, transparent 50.6%); }
.rb-tab::after { bottom: 0; background: linear-gradient(to top right,
  ${PdfPalette.brand} 50%, transparent 50.6%); }
.rb-title { font-size: 22pt; font-weight: 700; text-transform: uppercase;
  letter-spacing: 1.5px; line-height: 1.1; }
.rb-num { font-size: 10.5pt; color: rgba(255, 255, 255, 0.9); }
.rb-seller { text-align: right; max-width: 50%; }
.rb-seller .party-name { font-size: 13pt; color: ${PdfPalette.deep}; }
.stamp { color: ${PdfPalette.muted}; }
.rb-row { display: flex; justify-content: space-between; gap: 10mm;
  padding: 4mm 0; margin-bottom: 5mm; border-top: 1px solid ${PdfPalette.line};
  border-bottom: 1px solid ${PdfPalette.line}; }
.rb-meta { min-width: 64mm; }
.label { color: ${PdfPalette.brand}; }
.items th { color: ${PdfPalette.deep}; border-top: 2px solid ${PdfPalette.brand};
  border-bottom: 1px solid ${PdfPalette.brand}; }
.totals { width: calc(50% + 14mm); margin-right: -14mm; }
.totals td:last-child { padding-right: 14mm; }
.totals .grand td { background: ${PdfPalette.brand}; color: #FFFFFF; }
.totals .grand td:first-child { border-left: 1.6mm solid ${PdfPalette.pair}; }
''';
}
