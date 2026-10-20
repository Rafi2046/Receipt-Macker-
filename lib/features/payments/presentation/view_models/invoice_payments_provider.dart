import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/payment.dart';
import '../../providers.dart';

part 'invoice_payments_provider.g.dart';

/// Payments on one invoice, oldest first.
@riverpod
Stream<List<Payment>> invoicePayments(Ref ref, String invoiceId) =>
    ref.watch(paymentRepositoryProvider).watchForInvoice(invoiceId);
