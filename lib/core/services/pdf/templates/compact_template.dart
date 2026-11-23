import '../models/pdf_document.dart';
import '../pdf_html.dart';
import '../pdf_page_size.dart';
import '../pdf_palette.dart';

/// Compact: high-density itemized table with striped rows, condensed type,
/// and tight margins suited for wholesalers, suppliers, and parts distributors
/// with 15+ line items.
abstract final class CompactTemplate {
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
<div class="compact-head keep">
  <div class="seller-col">
    ${PdfHtml.logo(doc.seller)}
    <div class="seller-name">${PdfHtml.esc(doc.seller.name)}</div>
    ${doc.seller.lines.where((l) => l.trim().isNotEmpty).map((l) => '<span class="seller-info">${PdfHtml.esc(l)}</span>').join(' · ')}
  </div>
  <div class="meta-col">
    <div class="compact-title">${PdfHtml.esc(doc.title)} <span class="compact-num">${PdfHtml.esc(doc.number)}</span></div>
    ${stamp == null ? '' : '<div class="stamp">${PdfHtml.esc(stamp)}</div>'}
    <div class="meta-inline">
      ${doc.meta.map((f) => '<span class="meta-pill"><span class="meta-lbl">${PdfHtml.esc(f.label)}:</span> ${PdfHtml.esc(f.value)}</span>').join(' ')}
    </div>
  </div>
</div>
${buyer == null ? '' : '<div class="buyer-bar keep"><span class="buyer-lbl">${PdfHtml.esc(doc.buyerHeading)}:</span> <strong>${PdfHtml.esc(buyer.name)}</strong>${buyer.lines.where((l) => l.trim().isNotEmpty).map((l) => ' · ${PdfHtml.esc(l)}').join()}</div>'}
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
body { font-size: 8.5pt; line-height: 1.35; }
.compact-head {
  display: flex;
  justify-content: space-between;
  gap: 6mm;
  padding-bottom: 3.5mm;
  border-bottom: 1.5px solid ${PdfPalette.brand};
}
.seller-col { max-width: 55%; }
.seller-name { font-size: 11.5pt; font-weight: 700; color: ${PdfPalette.brand}; }
.seller-info { font-size: 7.5pt; color: ${PdfPalette.muted}; }
.meta-col { text-align: right; }
.compact-title { font-size: 14pt; font-weight: 800; color: ${PdfPalette.ink}; text-transform: uppercase; }
.compact-num { color: ${PdfPalette.brand}; margin-left: 2mm; }
.stamp {
  display: inline-block;
  background: ${PdfPalette.brandSoft};
  color: ${PdfPalette.brand};
  padding: 0.2mm 2.5mm;
  border-radius: 1mm;
  font-size: 7.5pt;
  font-weight: 600;
  margin: 1mm 0;
}
.meta-inline { margin-top: 1.5mm; }
.meta-pill {
  display: inline-block;
  font-size: 7.5pt;
  background: ${PdfPalette.zebra};
  padding: 0.5mm 2mm;
  border-radius: 1mm;
  margin-left: 1mm;
  border: 0.5px solid ${PdfPalette.line};
}
.meta-lbl { color: ${PdfPalette.muted}; }
.buyer-bar {
  background: ${PdfPalette.zebra};
  border-left: 3px solid ${PdfPalette.brand};
  padding: 1.8mm 3mm;
  margin: 3mm 0 3.5mm;
  font-size: 8pt;
}
.buyer-lbl { font-weight: 700; color: ${PdfPalette.brand}; text-transform: uppercase; margin-right: 1.5mm; }
.items th {
  background: ${PdfPalette.brand};
  color: #FFFFFF;
  font-size: 7.5pt;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  padding: 1.5mm 2mm;
}
.items td {
  padding: 1.4mm 2mm;
  border-bottom: 0.5px solid ${PdfPalette.line};
  vertical-align: middle;
}
.items tbody tr:nth-child(even) td { background: #F8FAFC; }
.totals-wrap { display: flex; justify-content: flex-end; margin-top: 3mm; }
.totals { width: 45%; }
.totals td { padding: 0.9mm 2mm; font-size: 8.5pt; }
.totals td:first-child { color: ${PdfPalette.muted}; }
.totals .grand td {
  background: ${PdfPalette.brand};
  color: #FFFFFF;
  font-weight: 700;
  font-size: 10.5pt;
  padding: 1.8mm 2mm;
}
.totals .after td:last-child { font-weight: 700; }
.bottom {
  margin-top: 5mm;
  display: flex;
  justify-content: space-between;
  gap: 6mm;
  align-items: flex-end;
}
.note-h { font-weight: 700; font-size: 8pt; color: ${PdfPalette.brand}; text-transform: uppercase; }
.sign { text-align: center; margin-left: auto; }
.sign-line { border-top: 1px solid ${PdfPalette.line}; padding-top: 1mm; min-width: 40mm; font-size: 7.5pt; }
''';
}
