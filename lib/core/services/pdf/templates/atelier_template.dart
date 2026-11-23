import '../models/pdf_document.dart';
import '../pdf_html.dart';
import '../pdf_page_size.dart';
import '../pdf_palette.dart';

/// Atelier: airy creative layout — thin left accent rail, open spacing,
/// soft zebra rows. Premium without heavy color fills.
abstract final class AtelierTemplate {
  static String render(
    PdfDocument doc, {
    required String fontsCss,
    PdfPageSize size = PdfPageSize.a4,
    String? accentColor,
    String? accentSoftColor,
  }) => PdfHtml.page(
    doc: doc,
    fontsCss: fontsCss,
    templateCss: _css,
    size: size,
    accentColor: accentColor,
    accentSoftColor: accentSoftColor,
    body: _body(doc),
  );

  static String _body(PdfDocument doc) {
    final buyer = doc.buyer;
    final stamp = doc.badgeStamp;
    return '''
<div class="frame">
  <div class="rail"></div>
  <div class="content">
    <div class="head keep">
      <div>
        <div class="eyebrow">${PdfHtml.esc(doc.number)}${stamp == null ? '' : ' · ${PdfHtml.esc(stamp)}'}</div>
        <div class="title">${PdfHtml.esc(doc.title)}</div>
      </div>
      <div class="seller">${PdfHtml.logo(doc.seller)}${PdfHtml.party(doc.seller)}</div>
    </div>
    <div class="info keep">
      ${buyer == null ? '<div></div>' : '<div><div class="label">${PdfHtml.esc(doc.buyerHeading)}</div>${PdfHtml.party(buyer)}</div>'}
      <table class="meta">${PdfHtml.fieldRows(doc.meta)}</table>
    </div>
    <table class="items"><thead>${PdfHtml.columnHeads(doc)}</thead>
    <tbody>${PdfHtml.lineRows(doc)}</tbody></table>
    <div class="totals-wrap keep"><table class="totals">
    ${PdfHtml.fieldRows(doc.totals)}
    <tr class="grand"><td>${PdfHtml.esc(doc.grandTotal.label)}</td><td class="num">${PdfHtml.esc(doc.grandTotal.value)}</td></tr>
    ${PdfHtml.fieldRows(doc.afterTotal, rowClass: 'after')}
    </table></div>
    <div class="bottom">${PdfHtml.notes(doc)}${PdfHtml.signature(doc)}</div>
  </div>
</div>
''';
  }

  static const String _css =
      '''
.frame { display: flex; gap: 0; }
.rail { width: 2.5mm; background: ${PdfPalette.brand}; flex-shrink: 0;
  border-radius: 1mm; margin-right: 6mm; min-height: 100%; }
.content { flex: 1; min-width: 0; }
.head { display: flex; justify-content: space-between; gap: 8mm;
  margin-bottom: 7mm; align-items: flex-start; }
.eyebrow { font-size: 8.5pt; color: ${PdfPalette.muted}; letter-spacing: 0.5px;
  margin-bottom: 1.5mm; }
.title { font-size: 22pt; font-weight: 700; line-height: 1.05;
  color: ${PdfPalette.ink}; }
.seller { text-align: right; max-width: 48%; }
.party-name { font-weight: 700; font-size: 10.5pt; }
.info { display: flex; justify-content: space-between; gap: 8mm;
  margin-bottom: 6mm; padding: 4mm; background: ${PdfPalette.brandSoft};
  border-radius: 2mm; }
.label { font-size: 7.5pt; font-weight: 700; text-transform: uppercase;
  letter-spacing: 1px; color: ${PdfPalette.brand}; margin-bottom: 1mm; }
.meta { width: auto; }
.meta td { padding: 0.4mm 0 0.4mm 5mm; font-size: 9pt; }
.meta td:first-child { color: ${PdfPalette.muted}; padding-left: 0; }
.items th { text-align: left; font-weight: 700; font-size: 8pt;
  color: ${PdfPalette.muted}; text-transform: uppercase; letter-spacing: 0.6px;
  padding: 2mm 2.5mm; border-bottom: 1px solid ${PdfPalette.line}; }
.items td { padding: 2.2mm 2.5mm; vertical-align: top; }
.items tbody tr:nth-child(even) td { background: ${PdfPalette.brandSoft}; }
.totals-wrap { display: flex; justify-content: flex-end; margin-top: 4mm; }
.totals { width: 44%; }
.totals td { padding: 1.2mm 2.5mm; }
.totals td:first-child { color: ${PdfPalette.muted}; }
.totals .grand td { font-weight: 700; font-size: 12pt;
  color: ${PdfPalette.brand}; padding-top: 2mm; }
.totals .after td:last-child { font-weight: 700; }
.bottom { margin-top: 9mm; display: flex; justify-content: space-between;
  gap: 10mm; align-items: flex-end; }
.note-h { font-weight: 700; font-size: 8pt; text-transform: uppercase;
  letter-spacing: 1px; color: ${PdfPalette.muted}; }
.sign { text-align: center; margin-left: auto; }
.sign-line { border-top: 1px solid ${PdfPalette.ink}; padding-top: 1mm;
  min-width: 45mm; }
''';
}
