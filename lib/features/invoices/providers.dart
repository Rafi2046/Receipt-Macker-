import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database_provider.dart';
import '../../core/services/service_providers.dart';
import '../business_profile/business_profile.dart';
import 'data/repositories/invoice_pdf_repository_impl.dart';
import 'data/repositories/invoice_repository_impl.dart';
import 'domain/repositories/invoice_pdf_repository.dart';
import 'domain/repositories/invoice_repository.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
InvoiceRepository invoiceRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return InvoiceRepositoryImpl(db.invoiceDao, db.businessProfileDao);
}

@Riverpod(keepAlive: true)
InvoicePdfRepository invoicePdfRepository(Ref ref) => InvoicePdfRepositoryImpl(
  ref.watch(invoiceRepositoryProvider),
  ref.watch(businessProfileRepositoryProvider),
  ref.watch(htmlPdfConverterProvider),
  ref.watch(pdfFontsProvider),
  ref.watch(cacheDirectoryProvider),
);
