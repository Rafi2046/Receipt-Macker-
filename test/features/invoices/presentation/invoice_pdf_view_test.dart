import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/core/errors/failure.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/services/pdf/models/rendered_pdf.dart';
import 'package:receipt_maker/core/services/pdf/pdf_raster_service.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template.dart';
import 'package:receipt_maker/core/services/service_providers.dart';
import 'package:receipt_maker/features/invoices/domain/repositories/invoice_pdf_repository.dart';
import 'package:receipt_maker/features/invoices/presentation/views/invoice_pdf_view.dart';
import 'package:receipt_maker/features/invoices/providers.dart';

import '../../../helpers/fake_app_preferences.dart';
import '../../../helpers/pump_app.dart';
import '../../../helpers/test_env.dart';

class _MockPdfRepo extends Mock implements InvoicePdfRepository {}

class _MockRaster extends Mock implements PdfRasterService {}

void main() {
  setUpAll(() {
    registerFallbackValue(PdfTemplate.classic);
    registerFallbackValue(Uint8List(0));
  });

  late _MockPdfRepo repo;
  late _MockRaster raster;
  final pdf = RenderedPdf(
    path: '/x.pdf',
    fileName: 'x.pdf',
    pageCount: 1,
    bytes: Uint8List(1),
  );

  void stubRender(Future<Result<RenderedPdf>> Function() answer) => when(
    () => repo.render(
      any(),
      template: any(named: 'template'),
      languageCode: any(named: 'languageCode'),
      showBranding: any(named: 'showBranding'),
    ),
  ).thenAnswer((_) => answer());

  Future<void> pump(
    WidgetTester tester, {
    String language = 'en',
    double textScale = 1,
  }) => tester.pumpApp(
    const InvoicePdfView(invoiceId: 'inv1'),
    language: language,
    textScale: textScale,
    settle: false,
    surface: const Size(360, 740),
    overrides: [
      invoicePdfRepositoryProvider.overrideWithValue(repo),
      pdfRasterServiceProvider.overrideWithValue(raster),
      appPreferencesProvider.overrideWithValue(
        FakeAppPreferences(languageCode: language),
      ),
    ],
  );

  setUp(() {
    repo = _MockPdfRepo();
    raster = _MockRaster();
    when(() => raster.pages(any())).thenAnswer((_) async => [tinyPng]);
  });

  testWidgets('shows progress while the PDF is made', (tester) async {
    final never = Completer<Result<RenderedPdf>>();
    stubRender(() => never.future);
    await pump(tester);
    await tester.pump();
    expect(find.text('Making the PDF…'), findsOneWidget);
    final share = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Share'),
    );
    expect(share.onPressed, isNull, reason: 'nothing to share yet');
  });

  testWidgets('a failure offers Retry and the print dialog', (tester) async {
    stubRender(() async => const Err(PdfFailure()));
    await pump(tester);
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Open print dialog'), findsOneWidget);
  });

  testWidgets('shows the pages and enables the actions', (tester) async {
    stubRender(() async => Ok(pdf));
    await pump(tester);
    await tester.pumpAndSettle();
    // Inside InteractiveViewer the finder treats pages as offstage.
    expect(find.byType(Image, skipOffstage: false), findsOneWidget);
    final share = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Share'),
    );
    expect(share.onPressed, isNotNull);
    expect(find.text('Classic'), findsOneWidget);
    expect(find.text('বাংলা'), findsOneWidget);
  });

  testWidgets('fits at 2x font in Bangla', (tester) async {
    stubRender(() async => Ok(pdf));
    await pump(tester, language: 'bn', textScale: 2);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('শেয়ার'), findsOneWidget);
  });
}
