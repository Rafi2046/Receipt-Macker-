import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database_provider.dart';
import 'data/repositories/payment_repository_impl.dart';
import 'domain/repositories/payment_repository.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
PaymentRepository paymentRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return PaymentRepositoryImpl(db, db.paymentDao, db.invoiceDao);
}
