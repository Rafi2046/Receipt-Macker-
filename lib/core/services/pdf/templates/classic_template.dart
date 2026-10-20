import '../models/pdf_document.dart';
import '../pdf_html.dart';
import '../pdf_page_size.dart';
import '../pdf_palette.dart';

/// Classic: seller and logo on the left, a green title on the right, a
/// green table header and a green total bar.
abstract final class ClassicTemplate {
  static String render(
    PdfDocument doc, {
    required String fontsCss,
    PdfPageSize size = PdfPageSize.a4,
  }) => PdfHtml.page(
    doc: doc,
    fontsCss: fontsCss,
    templateCss: _css,
    size: size,
    body: _body(doc),
  );

  static String _body(PdfDocument doc) {
    final buyer = doc.buyer;
    final stamp = doc.stamp;
    return '''
<div class="head keep">
  <div class="seller">${PdfHtml.logo(doc.seller)}${PdfHtml.party(doc.seller)}</div>
  <div class="title-box">
    <div class="title">${PdfHtml.esc(doc.title)}</div>
    <div class="number">${PdfHtml.esc(doc.number)}</div>
    ${stamp == null ? '' : '<div class="stamp">${PdfHtml.esc(stamp)}</div>'}
    <table class="meta">${PdfHtml.fieldRows(doc.meta)}</table>
  </div>
</div>
${buyer == null ? '' : '<div class="buyer keep"><div class="label">${PdfHtml.esc(doc.buyerHeading)}</div>${PdfHtml.party(buyer)}</div>'}
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
.head { display: flex; justify-content: space-between; gap: 10mm;
  padding-bottom: 6mm; border-bottom: 2px solid ${PdfPalette.brand}; }
.seller { max-width: 55%; }
.party-name { font-weight: 700; font-size: 13pt; color: ${PdfPalette.brand};
  margin-top: 2mm; }
.title-box { text-align: right; }
.title { font-size: 24pt; font-weight: 700; color: ${PdfPalette.brand};
  text-transform: uppercase; letter-spacing: 1px; line-height: 1.1; }
.number { font-size: 12pt; font-weight: 700; margin: 1mm 0 2mm; }
.stamp { display: inline-block; border: 1px solid ${PdfPalette.accent};
  color: ${PdfPalette.accent}; padding: 0 3mm; border-radius: 3mm;
  font-size: 8.5pt; margin-bottom: 2mm; }
.meta td { padding: 0.5mm 0 0.5mm 4mm; }
.meta td:first-child { color: ${PdfPalette.muted}; }
.buyer { margin: 6mm 0; }
.buyer .party-name { color: ${PdfPalette.ink}; font-size: 11pt; margin: 0; }
.label { font-size: 8.5pt; font-weight: 700; color: ${PdfPalette.brand};
  text-transform: uppercase; letter-spacing: 0.5px; }
.items th { background: ${PdfPalette.brand}; color: ${PdfPalette.paper}; font-weight: 700;
  text-align: left; padding: 2mm 2.5mm; }
.items td { padding: 2mm 2.5mm; border-bottom: 1px solid ${PdfPalette.line};
  vertical-align: top; }
.totals-wrap { display: flex; justify-content: flex-end; margin-top: 4mm; }
.totals { width: 48%; }
.totals td { padding: 1.2mm 2.5mm; }
.totals td:first-child { color: ${PdfPalette.muted}; }
.totals .grand td { background: ${PdfPalette.brand}; color: ${PdfPalette.paper};
  font-weight: 700; font-size: 12pt; padding: 2.5mm; }
.totals .after td:last-child { font-weight: 700; }
.bottom { margin-top: 8mm; display: flex; justify-content: space-between;
  gap: 10mm; align-items: flex-end; }
.note { margin-bottom: 4mm; }
.note-h { font-weight: 700; color: ${PdfPalette.brand}; font-size: 9pt; }
.sign { text-align: center; margin-left: auto; }
.sign-line { border-top: 1px solid ${PdfPalette.line}; padding-top: 1mm;
  min-width: 45mm; }
''';
}
