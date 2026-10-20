import '../models/pdf_document.dart';
import '../pdf_html.dart';
import '../pdf_page_size.dart';
import '../pdf_palette.dart';

/// Modern: a gold accent bar, a large title, soft boxes for the buyer and
/// dates, zebra rows and a large total with a gold underline.
abstract final class ModernTemplate {
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
<div class="bar"></div>
<div class="head keep">
  <div>
    <div class="title">${PdfHtml.esc(doc.title)}</div>
    <div class="number">${PdfHtml.esc(doc.number)}${stamp == null ? '' : ' · ${PdfHtml.esc(stamp)}'}</div>
  </div>
  <div class="seller">${PdfHtml.logo(doc.seller)}${PdfHtml.party(doc.seller)}</div>
</div>
<div class="boxes keep">
  <div class="box">${buyer == null ? '' : '<div class="label">${PdfHtml.esc(doc.buyerHeading)}</div>${PdfHtml.party(buyer)}'}</div>
  <div class="box"><table class="meta">${PdfHtml.fieldRows(doc.meta)}</table></div>
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
.bar { height: 2.5mm; background: ${PdfPalette.accent}; margin-bottom: 6mm; }
.head { display: flex; justify-content: space-between; gap: 10mm;
  align-items: flex-start; }
.title { font-size: 28pt; font-weight: 700; line-height: 1.05; }
.number { color: ${PdfPalette.muted}; font-size: 11pt; margin-top: 1mm; }
.seller { text-align: right; max-width: 55%; }
.party-name { font-weight: 700; font-size: 11pt; }
.boxes { display: flex; gap: 5mm; margin: 7mm 0 6mm; }
.box { flex: 1; background: ${PdfPalette.brandSoft}; border-radius: 3mm;
  padding: 3.5mm 4mm; }
.label { font-size: 8pt; color: ${PdfPalette.brand}; font-weight: 700;
  text-transform: uppercase; letter-spacing: 0.6px; margin-bottom: 1mm; }
.meta td { padding: 0.5mm 0; }
.meta td:first-child { color: ${PdfPalette.muted}; }
.items th { text-align: left; font-size: 8pt; font-weight: 700;
  color: ${PdfPalette.muted}; text-transform: uppercase; letter-spacing: 0.5px;
  padding: 2mm 2.5mm; border-bottom: 2px solid ${PdfPalette.brand}; }
.items td { padding: 2.2mm 2.5mm; vertical-align: top; }
.items tbody tr:nth-child(even) td { background: ${PdfPalette.zebra}; }
.totals-wrap { display: flex; justify-content: flex-end; margin-top: 5mm; }
.totals { width: 50%; }
.totals td { padding: 1.2mm 2.5mm; }
.totals td:first-child { color: ${PdfPalette.muted}; }
.totals .grand td { font-size: 15pt; font-weight: 700; padding-top: 3mm;
  border-bottom: 2.5px solid ${PdfPalette.accent}; }
.totals .grand td:first-child { color: ${PdfPalette.ink}; }
.totals .after td:last-child { font-weight: 700; }
.bottom { margin-top: 9mm; display: flex; justify-content: space-between;
  gap: 10mm; align-items: flex-end; }
.note { margin-bottom: 4mm; }
.note-h { font-weight: 700; font-size: 9pt; color: ${PdfPalette.brand}; }
.sign { text-align: center; margin-left: auto; }
.sign-line { border-top: 1px solid ${PdfPalette.line}; padding-top: 1mm;
  min-width: 45mm; }
''';
}
