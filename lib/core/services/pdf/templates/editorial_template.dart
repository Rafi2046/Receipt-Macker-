import '../models/pdf_document.dart';
import '../pdf_html.dart';
import '../pdf_page_size.dart';
import '../pdf_palette.dart';

/// Editorial: high-contrast, refined double-rule borders and classic proportions
/// suited for boutique retail, hospitality, consulting, and premium commerce.
abstract final class EditorialTemplate {
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
<div class="editorial-frame">
  <div class="top-rule"></div>
  <div class="head keep">
    <div class="seller-side">
      ${PdfHtml.logo(doc.seller)}
      <div class="brand-title">${PdfHtml.esc(doc.seller.name)}</div>
      ${doc.seller.lines.where((l) => l.trim().isNotEmpty).map((l) => '<div class="muted small">${PdfHtml.multiline(l)}</div>').join()}
    </div>
    <div class="doc-side">
      <div class="doc-title">${PdfHtml.esc(doc.title)}</div>
      <div class="doc-number">${PdfHtml.esc(doc.number)}</div>
      ${stamp == null ? '' : '<div class="stamp">${PdfHtml.esc(stamp)}</div>'}
      <table class="meta">${PdfHtml.fieldRows(doc.meta)}</table>
    </div>
  </div>
  <div class="middle-rule"></div>
  ${buyer == null ? '' : '<div class="buyer-block keep"><div class="label">${PdfHtml.esc(doc.buyerHeading)}</div>${PdfHtml.party(buyer)}</div>'}
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
  <div class="bottom-rule"></div>
  <div class="bottom keep">
    ${PdfHtml.notes(doc)}
    ${PdfHtml.signature(doc)}
  </div>
</div>
''';
  }

  static const String _css =
      '''
.top-rule { border-top: 3.5px double ${PdfPalette.brand}; margin-bottom: 5mm; }
.middle-rule { border-top: 1px solid ${PdfPalette.line}; margin: 4mm 0 5mm; }
.bottom-rule { border-bottom: 1px solid ${PdfPalette.line}; margin-top: 6mm; }
.head {
  display: flex;
  justify-content: space-between;
  gap: 8mm;
  align-items: flex-start;
}
.seller-side { max-width: 52%; }
.brand-title {
  font-size: 14pt;
  font-weight: 700;
  letter-spacing: 0.8px;
  color: ${PdfPalette.brand};
  text-transform: uppercase;
  margin-top: 1mm;
}
.doc-side { text-align: right; }
.doc-title {
  font-size: 22pt;
  font-weight: 700;
  letter-spacing: 1.5px;
  text-transform: uppercase;
  color: ${PdfPalette.ink};
  line-height: 1.1;
}
.doc-number {
  font-size: 11pt;
  font-weight: 600;
  color: ${PdfPalette.muted};
  margin: 1mm 0 1.5mm;
}
.stamp {
  display: inline-block;
  border: 1px solid ${PdfPalette.brand};
  color: ${PdfPalette.brand};
  padding: 0.5mm 3mm;
  font-size: 8pt;
  letter-spacing: 1px;
  text-transform: uppercase;
  margin-bottom: 1.5mm;
}
.meta td { padding: 0.5mm 0 0.5mm 3mm; font-size: 9pt; }
.meta td:first-child { color: ${PdfPalette.muted}; }
.buyer-block { margin: 4mm 0 5mm; }
.label {
  font-size: 8pt;
  font-weight: 700;
  color: ${PdfPalette.brand};
  text-transform: uppercase;
  letter-spacing: 1.2px;
  margin-bottom: 1mm;
}
.items th {
  text-align: left;
  font-size: 8pt;
  font-weight: 700;
  letter-spacing: 1px;
  text-transform: uppercase;
  color: ${PdfPalette.brand};
  padding: 2mm 2.5mm;
  border-top: 1.5px solid ${PdfPalette.brand};
  border-bottom: 1.5px solid ${PdfPalette.brand};
}
.items td {
  padding: 2.2mm 2.5mm;
  border-bottom: 1px dashed #CBD5E1;
  vertical-align: top;
}
.totals-wrap { display: flex; justify-content: flex-end; margin-top: 4mm; }
.totals { width: 48%; }
.totals td { padding: 1.2mm 2.5mm; font-size: 9.5pt; }
.totals td:first-child { color: ${PdfPalette.muted}; }
.totals .grand td {
  border-top: 1px solid ${PdfPalette.brand};
  border-bottom: 3.5px double ${PdfPalette.brand};
  font-weight: 700;
  font-size: 13pt;
  color: ${PdfPalette.brand};
  padding: 2mm 2.5mm;
}
.totals .after td:last-child { font-weight: 700; }
.bottom {
  margin-top: 5mm;
  display: flex;
  justify-content: space-between;
  gap: 8mm;
  align-items: flex-end;
}
.note-h {
  font-weight: 700;
  font-size: 8.5pt;
  color: ${PdfPalette.brand};
  text-transform: uppercase;
  letter-spacing: 0.8px;
}
.sign { text-align: center; margin-left: auto; }
.sign-line {
  border-top: 1px solid ${PdfPalette.brand};
  padding-top: 1mm;
  min-width: 45mm;
  font-size: 8pt;
}
''';
}
