import '../models/pdf_document.dart';
import '../pdf_html.dart';
import '../pdf_page_size.dart';
import '../pdf_palette.dart';

/// Studio: left vertical accent sidebar with modern geometric header for
/// creative agencies, digital studios, and freelancers.
abstract final class StudioTemplate {
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
<div class="studio-container">
  <div class="head keep">
    <div>
      <div class="badge-row">
        <span class="number-badge">${PdfHtml.esc(doc.number)}</span>
        ${stamp == null ? '' : '<span class="stamp-badge">${PdfHtml.esc(stamp)}</span>'}
      </div>
      <div class="title">${PdfHtml.esc(doc.title)}</div>
    </div>
    <div class="seller-block">
      ${PdfHtml.logo(doc.seller)}
      ${PdfHtml.party(doc.seller)}
    </div>
  </div>
  <div class="client-row keep">
    <div class="client-col">
      <div class="sub-label">${PdfHtml.esc(doc.buyerHeading)}</div>
      ${buyer == null ? '<div class="muted">—</div>' : PdfHtml.party(buyer)}
    </div>
    <div class="meta-col">
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
</div>
''';
  }

  static const String _css =
      '''
.studio-container {
  border-left: 4.5mm solid ${PdfPalette.brand};
  padding-left: 7mm;
  min-height: 100%;
}
.head {
  display: flex;
  justify-content: space-between;
  gap: 8mm;
  padding-bottom: 5mm;
  border-bottom: 1px solid ${PdfPalette.line};
}
.badge-row { display: flex; gap: 2.5mm; align-items: center; margin-bottom: 2mm; }
.number-badge {
  background: ${PdfPalette.brandSoft};
  color: ${PdfPalette.brand};
  font-weight: 700;
  font-size: 8.5pt;
  padding: 1mm 3mm;
  border-radius: 1.5mm;
  letter-spacing: 0.5px;
}
.stamp-badge {
  background: ${PdfPalette.zebra};
  border: 1px solid ${PdfPalette.line};
  color: ${PdfPalette.muted};
  font-size: 8pt;
  font-weight: 600;
  padding: 0.8mm 2.5mm;
  border-radius: 1.5mm;
  text-transform: uppercase;
}
.title { font-size: 26pt; font-weight: 800; color: ${PdfPalette.ink}; letter-spacing: -0.5px; line-height: 1.05; }
.seller-block { text-align: right; max-width: 52%; }
.seller-block .party-name { font-size: 11.5pt; font-weight: 700; color: ${PdfPalette.brand}; }
.client-row { display: flex; justify-content: space-between; gap: 8mm; margin: 6mm 0 5mm; }
.client-col { flex: 1; }
.meta-col { flex: 1; }
.sub-label { font-size: 7.5pt; font-weight: 800; color: ${PdfPalette.muted}; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 1.5mm; }
.meta-table { width: 100%; }
.meta-table td { padding: 0.8mm 0; font-size: 9pt; }
.meta-table td:first-child { color: ${PdfPalette.muted}; }
.items th {
  background: ${PdfPalette.brandSoft};
  color: ${PdfPalette.brand};
  font-size: 8pt;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.8px;
  padding: 2.2mm 2.5mm;
  border-bottom: 1.5px solid ${PdfPalette.brand};
}
.items td { padding: 2.5mm 2.5mm; border-bottom: 1px solid ${PdfPalette.line}; vertical-align: top; }
.totals-wrap { display: flex; justify-content: flex-end; margin-top: 5mm; }
.totals { width: 48%; }
.totals td { padding: 1.2mm 2mm; font-size: 9.5pt; }
.totals td:first-child { color: ${PdfPalette.muted}; }
.totals .grand td {
  border-top: 2px solid ${PdfPalette.brand};
  border-bottom: 2px solid ${PdfPalette.brand};
  color: ${PdfPalette.brand};
  font-weight: 800;
  font-size: 13pt;
  padding: 2.5mm 2mm;
}
.totals .after td:last-child { font-weight: 700; }
.bottom { margin-top: 8mm; display: flex; justify-content: space-between; gap: 8mm; align-items: flex-end; }
.note-h { font-weight: 700; font-size: 8.5pt; color: ${PdfPalette.brand}; text-transform: uppercase; }
.sign { text-align: center; margin-left: auto; }
.sign-line { border-top: 1px solid ${PdfPalette.brand}; padding-top: 1mm; min-width: 45mm; font-size: 8pt; }
''';
}
