import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database_provider.dart';
import '../../core/services/pdf/pdf_page_size.dart';
import '../../core/services/service_providers.dart';
import '../business_profile/business_profile.dart';
import 'data/repositories/quote_pdf_repository_impl.dart';
import 'data/repositories/quote_repository_impl.dart';
import 'domain/repositories/quote_pdf_repository.dart';
import 'domain/repositories/quote_repository.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
QuoteRepository quoteRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return QuoteRepositoryImpl(db.quoteDao, db.businessProfileDao);
}

@Riverpod(keepAlive: true)
QuotePdfRepository quotePdfRepository(Ref ref) => QuotePdfRepositoryImpl(
  ref.watch(quoteRepositoryProvider),
  ref.watch(businessProfileRepositoryProvider),
  ref.watch(htmlPdfConverterProvider),
  ref.watch(pdfFontsProvider),
  ref.watch(cacheDirectoryProvider),
  pageSize: () =>
      PdfPageSize.fromId(ref.read(appPreferencesProvider).pdfPageSize),
);
