import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/services/pdf/canvas/canvas_design.dart';
import 'package:receipt_maker/core/services/pdf/canvas/canvas_designs.dart';
import 'package:receipt_maker/core/services/pdf/models/pdf_document.dart';
import 'package:receipt_maker/core/services/pdf/models/pdf_field.dart';
import 'package:receipt_maker/core/services/pdf/models/pdf_line.dart';
import 'package:receipt_maker/core/services/pdf/models/pdf_party.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template_renderer.dart';

void main() {
  PdfDocument doc({String? logo}) => PdfDocument(
    languageCode: 'en',
    title: 'Invoice',
    number: 'INV-0001',
    seller: PdfParty(name: 'A & B <Traders>', logoDataUri: logo),
    meta: const [PdfField(label: 'Due date', value: 'Oct 27, 2026')],
    columns: const ['Item', 'Qty', 'Price', 'Amount'],
    lines: const [
      PdfLine(name: 'Work', quantity: '1', unitPrice: '৳10', amount: '৳10'),
    ],
    totals: const [PdfField(label: 'Subtotal', value: '৳10')],
    grandTotal: const PdfField(label: 'Total', value: '৳10'),
    pageLabelParts: const ['Page ', ' of ', ''],
  );

  String render(PdfTemplate t, {String? logo}) =>
      PdfTemplateRenderer.render(t, doc(logo: logo), fontsCss: '');

  List<PdfTemplate> withSkeleton(CanvasSkeleton s) => [
    for (final t in PdfTemplate.values)
      if (CanvasDesigns.of(t)?.skeleton == s) t,
  ];

  test('thirteen designs have the logo header, across three skeletons', () {
    expect(withSkeleton(CanvasSkeleton.brand), hasLength(6));
    expect(withSkeleton(CanvasSkeleton.card), hasLength(3));
    expect(withSkeleton(CanvasSkeleton.clean), hasLength(4));
  });

  test('the logo sits in the header on its tile, with the seller', () {
    for (final t in PdfTemplate.values) {
      if (!(CanvasDesigns.of(t)?.hasLogoHead ?? false)) continue;
      final html = render(t, logo: 'data:image/png;base64,AAAA');
      final head = html.substring(
        html.indexOf('<div class="cv-bhead'),
        html.indexOf('<div class="cv-body">'),
      );
      expect(head, contains('<div class="cv-logo"><img'), reason: t.id);
      expect(head, contains('A &amp; B &lt;Traders&gt;'), reason: t.id);
      expect(head, contains('INV-0001'), reason: t.id);
    }
  });

  test('no logo means no empty tile', () {
    expect(
      render(PdfTemplate.swoosh),
      isNot(contains('<div class="cv-logo">')),
    );
  });

  test('a brand header bleeds to the page edges with its own art', () {
    final html = render(PdfTemplate.swoosh);
    expect(html, contains('@page :first { margin-top: 0;'));
    expect(html, contains('preserveAspectRatio%3D%22none%22'));
    expect(render(PdfTemplate.linea), isNot(contains('margin-top: 0;')));
  });

  test('a card design prints the page number in white on its color', () {
    expect(render(PdfTemplate.plaque), contains('rgba(255, 255, 255, 0.7)'));
    expect(render(PdfTemplate.plaque), contains('box-decoration-break: clone'));
  });
}
