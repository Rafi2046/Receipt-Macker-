import 'models/pdf_document.dart';
import 'pdf_html.dart';
import 'pdf_palette.dart';

/// Body sections and base CSS shared by the premium layouts, so each
/// template file only holds what makes its design different.
abstract final class PdfBlocks {
  /// The seller's contact lines, one `<div>` each.
  static String sellerLines(PdfDocument doc, {String cls = 'muted'}) => doc
      .seller
      .lines
      .where((l) => l.trim().isNotEmpty)
      .map((l) => '<div class="$cls">${PdfHtml.multiline(l)}</div>')
      .join();

  /// The draft stamp, or nothing.
  static String stamp(PdfDocument doc) {
    final stamp = doc.stamp;
    return stamp == null
        ? ''
        : '<div class="stamp">${PdfHtml.esc(stamp)}</div>';
  }

  /// "Bill to" heading and the buyer (a dash when there is none).
  static String buyer(PdfDocument doc) {
    final buyer = doc.buyer;
    return '<div class="label">${PdfHtml.esc(doc.buyerHeading)}</div>'
        '${buyer == null ? '<div class="muted">—</div>' : PdfHtml.party(buyer)}';
  }

  static String meta(PdfDocument doc) =>
      '<table class="meta">${PdfHtml.fieldRows(doc.meta)}</table>';

  static String items(PdfDocument doc) =>
      '<table class="items"><thead>${PdfHtml.columnHeads(doc)}</thead>'
      '<tbody>${PdfHtml.lineRows(doc)}</tbody></table>';

  static String totals(PdfDocument doc) =>
      '<div class="totals-wrap keep"><table class="totals">'
      '${PdfHtml.fieldRows(doc.totals)}'
      '<tr class="grand"><td>${PdfHtml.esc(doc.grandTotal.label)}</td>'
      '<td class="num">${PdfHtml.esc(doc.grandTotal.value)}</td></tr>'
      '${PdfHtml.fieldRows(doc.afterTotal, rowClass: 'after')}'
      '</table></div>';

  /// Notes on the left, signature on the right.
  static String bottom(PdfDocument doc) =>
      '<div class="bottom keep">${PdfHtml.notes(doc)}'
      '${PdfHtml.signature(doc)}</div>';

  /// Everything after the header: items, totals, notes and signature.
  static String rest(PdfDocument doc) =>
      '${items(doc)}${totals(doc)}${bottom(doc)}';

  /// For layouts with edge-to-edge color. The browser never paints in the
  /// page margin, so the side margins (and the first page's top margin)
  /// become body padding, which a negative margin can then reach across.
  static const String bleedCss = '''
@page { margin: 14mm 0 16mm 0; }
@page :first { margin-top: 0; }
body { padding: 14mm 14mm 0 14mm; }
''';

  static const String css =
      '''
.label { font-size: 7.5pt; font-weight: 700; text-transform: uppercase;
  letter-spacing: 1px; color: ${PdfPalette.muted}; margin-bottom: 1.5mm; }
.party-name { font-weight: 700; font-size: 11pt; }
.meta td { padding: 0.7mm 0; font-size: 9pt; }
.meta td:first-child { color: ${PdfPalette.muted}; padding-right: 4mm; }
.stamp { display: inline-block; font-size: 7.5pt; font-weight: 700;
  text-transform: uppercase; letter-spacing: 0.8px; padding: 0.6mm 3mm;
  border-radius: 1.5mm; border: 1px solid currentColor; margin-top: 1.5mm; }
.items th { padding: 2.4mm 3mm; font-size: 8pt; font-weight: 700;
  text-transform: uppercase; letter-spacing: 0.7px; text-align: left; }
.items td { padding: 2.4mm 3mm; border-bottom: 1px solid ${PdfPalette.line};
  vertical-align: top; }
.totals-wrap { display: flex; justify-content: flex-end; margin-top: 5mm; }
.totals { width: 50%; }
.totals td { padding: 1.3mm 3mm; font-size: 9.5pt; }
.totals td:first-child { color: ${PdfPalette.muted}; }
.totals .grand td { font-weight: 700; font-size: 12pt; padding: 2.6mm 3mm; }
.totals .after td:last-child { font-weight: 700; }
.bottom { margin-top: 8mm; display: flex; justify-content: space-between;
  gap: 8mm; align-items: flex-end; }
.note { margin-bottom: 2mm; }
.note-h { font-weight: 700; font-size: 8pt; text-transform: uppercase;
  letter-spacing: 0.6px; color: ${PdfPalette.brand}; }
.sign { text-align: center; margin-left: auto; }
.sign-line { border-top: 1px solid ${PdfPalette.line}; padding-top: 1mm;
  min-width: 45mm; font-size: 8pt; }
.on-dark .logo { background: #FFFFFF; padding: 1.5mm; border-radius: 2mm; }
''';
}
