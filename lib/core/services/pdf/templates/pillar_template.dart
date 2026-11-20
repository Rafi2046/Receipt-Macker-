import '../models/pdf_document.dart';
import '../pdf_blocks.dart';
import '../pdf_html.dart';
import '../pdf_palette.dart';

/// Pillar: tall rounded color side panel (on every page) holding the
/// seller, buyer and dates; the items sit on white beside it.
abstract final class PillarTemplate {
  static String body(PdfDocument doc) =>
      '''
<div class="pl-rail"></div>
<div class="pl-side on-dark">
  ${PdfHtml.logo(doc.seller)}
  <div class="pl-name">${PdfHtml.esc(doc.seller.name)}</div>
  ${PdfBlocks.sellerLines(doc, cls: 'pl-line')}
  <div class="pl-rule"></div>
  ${PdfBlocks.buyer(doc)}
  <div class="pl-rule"></div>
  ${PdfBlocks.meta(doc)}
</div>
<div class="pl-main">
  <div class="pl-head keep">
    <div class="pl-title">${PdfHtml.esc(doc.title)}</div>
    <div class="pl-num">${PdfHtml.esc(doc.number)}</div>
    ${PdfBlocks.stamp(doc)}
  </div>
  ${PdfBlocks.rest(doc)}
</div>
''';

  static const String css =
      '''
.pl-rail { position: fixed; top: 0; bottom: 0; left: 0; width: 52mm;
  border-radius: 4mm; background: linear-gradient(180deg, ${PdfPalette.brand} 0%, ${PdfPalette.deep} 100%); }
.pl-side { position: absolute; top: 7mm; left: 6mm; width: 40mm;
  color: #FFFFFF; font-size: 9pt; }
.pl-name { font-size: 13pt; font-weight: 700; margin-top: 1.5mm;
  line-height: 1.25; }
.pl-line, .pl-side .muted { color: rgba(255, 255, 255, 0.82);
  font-size: 8.5pt; }
.pl-rule { height: 0.6mm; width: 12mm; background: ${PdfPalette.pair}; margin: 5mm 0 4mm; }
.pl-side .label { color: rgba(255, 255, 255, 0.7); }
.pl-side .meta td { display: block; padding: 0; text-align: left !important;
  white-space: normal; }
.pl-side .meta td:first-child { color: rgba(255, 255, 255, 0.7);
  font-size: 7.5pt; text-transform: uppercase; letter-spacing: 0.8px;
  padding-top: 1.6mm; }
.pl-side .meta td:last-child { font-weight: 700; }
.pl-main { margin-left: 59mm; padding-top: 5mm; }
.pl-head { margin-bottom: 7mm; }
.pl-title { font-size: 25pt; font-weight: 700; color: ${PdfPalette.brand};
  text-transform: uppercase; letter-spacing: 1px; line-height: 1.1; }
.pl-num { font-size: 11.5pt; font-weight: 700; color: ${PdfPalette.ink}; }
.stamp { color: ${PdfPalette.muted}; }
.items th { color: ${PdfPalette.brand}; border-bottom: 2px solid ${PdfPalette.brand}; }
.items th:first-child { width: 40%; }
.totals { width: 72%; }
.totals .grand td { background: ${PdfPalette.brandSoft}; color: ${PdfPalette.brand}; border-left: 0 solid ${PdfPalette.brand}; }
.totals .grand td:first-child { border-left: 1.4mm solid ${PdfPalette.brand}; }
''';
}
