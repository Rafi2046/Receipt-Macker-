import '../models/pdf_document.dart';
import '../pdf_html.dart';
import '../pdf_page_size.dart';
import '../pdf_palette.dart';

/// Nordic: quiet Scandinavian invoice — whitespace, hairlines, accent only
/// on the total underline. Reads premium without loud color blocks.
abstract final class NordicTemplate {
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
    final stamp = doc.stamp;
    return '''
<div class="head keep">
  <div class="seller">${PdfHtml.logo(doc.seller)}${PdfHtml.party(doc.seller)}</div>
  <div class="doc">
    <div class="title">${PdfHtml.esc(doc.title)}</div>
    <div class="number">${PdfHtml.esc(doc.number)}</div>
    ${stamp == null ? '' : '<div class="stamp">${PdfHtml.esc(stamp)}</div>'}
  </div>
</div>
<div class="meta-row keep">
  ${buyer == null ? '<div></div>' : '<div class="buyer"><div class="label">${PdfHtml.esc(doc.buyerHeading)}</div>${PdfHtml.party(buyer)}</div>'}
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
''';
  }

  static const String _css =
      '''
body { font-size: 9.5pt; letter-spacing: 0.01em; }
.head { display: flex; justify-content: space-between; gap: 12mm;
  padding-bottom: 5mm; margin-bottom: 6mm;
  border-bottom: 0.5px solid ${PdfPalette.line}; }
.seller { max-width: 58%; }
.party-name { font-weight: 600; font-size: 12pt; color: ${PdfPalette.ink}; }
.doc { text-align: right; }
.title { font-size: 11pt; font-weight: 600; letter-spacing: 3px;
  text-transform: uppercase; color: ${PdfPalette.muted}; }
.number { font-size: 13pt; font-weight: 700; margin-top: 1.5mm; }
.stamp { display: inline-block; margin-top: 2mm; font-size: 8pt;
  color: ${PdfPalette.muted}; letter-spacing: 1px; text-transform: uppercase; }
.meta-row { display: flex; justify-content: space-between; gap: 10mm;
  margin-bottom: 7mm; }
.buyer { max-width: 50%; }
.label { font-size: 7.5pt; text-transform: uppercase; letter-spacing: 1.5px;
  color: ${PdfPalette.muted}; margin-bottom: 1mm; }
.meta { width: auto; }
.meta td { padding: 0.4mm 0 0.4mm 6mm; font-size: 9pt; }
.meta td:first-child { color: ${PdfPalette.muted}; padding-left: 0; }
.items th { text-align: left; font-weight: 600; font-size: 7.5pt;
  text-transform: uppercase; letter-spacing: 1px; color: ${PdfPalette.muted};
  padding: 2mm 2mm; border-bottom: 0.5px solid ${PdfPalette.ink}; }
.items td { padding: 2.2mm 2mm; border-bottom: 0.5px solid ${PdfPalette.line};
  vertical-align: top; }
.totals-wrap { display: flex; justify-content: flex-end; margin-top: 5mm; }
.totals { width: 42%; }
.totals td { padding: 1mm 2mm; font-size: 9.5pt; }
.totals td:first-child { color: ${PdfPalette.muted}; }
.totals .grand td { font-weight: 700; font-size: 12pt; color: ${PdfPalette.ink};
  padding-top: 2.5mm; border-bottom: 2px solid ${PdfPalette.brand}; }
.totals .after td:last-child { font-weight: 700; }
.bottom { margin-top: 10mm; display: flex; justify-content: space-between;
  gap: 10mm; align-items: flex-end; }
.note-h { font-weight: 600; font-size: 8pt; text-transform: uppercase;
  letter-spacing: 1px; color: ${PdfPalette.muted}; }
.sign { text-align: center; margin-left: auto; }
.sign-line { border-top: 0.5px solid ${PdfPalette.ink}; padding-top: 1mm;
  min-width: 42mm; }
''';
}
