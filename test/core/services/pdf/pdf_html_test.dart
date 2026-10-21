import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/services/pdf/models/pdf_document.dart';
import 'package:receipt_maker/core/services/pdf/models/pdf_field.dart';
import 'package:receipt_maker/core/services/pdf/models/pdf_line.dart';
import 'package:receipt_maker/core/services/pdf/models/pdf_party.dart';
import 'package:receipt_maker/core/services/pdf/pdf_page_size.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template_renderer.dart';

void main() {
  PdfDocument doc({
    String language = 'en',
    List<PdfField> notes = const [],
    String? logo,
  }) => PdfDocument(
    languageCode: language,
    title: 'Invoice',
    number: 'INV-0001',
    seller: PdfParty(name: 'A & B <Traders>', logoDataUri: logo),
    meta: const [PdfField(label: 'Due date', value: 'Oct 27, 2026')],
    columns: const ['Item', 'Qty', 'Price', 'Amount'],
    lines: const [
      PdfLine(
        name: '<script>alert(1)</script>',
        quantity: '2.5 hour',
        unitPrice: '৳1,200.00',
        amount: '৳2,700.00',
        description: 'Line one\nLine two',
        discountNote: 'Less 10%',
      ),
    ],
    totals: const [PdfField(label: 'Subtotal', value: '৳2,700.00')],
    grandTotal: const PdfField(label: 'Total', value: '৳2,700.00'),
    pageLabelParts: const ['Page ', ' of ', ''],
    notes: notes,
  );

  String render(
    PdfDocument d, [
    PdfTemplate t = PdfTemplate.classic,
    String? footer,
  ]) => PdfTemplateRenderer.render(t, d, fontsCss: '/*fonts*/', footer: footer);

  test('user text is escaped, never markup', () {
    final html = render(doc());
    expect(html, contains('A &amp; B &lt;Traders&gt;'));
    expect(html, contains('&lt;script&gt;'));
    expect(html, isNot(contains('<script>')));
  });

  test('line breaks in descriptions are kept', () {
    expect(render(doc()), contains('Line one<br>Line two'));
  });

  test('page numbers use Bangla digits in Bangla', () {
    expect(render(doc()), contains('counter(page, decimal)'));
    expect(render(doc(language: 'bn')), contains('counter(pages, bengali)'));
    expect(render(doc(language: 'bn')), contains('lang="bn"'));
  });

  test('page label parts are CSS strings with quotes escaped', () {
    final d = doc().copyWith(pageLabelParts: ['Page "', '" of ', '']);
    expect(render(d), contains(r'"Page \""'));
  });

  test('notes stack in one column; none means no block', () {
    expect(render(doc()), isNot(contains('class="notes"')));
    final html = render(
      doc(
        notes: const [
          PdfField(label: 'Notes', value: 'Thanks'),
          PdfField(label: 'Terms', value: '15 days'),
        ],
      ),
    );
    expect('class="notes"'.allMatches(html), hasLength(1));
    expect('class="keep note"'.allMatches(html), hasLength(2));
  });

  test('the logo shows only when there is one', () {
    expect(render(doc()), isNot(contains('<img class="logo"')));
    expect(
      render(doc(logo: 'data:image/png;base64,AAAA')),
      // Escaped attribute (`/` as `&#47;`), decoded again by the browser.
      contains('<img class="logo" src="data:image&#47;png;base64,AAAA"'),
    );
  });

  test('every template prints the same content', () {
    for (final t in PdfTemplate.values) {
      final html = render(doc(), t);
      expect(html, contains('INV-0001'), reason: t.id);
      expect(html, contains('৳2,700.00'), reason: t.id);
      expect(html, contains('Less 10%'), reason: t.id);
      expect(html, contains('/*fonts*/'), reason: t.id);
      expect(html, contains('<thead>'), reason: '${t.id} repeats headers');
    }
  });

  test('paper size follows the setting', () {
    expect(render(doc()), contains('size: A4'));
    final letter = PdfTemplateRenderer.render(
      PdfTemplate.modern,
      doc(),
      fontsCss: '',
      size: PdfPageSize.letter,
    );
    expect(letter, contains('size: letter'));
  });

  test('a free footer is escaped and left off otherwise', () {
    expect(
      render(doc(), PdfTemplate.classic, 'Made with QuickBill'),
      contains('Made with QuickBill'),
    );
    expect(render(doc(), PdfTemplate.classic, 'A & B'), contains('A &amp; B'));
    expect(render(doc()), isNot(contains('Made with QuickBill')));
  });

  test('template ids are stable and unknown ids fall back', () {
    expect(PdfTemplate.fromId('modern'), PdfTemplate.modern);
    expect(PdfTemplate.fromId('gone'), PdfTemplate.classic);
    expect(PdfTemplate.fromId(null), PdfTemplate.classic);
  });
}
