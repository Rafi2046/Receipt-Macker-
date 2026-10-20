import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/core/errors/failure.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/services/pdf/html_pdf_converter.dart';
import 'package:receipt_maker/core/services/pdf/models/rendered_pdf.dart';
import 'package:receipt_maker/core/services/pdf/pdf_fonts.dart';
import 'package:receipt_maker/core/services/pdf/pdf_page_size.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template.dart';
import 'package:receipt_maker/features/business_profile/business_profile.dart';
import 'package:receipt_maker/features/invoices/data/repositories/invoice_pdf_repository_impl.dart';

import '../../../helpers/mock_repositories.dart';

class _FakeConverter extends HtmlPdfConverter {
  String? html;
  bool fail = false;

  @override
  Future<int> toPdf({
    required String html,
    required String path,
    PdfPageSize size = PdfPageSize.a4,
  }) async {
    if (fail) throw PlatformException(code: 'pdf');
    this.html = html;
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsBytes([0x25, 0x50, 0x44, 0x46]); // %PDF
    return 2;
  }
}

class _FakeFonts extends PdfFonts {
  @override
  Future<String> css() async => '/*fonts*/';
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    registerRepositoryFallbacks();
  });

  late Directory cache;
  late MockInvoiceRepository invoices;
  late MockBusinessProfileRepository profiles;
  late _FakeConverter converter;
  late InvoicePdfRepositoryImpl repo;

  setUp(() {
    cache = Directory.systemTemp.createTempSync('qb_pdf');
    invoices = MockInvoiceRepository();
    profiles = MockBusinessProfileRepository();
    converter = _FakeConverter();
    repo = InvoicePdfRepositoryImpl(
      invoices,
      profiles,
      converter,
      _FakeFonts(),
      () async => cache,
    );
    when(() => invoices.find('inv1'))
        .thenAnswer((_) async => Ok(testInvoice()));
    when(() => profiles.load()).thenAnswer(
      (_) async => Ok(
        BusinessProfile(
          id: 'p',
          name: 'Shop',
          createdAt: testTime,
          updatedAt: testTime,
        ),
      ),
    );
  });
  tearDown(() => cache.deleteSync(recursive: true));

  test('renders the template to a named file in the cache folder', () async {
    final result = await repo.render(
      'inv1',
      template: PdfTemplate.modern,
      languageCode: 'bn',
    );
    final pdf = (result as Ok<RenderedPdf>).value;
    expect(pdf.fileName, 'INV-0001.pdf');
    expect(pdf.path, '${cache.path}/pdf/INV-0001.pdf');
    expect(pdf.pageCount, 2);
    expect(pdf.bytes, [0x25, 0x50, 0x44, 0x46]);
    expect(converter.html, contains('lang="bn"'));
    expect(converter.html, contains('ইনভয়েস'));
  });

  test('a converter error becomes a PdfFailure', () async {
    converter.fail = true;
    final result = await repo.render(
      'inv1',
      template: PdfTemplate.classic,
      languageCode: 'en',
    );
    expect((result as Err<RenderedPdf>).failure, isA<PdfFailure>());
  });

  test('without a business profile there is nothing to print', () async {
    when(() => profiles.load()).thenAnswer((_) async => const Ok(null));
    final result = await repo.render(
      'inv1',
      template: PdfTemplate.classic,
      languageCode: 'en',
    );
    expect((result as Err<RenderedPdf>).failure, isA<NotFoundFailure>());
  });

  test('file names are safe for any invoice number', () {
    expect(
      InvoicePdfRepositoryImpl.fileNameFor('INV/2026: 7'),
      'INV_2026_7.pdf',
    );
    expect(InvoicePdfRepositoryImpl.fileNameFor('  '), 'invoice.pdf');
  });
}
