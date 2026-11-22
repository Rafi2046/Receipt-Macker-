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
    for (final (size, css) in [
      (PdfPageSize.legal, 'size: legal'),
      (PdfPageSize.a5, 'size: A5'),
    ]) {
      final html = PdfTemplateRenderer.render(
        PdfTemplate.aurora,
        doc(),
        fontsCss: '',
        size: size,
      );
      expect(html, contains(css));
    }
    expect(PdfPageSize.fromId('legal'), PdfPageSize.legal);
    expect(PdfPageSize.fromId(null), PdfPageSize.a4);
    expect(PdfPageSize.fromId('gone'), PdfPageSize.a4);
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
    expect(PdfTemplate.values, hasLength(55));
    expect(PdfTemplate.fromId('swoosh'), PdfTemplate.swoosh);
    expect(PdfTemplate.fromId('pearl'), PdfTemplate.pearl);
    expect(PdfTemplate.fromId('nocturne'), PdfTemplate.nocturne);
    expect(PdfTemplate.fromId('aurora'), PdfTemplate.aurora);
    expect(PdfTemplate.fromId('impact'), PdfTemplate.impact);
    expect(PdfTemplate.fromId('modern'), PdfTemplate.modern);
    expect(PdfTemplate.fromId('executive'), PdfTemplate.executive);
    expect(PdfTemplate.fromId('studio'), PdfTemplate.studio);
    expect(PdfTemplate.fromId('editorial'), PdfTemplate.editorial);
    expect(PdfTemplate.fromId('compact'), PdfTemplate.compact);
    expect(PdfTemplate.fromId('ledger'), PdfTemplate.ledger);
    expect(PdfTemplate.fromId('nordic'), PdfTemplate.nordic);
    expect(PdfTemplate.fromId('folio'), PdfTemplate.folio);
    expect(PdfTemplate.fromId('atelier'), PdfTemplate.atelier);
    expect(PdfTemplate.fromId('lumen'), PdfTemplate.lumen);
    expect(PdfTemplate.fromId('gone'), PdfTemplate.classic);
    expect(PdfTemplate.fromId(null), PdfTemplate.classic);
  });

  test('brand accent color custom properties are injected dynamically', () {
    final custom = PdfTemplateRenderer.render(
      PdfTemplate.executive,
      doc(),
      fontsCss: '',
      accentColor: '#1E3A8A',
    );
    expect(custom, contains('--brand-accent: #1E3A8A'));
    expect(custom, contains('--brand-accent-soft: #EFF6FF'));
    expect(custom, contains('--brand-deep: #0F1F4D'));
    expect(custom, contains('--brand-pair: #F59E0B'));

    final defaultAccent = PdfTemplateRenderer.render(
      PdfTemplate.classic,
      doc(),
      fontsCss: '',
    );
    expect(defaultAccent, contains('--brand-accent: #FF5738'));
    expect(defaultAccent, contains('--brand-accent-soft: #FFF1EE'));
  });

  test('a color that is not ours still gets a deep shade and a pair', () {
    final html = PdfTemplateRenderer.render(
      PdfTemplate.aurora,
      doc(),
      fontsCss: '',
      accentColor: '#00FF00',
    );
    expect(html, contains('--brand-deep: #009900'));
    expect(html, contains('--brand-pair: #E0A100'));
  });

  test('art designs paint the whole sheet, calmer after page one', () {
    final html = PdfTemplateRenderer.render(
      PdfTemplate.prism,
      doc(),
      fontsCss: '',
      accentColor: '#006A4E',
      size: PdfPageSize.letter,
    );
    expect(html, contains('-14mm -14mm / 215.9mm 279.4mm no-repeat'));
    expect(html, contains('@page :first { background-image: url("data:'));
    expect(html, contains('html, body { background: transparent; }'));
    // The first-page band is left off later pages.
    final rest = RegExp(r'background: #FFFFFF url\("([^"]+)"\)')
        .firstMatch(html)
        ?.group(1);
    final first = RegExp(r':first \{ background-image: url\("([^"]+)"\)')
        .firstMatch(html)
        ?.group(1);
    expect(rest, isNotNull);
    expect(first!.length, greaterThan(rest!.length));
    expect(Uri.decodeComponent(first), contains('fill="#006A4E"'));
  });

  test('dark art designs use a highlight that reads on dark', () {
    String hi(String accent) => RegExp(r'--cv-hi: (#[0-9A-Fa-f]+)')
        .firstMatch(
          PdfTemplateRenderer.render(
            PdfTemplate.nocturne,
            doc(),
            fontsCss: '',
            accentColor: accent,
          ),
        )!
        .group(1)!;
    expect(hi('#1E3A8A'), '#F59E0B'); // navy pairs with amber
    expect(hi('#BE185D'), '#FFF1F2'); // rose pairs with dark ink: use wash
    expect(hi('#123456'), '#E0A100'); // custom color: gold pair
  });

  test('edge-to-edge layouts move the page margin into the body', () {
    for (final t in [PdfTemplate.executive, PdfTemplate.aurora]) {
      final html = render(doc(), t);
      expect(html, contains('@page :first { margin-top: 0; }'), reason: t.id);
    }
    expect(render(doc()), isNot(contains('@page :first')));
  });

  test('free watermark renders across all 8 templates when provided', () {
    for (final t in PdfTemplate.values) {
      final html = PdfTemplateRenderer.render(
        t,
        doc(),
        fontsCss: '',
        footer: 'Made with QuickBill',
      );
      expect(html, contains('Made with QuickBill'), reason: t.id);
    }
  });

  test('all 8 templates render Bangla script safely', () {
    final bnDoc = doc(
      language: 'bn',
      notes: const [
        PdfField(label: 'শর্তাবলী', value: '১৫ দিনের মধ্যে প্রদেয়'),
      ],
    );
    for (final t in PdfTemplate.values) {
      final html = PdfTemplateRenderer.render(t, bnDoc, fontsCss: '/*fonts*/');
      expect(html, contains('lang="bn"'), reason: t.id);
      expect(html, contains('শর্তাবলী'), reason: t.id);
      expect(html, contains('১৫ দিনের মধ্যে প্রদেয়'), reason: t.id);
    }
  });

  test('brand accent color custom properties are injected dynamically', () {
    final custom = PdfTemplateRenderer.render(
      PdfTemplate.executive,
      doc(),
      fontsCss: '',
      accentColor: '#1E3A8A',
    );
    expect(custom, contains('--brand-accent: #1E3A8A'));
    expect(custom, contains('--brand-accent-soft: #EFF6FF'));

    final defaultAccent = PdfTemplateRenderer.render(
      PdfTemplate.classic,
      doc(),
      fontsCss: '',
    );
    expect(defaultAccent, contains('--brand-accent: #FF5738'));
    expect(defaultAccent, contains('--brand-accent-soft: #FFF1EE'));
  });

  test('free watermark renders across all 8 templates when provided', () {
    for (final t in PdfTemplate.values) {
      final html = PdfTemplateRenderer.render(
        t,
        doc(),
        fontsCss: '',
        footer: 'Made with QuickBill',
      );
      expect(html, contains('Made with QuickBill'), reason: t.id);
    }
  });

  test('all 8 templates render Bangla script safely', () {
    final bnDoc = doc(
      language: 'bn',
      notes: const [
        PdfField(label: 'শর্তাবলী', value: '১৫ দিনের মধ্যে প্রদেয়'),
      ],
    );
    for (final t in PdfTemplate.values) {
      final html = PdfTemplateRenderer.render(t, bnDoc, fontsCss: '/*fonts*/');
      expect(html, contains('lang="bn"'), reason: t.id);
      expect(html, contains('শর্তাবলী'), reason: t.id);
      expect(html, contains('১৫ দিনের মধ্যে প্রদেয়'), reason: t.id);
    }
  });
}
