import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database_provider.dart';
import 'data/repositories/invoice_repository_impl.dart';
import 'domain/repositories/invoice_repository.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
InvoiceRepository invoiceRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return InvoiceRepositoryImpl(db.invoiceDao, db.businessProfileDao);
}
