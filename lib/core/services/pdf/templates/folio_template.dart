import '../models/pdf_document.dart';
import '../pdf_html.dart';
import '../pdf_page_size.dart';
import '../pdf_palette.dart';

/// Folio: clean magazine-style document — large title, soft gray table head,
/// restrained accent on labels only.
abstract final class FolioTemplate {
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
<div class="mast keep">
  <div class="title">${PdfHtml.esc(doc.title)}</div>
  <div class="mast-right">
    <div class="number">${PdfHtml.esc(doc.number)}</div>
    ${stamp == null ? '' : '<div class="stamp">${PdfHtml.esc(stamp)}</div>'}
    <table class="meta">${PdfHtml.fieldRows(doc.meta)}</table>
  </div>
</div>
<div class="parties keep">
  <div class="party-col">
    ${PdfHtml.logo(doc.seller)}${PdfHtml.party(doc.seller)}
  </div>
  ${buyer == null ? '' : '<div class="party-col"><div class="label">${PdfHtml.esc(doc.buyerHeading)}</div>${PdfHtml.party(buyer)}</div>'}
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
.mast { display: flex; justify-content: space-between; align-items: flex-end;
  gap: 10mm; margin-bottom: 8mm; padding-bottom: 5mm;
  border-bottom: 1px solid ${PdfPalette.line}; }
.title { font-size: 28pt; font-weight: 700; line-height: 1; letter-spacing: -0.5px;
  color: ${PdfPalette.ink}; }
.mast-right { text-align: right; }
.number { font-size: 11pt; font-weight: 700; }
.stamp { font-size: 8pt; color: ${PdfPalette.brand}; margin: 1mm 0; }
.meta td { padding: 0.3mm 0 0.3mm 5mm; font-size: 8.5pt; }
.meta td:first-child { color: ${PdfPalette.muted}; }
.parties { display: flex; gap: 8mm; margin-bottom: 7mm; }
.party-col { flex: 1; max-width: 48%; }
.party-name { font-weight: 700; font-size: 11pt; margin-top: 1mm; }
.label { font-size: 7.5pt; font-weight: 700; text-transform: uppercase;
  letter-spacing: 1.2px; color: ${PdfPalette.brand}; margin-bottom: 1.5mm; }
.items th { text-align: left; font-weight: 700; font-size: 8pt;
  text-transform: uppercase; letter-spacing: 0.5px; color: ${PdfPalette.ink};
  background: ${PdfPalette.brandSoft}; padding: 2.2mm 2.5mm; }
.items td { padding: 2.2mm 2.5mm; border-bottom: 1px solid ${PdfPalette.line};
  vertical-align: top; }
.totals-wrap { display: flex; justify-content: flex-end; margin-top: 4mm; }
.totals { width: 46%; }
.totals td { padding: 1.2mm 2.5mm; }
.totals td:first-child { color: ${PdfPalette.muted}; }
.totals .grand td { font-weight: 700; font-size: 12pt;
  border-top: 1.5px solid ${PdfPalette.ink}; padding-top: 2.5mm; }
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
