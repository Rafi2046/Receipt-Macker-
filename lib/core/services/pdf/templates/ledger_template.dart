import '../models/pdf_document.dart';
import '../pdf_html.dart';
import '../pdf_page_size.dart';
import '../pdf_palette.dart';

/// Ledger: structured accounting grid with distinct boxed sections, prominent
/// payment method styling, and comprehensive financial breakdown.
abstract final class LedgerTemplate {
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
<div class="ledger-box">
  <div class="ledger-head keep">
    <div class="cell seller-cell">
      ${PdfHtml.logo(doc.seller)}
      <div class="seller-title">${PdfHtml.esc(doc.seller.name)}</div>
      ${doc.seller.lines.where((l) => l.trim().isNotEmpty).map((l) => '<div class="muted small">${PdfHtml.multiline(l)}</div>').join()}
    </div>
    <div class="cell meta-cell">
      <div class="doc-badge-row">
        <span class="ledger-title">${PdfHtml.esc(doc.title)}</span>
        <span class="ledger-num">${PdfHtml.esc(doc.number)}</span>
      </div>
      ${stamp == null ? '' : '<div class="stamp">${PdfHtml.esc(stamp)}</div>'}
      <table class="meta-grid">${PdfHtml.fieldRows(doc.meta)}</table>
    </div>
  </div>
  ${buyer == null ? '' : '<div class="cell buyer-cell keep"><div class="cell-label">${PdfHtml.esc(doc.buyerHeading)}</div>${PdfHtml.party(buyer)}</div>'}
  <table class="items">
    <thead>${PdfHtml.columnHeads(doc)}</thead>
    <tbody>${PdfHtml.lineRows(doc)}</tbody>
  </table>
  <div class="ledger-bottom-row keep">
    <div class="breakdown-box">
      ${PdfHtml.notes(doc)}
    </div>
    <div class="totals-box">
      <table class="totals-table">
        ${PdfHtml.fieldRows(doc.totals)}
        <tr class="grand">
          <td>${PdfHtml.esc(doc.grandTotal.label)}</td>
          <td class="num">${PdfHtml.esc(doc.grandTotal.value)}</td>
        </tr>
        ${PdfHtml.fieldRows(doc.afterTotal, rowClass: 'after')}
      </table>
    </div>
  </div>
  <div class="footer-row keep">
    <div class="verified-badge">✓ ${PdfHtml.esc(doc.title)} · Verified Entry</div>
    ${PdfHtml.signature(doc)}
  </div>
</div>
''';
  }

  static const String _css =
      '''
.ledger-box {
  border: 1.5px solid #94A3B8;
  border-radius: 1.5mm;
  overflow: hidden;
}
.ledger-head {
  display: flex;
  border-bottom: 1.5px solid #94A3B8;
}
.cell { padding: 3.5mm 4mm; }
.seller-cell {
  flex: 1.2;
  border-right: 1.5px solid #94A3B8;
  background: #FFFFFF;
}
.seller-title {
  font-size: 13pt;
  font-weight: 800;
  color: ${PdfPalette.brand};
  margin-top: 1mm;
}
.meta-cell {
  flex: 1;
  background: ${PdfPalette.zebra};
  text-align: right;
}
.doc-badge-row {
  display: flex;
  justify-content: flex-end;
  gap: 2mm;
  align-items: baseline;
  margin-bottom: 2mm;
}
.ledger-title {
  font-size: 13pt;
  font-weight: 800;
  text-transform: uppercase;
  color: ${PdfPalette.ink};
}
.ledger-num {
  font-size: 11pt;
  font-weight: 700;
  color: ${PdfPalette.brand};
}
.stamp {
  display: inline-block;
  background: ${PdfPalette.brand};
  color: #FFFFFF;
  padding: 0.5mm 3mm;
  border-radius: 1mm;
  font-size: 7.5pt;
  font-weight: 700;
  letter-spacing: 0.8px;
  text-transform: uppercase;
  margin-bottom: 1.5mm;
}
.meta-grid { width: 100%; }
.meta-grid td { padding: 0.5mm 0; font-size: 8.5pt; }
.meta-grid td:first-child { color: ${PdfPalette.muted}; text-align: left; }
.buyer-cell {
  border-bottom: 1.5px solid #94A3B8;
  background: #FAFAFA;
}
.cell-label {
  font-size: 7.5pt;
  font-weight: 800;
  color: ${PdfPalette.brand};
  text-transform: uppercase;
  letter-spacing: 0.8px;
  margin-bottom: 1mm;
}
.items { border-bottom: 1.5px solid #94A3B8; }
.items th {
  background: #E2E8F0;
  color: ${PdfPalette.ink};
  font-size: 8pt;
  font-weight: 800;
  text-transform: uppercase;
  letter-spacing: 0.6px;
  padding: 2.2mm 2.5mm;
  border-right: 1px solid #CBD5E1;
  border-bottom: 1px solid #94A3B8;
}
.items th:last-child { border-right: none; }
.items td {
  padding: 2mm 2.5mm;
  border-right: 1px solid #E2E8F0;
  border-bottom: 1px solid #E2E8F0;
  vertical-align: top;
  font-size: 9pt;
}
.items td:last-child { border-right: none; }
.items tr:last-child td { border-bottom: none; }
.ledger-bottom-row {
  display: flex;
  border-bottom: 1px solid #CBD5E1;
}
.breakdown-box {
  flex: 1.2;
  padding: 3.5mm 4mm;
  border-right: 1.5px solid #94A3B8;
}
.totals-box {
  flex: 1;
  background: #FAFAFA;
}
.totals-table { width: 100%; }
.totals-table td { padding: 1.3mm 3mm; font-size: 9pt; }
.totals-table td:first-child { color: ${PdfPalette.muted}; }
.totals-table .grand td {
  background: ${PdfPalette.brandSoft};
  color: ${PdfPalette.brand};
  font-weight: 800;
  font-size: 11.5pt;
  border-top: 1.5px solid ${PdfPalette.brand};
  border-bottom: 1.5px solid ${PdfPalette.brand};
  padding: 2mm 3mm;
}
.totals-table .after td:last-child { font-weight: 700; }
.footer-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 3.5mm 4mm;
  background: #FFFFFF;
}
.verified-badge {
  font-size: 8pt;
  font-weight: 700;
  color: ${PdfPalette.muted};
  letter-spacing: 0.5px;
}
.note-h {
  font-weight: 800;
  font-size: 8pt;
  color: ${PdfPalette.brand};
  text-transform: uppercase;
  margin-bottom: 0.5mm;
}
.sign { text-align: center; }
.sign-line {
  border-top: 1px solid #94A3B8;
  padding-top: 1mm;
  min-width: 40mm;
  font-size: 7.5pt;
}
''';
}
