import 'dart:convert';

import 'models/pdf_document.dart';
import 'models/pdf_field.dart';
import 'models/pdf_party.dart';
import 'pdf_page_size.dart';
import 'pdf_palette.dart';

/// HTML and CSS pieces shared by the templates. Everything the user typed
/// goes through [esc], so names like `<b>` or `A & B` print as written.
abstract final class PdfHtml {
  static const HtmlEscape _escape = HtmlEscape();

  /// Latin from Noto Sans, Bangla (and ৳) from Noto Sans Bengali.
  static const String fontStack = "'QB Sans', 'QB Bengali', sans-serif";

  static String esc(String text) => _escape.convert(text);

  /// Escaped, with line breaks kept.
  static String multiline(String text) =>
      esc(text.trim()).replaceAll('\n', '<br>');

  /// A full HTML page around [body].
  static String page({
    required PdfDocument doc,
    required String fontsCss,
    required String templateCss,
    required String body,
    PdfPageSize size = PdfPageSize.a4,
  }) =>
      '<!doctype html><html lang="${esc(doc.languageCode)}"><head>'
      '<meta charset="utf-8"><style>$fontsCss${_baseCss(doc, size)}'
      '$templateCss</style></head><body>$body</body></html>';

  static String _baseCss(PdfDocument doc, PdfPageSize size) {
    final paper = size == PdfPageSize.letter ? 'letter' : 'A4';
    return '''
@page { size: $paper; margin: 14mm 14mm 16mm 14mm;
  @bottom-center { content: ${_pageCounter(doc)}; font-family: $fontStack;
    font-size: 8pt; color: ${PdfPalette.muted}; } }
* { box-sizing: border-box; }
html, body { margin: 0; padding: 0; background: ${PdfPalette.paper}; }
body { font-family: $fontStack; font-size: 10pt; line-height: 1.45;
  color: ${PdfPalette.ink}; -webkit-print-color-adjust: exact;
  print-color-adjust: exact; }
table { border-collapse: collapse; width: 100%; }
thead { display: table-header-group; }
.items th:first-child { width: 46%; }
tr, .keep { break-inside: avoid; page-break-inside: avoid; }
.num { text-align: right !important; white-space: nowrap;
  font-variant-numeric: tabular-nums; }
.muted { color: ${PdfPalette.muted}; }
.small { font-size: 8.5pt; }
.logo { max-height: 18mm; max-width: 45mm; object-fit: contain; }
.signature { max-height: 16mm; max-width: 50mm; object-fit: contain; }
.notes { flex: 1; max-width: 120mm; }
''';
  }

  /// "Page 1 of 2" as a CSS `content` value, with Bangla digits in Bangla.
  static String _pageCounter(PdfDocument doc) {
    final style = doc.languageCode == 'bn' ? 'bengali' : 'decimal';
    final parts = doc.pageLabelParts;
    String text(int i) => i < parts.length ? _cssString(parts[i]) : '""';
    return '${text(0)} counter(page, $style) ${text(1)} '
        'counter(pages, $style) ${text(2)}';
  }

  static String _cssString(String s) =>
      '"${s.replaceAll(r'\', r'\\').replaceAll('"', r'\"')}"';

  /// Name in bold, then contact lines.
  static String party(PdfParty p, {String nameClass = 'party-name'}) {
    final lines = p.lines.where((l) => l.trim().isNotEmpty).map(multiline);
    return '<div class="$nameClass">${esc(p.name)}</div>'
        '${lines.map((l) => '<div class="muted">$l</div>').join()}';
  }

  static String logo(PdfParty p) {
    final uri = p.logoDataUri;
    return uri == null ? '' : '<img class="logo" src="${esc(uri)}" alt="">';
  }

  /// Label/value rows as table rows with the given classes.
  static String fieldRows(List<PdfField> fields, {String rowClass = ''}) =>
      fields
          .map(
            (f) =>
                '<tr class="$rowClass"><td>${esc(f.label)}</td>'
                '<td class="num">${esc(f.value)}</td></tr>',
          )
          .join();

  /// The line items as `<tbody>` rows: name (+ description), qty, price,
  /// amount (+ discount note).
  static String lineRows(PdfDocument doc) => doc.lines.map((l) {
    final desc = l.description.trim().isEmpty
        ? ''
        : '<div class="muted small">${multiline(l.description)}</div>';
    final note = l.discountNote;
    final discount = note == null
        ? ''
        : '<div class="muted small">${esc(note)}</div>';
    return '<tr><td>${esc(l.name)}$desc</td>'
        '<td class="num">${esc(l.quantity)}</td>'
        '<td class="num">${esc(l.unitPrice)}</td>'
        '<td class="num">${esc(l.amount)}$discount</td></tr>';
  }).join();

  /// Table header cells for [PdfDocument.columns].
  static String columnHeads(PdfDocument doc) {
    final cells = <String>[];
    for (final (i, c) in doc.columns.indexed) {
      cells.add(
        i == 0 ? '<th>${esc(c)}</th>' : '<th class="num">${esc(c)}</th>',
      );
    }
    return '<tr>${cells.join()}</tr>';
  }

  /// Notes, terms and payment instructions stacked in one column, each
  /// with its heading.
  static String notes(PdfDocument doc, {String headingClass = 'note-h'}) {
    if (doc.notes.isEmpty) return '';
    final blocks = doc.notes.map(
      (n) =>
          '<div class="keep note"><div class="$headingClass">'
          '${esc(n.label)}</div><div>${multiline(n.value)}</div></div>',
    );
    return '<div class="notes">${blocks.join()}</div>';
  }

  /// Signature image above its label, or nothing.
  static String signature(PdfDocument doc) {
    final uri = doc.signatureDataUri;
    if (uri == null) return '';
    return '<div class="keep sign"><img class="signature" src="${esc(uri)}" '
        'alt=""><div class="sign-line muted small">'
        '${esc(doc.signatureLabel)}</div></div>';
  }
}
