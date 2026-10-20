import '../models/pdf_document.dart';
import '../pdf_html.dart';
import '../pdf_page_size.dart';
import '../pdf_palette.dart';

/// Minimal: black and white, thin rules, compact type. Prints well on
/// any printer and photocopies cleanly.
abstract final class MinimalTemplate {
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
  <div class="right">
    <div class="title">${PdfHtml.esc(doc.title)}${stamp == null ? '' : ' (${PdfHtml.esc(stamp)})'}</div>
    <div class="number">${PdfHtml.esc(doc.number)}</div>
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
body { font-size: 9.5pt; }
.head { display: flex; justify-content: space-between; gap: 10mm;
  padding-bottom: 4mm; border-bottom: 1px solid ${PdfPalette.ink}; }
.seller { max-width: 55%; }
.party-name { font-weight: 700; font-size: 11pt; }
.right { text-align: right; }
.title { font-size: 14pt; font-weight: 700; text-transform: uppercase;
  letter-spacing: 2px; }
.number { font-weight: 700; margin-bottom: 1.5mm; }
.meta td { padding: 0.3mm 0 0.3mm 4mm; }
.meta td:first-child { color: ${PdfPalette.muted}; }
.buyer { margin: 5mm 0; }
.label { font-size: 8pt; text-transform: uppercase; letter-spacing: 1px;
  color: ${PdfPalette.muted}; }
.items th { text-align: left; font-weight: 700; padding: 1.5mm 2mm;
  border-top: 1px solid ${PdfPalette.ink};
  border-bottom: 1px solid ${PdfPalette.ink}; }
.items td { padding: 1.5mm 2mm; border-bottom: 0.5px solid ${PdfPalette.line};
  vertical-align: top; }
.totals-wrap { display: flex; justify-content: flex-end; margin-top: 3mm; }
.totals { width: 45%; }
.totals td { padding: 0.8mm 2mm; }
.totals .grand td { font-weight: 700; font-size: 11pt;
  border-top: 1px solid ${PdfPalette.ink};
  border-bottom: 1px solid ${PdfPalette.ink}; padding: 1.8mm 2mm; }
.totals .after td:last-child { font-weight: 700; }
.bottom { margin-top: 7mm; display: flex; justify-content: space-between;
  gap: 10mm; align-items: flex-end; }
.note { margin-bottom: 3mm; }
.note-h { font-weight: 700; font-size: 8.5pt; text-transform: uppercase;
  letter-spacing: 1px; }
.sign { text-align: center; margin-left: auto; }
.sign-line { border-top: 1px solid ${PdfPalette.ink}; padding-top: 1mm;
  min-width: 45mm; }
''';
}
