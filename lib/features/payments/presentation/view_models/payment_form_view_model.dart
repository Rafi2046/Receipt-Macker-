import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/clock.dart';
import '../../../../core/utils/calendar_date.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../invoices/domain/logic/invoice_calculator.dart';
import '../../../invoices/providers.dart';
import '../../domain/models/payment.dart';
import '../../domain/models/payment_method.dart';
import '../../providers.dart';
import 'payment_form_state.dart';

part 'payment_form_view_model.g.dart';

/// Records a payment ([paymentId] null) or edits one. The amount starts as
/// the balance due. Saving rejects anything above what is still owed.
@riverpod
class PaymentFormViewModel extends _$PaymentFormViewModel {
  @override
  Future<PaymentFormState> build(String invoiceId, String? paymentId) async {
    final found = await ref.watch(invoiceRepositoryProvider).find(invoiceId);
    final invoice = switch (found) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
    final payments = await ref
        .watch(paymentRepositoryProvider)
        .watchForInvoice(invoiceId)
        .first;
    final existing = [
      for (final p in payments)
        if (p.id == paymentId) p,
    ].firstOrNull;
    if (paymentId != null && existing == null) throw const NotFoundFailure();
    final now = ref.read(clockProvider)();
    final already = existing?.amountMinor ?? 0;
    final balance = InvoiceCalculator.calculate(
      invoice,
      paidMinor: invoice.paidMinor,
    ).balance;
    final max = balance + already;
    return PaymentFormState(
      draft:
          existing ??
          Payment(
            id: IdGenerator.next(),
            invoiceId: invoiceId,
            amountMinor: max < 0 ? 0 : max,
            paidOn: CalendarDate.fromLocal(now),
            method: PaymentMethod.cash,
            createdAt: now,
            updatedAt: now,
          ),
      maxMinor: max < 0 ? 0 : max,
      currencyCode: invoice.currencyCode,
      isNew: existing == null,
    );
  }

  void _set(PaymentFormState Function(PaymentFormState form) update) {
    final form = state.value;
    if (form != null) state = AsyncData(update(form));
  }

  void setAmount(int? minor) =>
      _set((f) => f.copyWith(draft: f.draft.copyWith(amountMinor: minor ?? 0)));

  void setDate(DateTime date) => _set(
    (f) => f.copyWith(
      draft: f.draft.copyWith(paidOn: CalendarDate.fromLocal(date)),
    ),
  );

  void setMethod(PaymentMethod method) =>
      _set((f) => f.copyWith(draft: f.draft.copyWith(method: method)));

  void setNote(String note) =>
      _set((f) => f.copyWith(draft: f.draft.copyWith(note: note)));

  /// Saves when the form is valid. Returns the stored payment, or null
  /// when it was rejected (the reason is in state).
  Future<Payment?> save() async {
    final form = state.value;
    if (form == null || form.isSaving) return null;
    final shown = form.copyWith(showErrors: true, failure: null);
    state = AsyncData(shown);
    if (shown.errors.isNotEmpty) return null;
    state = AsyncData(shown.copyWith(isSaving: true));
    final now = ref.read(clockProvider)();
    final result = await ref
        .read(paymentRepositoryProvider)
        .save(shown.draft.copyWith(updatedAt: now));
    switch (result) {
      case Ok(:final value):
        return value;
      case Err(:final failure):
        state = AsyncData(shown.copyWith(failure: failure));
        return null;
    }
  }
}
