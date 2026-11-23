import '../models/pdf_document.dart';
import '../pdf_html.dart';
import '../pdf_page_size.dart';
import '../pdf_palette.dart';

/// Lumen: soft modern — light wash header (not a solid color block),
/// clean body, accent used sparingly for total and labels.
abstract final class LumenTemplate {
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
<div class="hero keep">
  <div class="hero-left">
    ${PdfHtml.logo(doc.seller)}
    ${PdfHtml.party(doc.seller)}
  </div>
  <div class="hero-right">
    <div class="title">${PdfHtml.esc(doc.title)}</div>
    <div class="number">${PdfHtml.esc(doc.number)}</div>
    ${stamp == null ? '' : '<div class="stamp">${PdfHtml.esc(stamp)}</div>'}
  </div>
</div>
<div class="grid keep">
  ${buyer == null ? '<div></div>' : '<div class="card"><div class="label">${PdfHtml.esc(doc.buyerHeading)}</div>${PdfHtml.party(buyer)}</div>'}
  <div class="card"><table class="meta">${PdfHtml.fieldRows(doc.meta)}</table></div>
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
.hero { display: flex; justify-content: space-between; gap: 10mm;
  padding: 5mm 5mm 5mm; margin: -2mm -2mm 6mm; background: ${PdfPalette.brandSoft};
  border-radius: 2.5mm; border-left: 3px solid ${PdfPalette.brand}; }
.hero-left { max-width: 55%; }
.party-name { font-weight: 700; font-size: 12pt; color: ${PdfPalette.ink}; }
.hero-right { text-align: right; }
.title { font-size: 18pt; font-weight: 700; color: ${PdfPalette.ink};
  letter-spacing: 0.5px; }
.number { font-size: 11pt; font-weight: 600; margin-top: 1mm;
  color: ${PdfPalette.brand}; }
.stamp { display: inline-block; margin-top: 2mm; padding: 0.5mm 2.5mm;
  border-radius: 3mm; background: ${PdfPalette.paper}; font-size: 8pt;
  color: ${PdfPalette.muted}; }
.grid { display: flex; gap: 4mm; margin-bottom: 6mm; }
.card { flex: 1; padding: 3.5mm; border: 1px solid ${PdfPalette.line};
  border-radius: 2mm; }
.label { font-size: 7.5pt; font-weight: 700; text-transform: uppercase;
  letter-spacing: 1px; color: ${PdfPalette.brand}; margin-bottom: 1.5mm; }
.meta td { padding: 0.5mm 0; font-size: 9pt; }
.meta td:first-child { color: ${PdfPalette.muted}; width: 40%; }
.items th { text-align: left; font-weight: 700; font-size: 8pt;
  color: ${PdfPalette.ink}; padding: 2mm 2.5mm;
  border-bottom: 2px solid ${PdfPalette.brand}; }
.items td { padding: 2.2mm 2.5mm; border-bottom: 1px solid ${PdfPalette.line};
  vertical-align: top; }
.totals-wrap { display: flex; justify-content: flex-end; margin-top: 4mm; }
.totals { width: 46%; }
.totals td { padding: 1.2mm 2.5mm; }
.totals td:first-child { color: ${PdfPalette.muted}; }
.totals .grand td { font-weight: 700; font-size: 12pt;
  background: ${PdfPalette.brandSoft}; color: ${PdfPalette.ink};
  padding: 2.5mm; border-radius: 1.5mm; }
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
