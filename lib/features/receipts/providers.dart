import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/services/service_providers.dart';
import '../business_profile/business_profile.dart';
import '../invoices/providers.dart';
import '../payments/providers.dart';
import 'data/repositories/receipt_pdf_repository_impl.dart';
import 'domain/repositories/receipt_pdf_repository.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
ReceiptPdfRepository receiptPdfRepository(Ref ref) => ReceiptPdfRepositoryImpl(
  ref.watch(paymentRepositoryProvider),
  ref.watch(invoiceRepositoryProvider),
  ref.watch(businessProfileRepositoryProvider),
  ref.watch(htmlPdfConverterProvider),
  ref.watch(pdfFontsProvider),
  ref.watch(cacheDirectoryProvider),
);
