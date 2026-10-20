import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/clock.dart';
import '../../domain/logic/invoice_calculator.dart';
import '../../domain/logic/invoice_status_resolver.dart';
import '../../domain/models/invoice_stage.dart';
import '../../providers.dart';
import 'invoice_detail_state.dart';

part 'invoice_detail_view_model.g.dart';

/// One invoice with its totals and status, kept up to date.
@riverpod
class InvoiceDetailViewModel extends _$InvoiceDetailViewModel {
  @override
  Stream<InvoiceDetailState> build(String invoiceId) {
    final today = ref.watch(clockProvider).today();
    return ref.watch(invoiceRepositoryProvider).watch(invoiceId).map((invoice) {
      if (invoice == null) throw const NotFoundFailure();
      final totals = InvoiceCalculator.calculate(
        invoice,
        paidMinor: invoice.paidMinor,
      );
      return InvoiceDetailState(
        invoice: invoice,
        totals: totals,
        status: InvoiceStatusResolver.resolve(
          stage: invoice.stage,
          totalMinor: totals.total,
          paidMinor: totals.paid,
          dueDate: invoice.dueDate,
          today: today,
        ),
      );
    });
  }

  /// Marks the invoice as sent (or back to draft).
  Future<Result<void>> setStage(InvoiceStage stage) async {
    final current = state.value?.invoice;
    if (current == null) return const Err(NotFoundFailure());
    final now = ref.read(clockProvider)();
    final result = await ref
        .read(invoiceRepositoryProvider)
        .save(current.copyWith(stage: stage, updatedAt: now));
    return switch (result) {
      Ok() => const Ok(null),
      Err(:final failure) => Err(failure),
    };
  }

  Future<Result<void>> delete() =>
      ref.read(invoiceRepositoryProvider).delete(invoiceId);
}
