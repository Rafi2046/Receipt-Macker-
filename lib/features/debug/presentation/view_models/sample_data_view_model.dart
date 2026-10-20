import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/services/clock.dart';
import '../../../clients/clients.dart';
import '../../../invoices/providers.dart';
import '../../data/sample_invoice_seeder.dart';

part 'sample_data_view_model.g.dart';

/// Debug builds only: adds sample invoices. State is true while working.
@riverpod
class SampleDataViewModel extends _$SampleDataViewModel {
  @override
  bool build() => false;

  Future<Result<void>> addSampleInvoices() async {
    state = true;
    final result = await Result.guard(
      () => SampleInvoiceSeeder(
        ref.read(invoiceRepositoryProvider),
        ref.read(clientRepositoryProvider),
      ).seed(ref.read(clockProvider)()),
    );
    if (ref.mounted) state = false;
    return result;
  }
}
