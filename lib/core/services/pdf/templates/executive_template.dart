import '../models/pdf_document.dart';
import '../pdf_blocks.dart';
import '../pdf_html.dart';
import '../pdf_page_size.dart';
import '../pdf_palette.dart';

/// Executive: formal corporate letterhead with a dark accent header block,
/// refined gold rule, structured metadata cards, and formal totals summary.
abstract final class ExecutiveTemplate {
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
<div class="head-banner keep">
  <div class="seller-box">
    ${PdfHtml.logo(doc.seller)}
    <div class="seller-name">${PdfHtml.esc(doc.seller.name)}</div>
    ${doc.seller.lines.where((l) => l.trim().isNotEmpty).map((l) => '<div class="seller-line">${PdfHtml.multiline(l)}</div>').join()}
  </div>
  <div class="invoice-box">
    <div class="invoice-title">${PdfHtml.esc(doc.title)}</div>
    <div class="invoice-number">${PdfHtml.esc(doc.number)}</div>
    ${stamp == null ? '' : '<div class="stamp">${PdfHtml.esc(stamp)}</div>'}
  </div>
</div>
<div class="accent-rule"></div>
<div class="meta-section keep">
  <div class="meta-card">
    <div class="section-label">${PdfHtml.esc(doc.buyerHeading)}</div>
    ${buyer == null ? '<div class="muted">—</div>' : PdfHtml.party(buyer)}
  </div>
  <div class="meta-card">
    <table class="meta-table">${PdfHtml.fieldRows(doc.meta)}</table>
  </div>
</div>
<table class="items">
  <thead>${PdfHtml.columnHeads(doc)}</thead>
  <tbody>${PdfHtml.lineRows(doc)}</tbody>
</table>
<div class="totals-wrap keep">
  <table class="totals">
    ${PdfHtml.fieldRows(doc.totals)}
    <tr class="grand">
      <td>${PdfHtml.esc(doc.grandTotal.label)}</td>
      <td class="num">${PdfHtml.esc(doc.grandTotal.value)}</td>
    </tr>
    ${PdfHtml.fieldRows(doc.afterTotal, rowClass: 'after')}
  </table>
</div>
<div class="bottom keep">
  ${PdfHtml.notes(doc)}
  ${PdfHtml.signature(doc)}
</div>
''';
  }

  static const String _css =
      '''
${PdfBlocks.bleedCss}.head-banner {
  background: ${PdfPalette.brand};
  color: #FFFFFF;
  padding: 8mm 9mm;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin: -14mm -14mm 0 -14mm;
}
.seller-box { max-width: 55%; }
.seller-name { font-size: 15pt; font-weight: 700; color: #FFFFFF; margin-top: 1.5mm; }
.seller-line { font-size: 8.5pt; color: rgba(255, 255, 255, 0.85); line-height: 1.35; }
.invoice-box { text-align: right; }
.invoice-title { font-size: 20pt; font-weight: 700; text-transform: uppercase; letter-spacing: 1.5px; color: #FFFFFF; }
.invoice-number { font-size: 11.5pt; color: rgba(255, 255, 255, 0.9); font-weight: 600; margin-top: 1mm; }
.stamp {
  display: inline-block;
  background: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.5);
  color: #FFFFFF;
  padding: 0.5mm 3mm;
  border-radius: 2mm;
  font-size: 8pt;
  margin-top: 1.5mm;
  text-transform: uppercase;
}
.accent-rule { height: 1.2mm; background: ${PdfPalette.pair}; margin: 0 -14mm 6mm -14mm; }
.meta-section { display: flex; gap: 8mm; margin-bottom: 6mm; }
.meta-card { flex: 1; background: #F8FAFC; border: 1px solid #E2E8F0; border-radius: 2mm; padding: 3mm 4mm; }
.section-label { font-size: 8pt; font-weight: 700; text-transform: uppercase; letter-spacing: 0.8px; color: ${PdfPalette.brand}; margin-bottom: 1.5mm; }
.meta-table td { padding: 0.6mm 0; font-size: 9pt; }
.meta-table td:first-child { color: ${PdfPalette.muted}; font-weight: 500; }
.items th {
  background: #F1F5F9;
  color: ${PdfPalette.ink};
  font-size: 8.5pt;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.6px;
  padding: 2.5mm 3mm;
  border-top: 1px solid #CBD5E1;
  border-bottom: 1px solid #CBD5E1;
}
.items td { padding: 2.2mm 3mm; border-bottom: 1px solid ${PdfPalette.line}; vertical-align: top; }
.totals-wrap { display: flex; justify-content: flex-end; margin-top: 4mm; }
.totals { width: 50%; border: 1px solid #E2E8F0; border-radius: 2mm; overflow: hidden; }
.totals td { padding: 1.5mm 3mm; font-size: 9.5pt; }
.totals td:first-child { color: ${PdfPalette.muted}; }
.totals .grand td {
  background: ${PdfPalette.brand};
  color: #FFFFFF;
  font-weight: 700;
  font-size: 12pt;
  padding: 2.5mm 3mm;
}
.totals .after td:last-child { font-weight: 700; }
.bottom { margin-top: 8mm; display: flex; justify-content: space-between; gap: 8mm; align-items: flex-end; }
.note-h { font-weight: 700; font-size: 8.5pt; color: ${PdfPalette.brand}; text-transform: uppercase; letter-spacing: 0.5px; }
.sign { text-align: center; margin-left: auto; }
.sign-line { border-top: 1px solid ${PdfPalette.line}; padding-top: 1mm; min-width: 45mm; font-size: 8pt; }
''';
}
