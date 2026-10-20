import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/app/provider_retry.dart';
import 'package:receipt_maker/core/errors/failure.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/services/file_save_service.dart';
import 'package:receipt_maker/core/services/pdf/models/rendered_pdf.dart';
import 'package:receipt_maker/core/services/pdf/pdf_raster_service.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template.dart';
import 'package:receipt_maker/core/services/service_providers.dart';
import 'package:receipt_maker/core/services/share_service.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_stage.dart';
import 'package:receipt_maker/features/invoices/domain/repositories/invoice_pdf_repository.dart';
import 'package:receipt_maker/features/invoices/presentation/view_models/invoice_pdf_state.dart';
import 'package:receipt_maker/features/invoices/presentation/view_models/invoice_pdf_view_model.dart';
import 'package:receipt_maker/features/invoices/providers.dart';

import '../../../helpers/fake_app_preferences.dart';
import '../../../helpers/mock_repositories.dart';

class _MockPdfRepo extends Mock implements InvoicePdfRepository {}

class _MockRaster extends Mock implements PdfRasterService {}

class _MockShare extends Mock implements ShareService {}

class _MockSave extends Mock implements FileSaveService {}

void main() {
  setUpAll(() {
    registerRepositoryFallbacks();
    registerFallbackValue(PdfTemplate.classic);
    registerFallbackValue(Uint8List(0));
  });

  late _MockPdfRepo pdfRepo;
  late _MockRaster raster;
  late _MockShare share;
  late _MockSave save;
  late MockInvoiceRepository invoices;
  late FakeAppPreferences prefs;
  late ProviderContainer container;
  final provider = invoicePdfViewModelProvider('inv1');
  final pdf = RenderedPdf(
    path: '/cache/pdf/INV-0001.pdf',
    fileName: 'INV-0001.pdf',
    pageCount: 1,
    bytes: Uint8List.fromList([1, 2, 3]),
  );

  InvoicePdfState state() => container.read(provider);

  Future<void> open() async {
    container = ProviderContainer(
      overrides: [
        invoicePdfRepositoryProvider.overrideWithValue(pdfRepo),
        invoiceRepositoryProvider.overrideWithValue(invoices),
        pdfRasterServiceProvider.overrideWithValue(raster),
        shareServiceProvider.overrideWithValue(share),
        fileSaveServiceProvider.overrideWithValue(save),
        appPreferencesProvider.overrideWithValue(prefs),
      ],
      retry: appProviderRetry,
    )..listen(provider, (_, _) {});
    await pumpEventQueue();
  }

  setUp(() {
    pdfRepo = _MockPdfRepo();
    raster = _MockRaster();
    share = _MockShare();
    save = _MockSave();
    invoices = MockInvoiceRepository();
    prefs = FakeAppPreferences(languageCode: 'bn', pdfTemplate: 'modern');
    when(
      () => pdfRepo.render(
        any(),
        template: any(named: 'template'),
        languageCode: any(named: 'languageCode'),
      ),
    ).thenAnswer((_) async => Ok(pdf));
    when(() => raster.pages(any()))
        .thenAnswer((_) async => [Uint8List(1), Uint8List(1)]);
    when(() => invoices.find('inv1'))
        .thenAnswer((_) async => Ok(testInvoice()));
  });
  tearDown(() => container.dispose());

  test('starts with the remembered template and the app language', () async {
    await open();
    expect(state().template, PdfTemplate.modern);
    expect(state().languageCode, 'bn');
    expect(state().isReady, isTrue);
    expect(state().pages, hasLength(2));
    verify(
      () => pdfRepo.render(
        'inv1',
        template: PdfTemplate.modern,
        languageCode: 'bn',
      ),
    ).called(1);
  });

  test('changing the template remembers it and makes a new PDF', () async {
    await open();
    await container.read(provider.notifier).setTemplate(PdfTemplate.minimal);
    expect(prefs.pdfTemplate, 'minimal');
    verify(
      () => pdfRepo.render(
        'inv1',
        template: PdfTemplate.minimal,
        languageCode: 'bn',
      ),
    ).called(1);
  });

  test('a failed render is shown with its failure', () async {
    when(
      () => pdfRepo.render(
        any(),
        template: any(named: 'template'),
        languageCode: any(named: 'languageCode'),
      ),
    ).thenAnswer((_) async => const Err(PdfFailure()));
    await open();
    expect(state().isRendering, isFalse);
    expect(state().renderFailure, isA<PdfFailure>());
    expect(state().isReady, isFalse);
  });

  test('sharing a draft offers "Mark as sent"; a sent one does not', () async {
    when(
      () => share.shareFile(
        any(),
        mimeType: any(named: 'mimeType'),
        subject: any(named: 'subject'),
      ),
    ).thenAnswer((_) async => true);
    await open();
    final vm = container.read(provider.notifier);
    expect(await vm.share(subject: 'Invoice'), isTrue);

    when(() => invoices.find('inv1')).thenAnswer(
      (_) async => Ok(testInvoice().copyWith(stage: InvoiceStage.sent)),
    );
    expect(await vm.share(subject: 'Invoice'), isFalse);
  });

  test('a dismissed share sheet offers nothing', () async {
    when(
      () => share.shareFile(
        any(),
        mimeType: any(named: 'mimeType'),
        subject: any(named: 'subject'),
      ),
    ).thenAnswer((_) async => false);
    await open();
    expect(
      await container.read(provider.notifier).share(subject: 'x'),
      isFalse,
    );
  });

  test('mark as sent saves the stage', () async {
    when(() => invoices.save(any()))
        .thenAnswer((i) async => Ok(i.positionalArguments.first as Invoice));
    await open();
    expect((await container.read(provider.notifier).markSent()).isOk, isTrue);
    final saved = verify(() => invoices.save(captureAny())).captured.single;
    expect((saved as Invoice).stage, InvoiceStage.sent);
  });

  test('save reports success; an error becomes an action failure', () async {
    when(
      () => save.save(
        fileName: any(named: 'fileName'),
        bytes: any(named: 'bytes'),
        mimeType: any(named: 'mimeType'),
      ),
    ).thenAnswer((_) async => true);
    await open();
    final vm = container.read(provider.notifier);
    expect(await vm.save(), isTrue);

    when(
      () => save.save(
        fileName: any(named: 'fileName'),
        bytes: any(named: 'bytes'),
        mimeType: any(named: 'mimeType'),
      ),
    ).thenThrow(Exception('no space'));
    expect(await vm.save(), isFalse);
    expect(state().actionFailure, isA<PdfFailure>());
    expect(state().isBusy, isFalse);
  });
}
