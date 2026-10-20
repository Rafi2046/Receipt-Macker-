import '../../../../core/errors/result.dart';
import '../models/invoice.dart';
import '../models/invoice_summary.dart';

abstract interface class InvoiceRepository {
  /// Newest first (by issue date, then number). A non-empty [query] matches
  /// the number or the client's name.
  Stream<List<InvoiceSummary>> watchAll({String query = ''});

  /// Emits null once the invoice is deleted.
  Stream<Invoice?> watch(String id);

  /// Fails with `NotFoundFailure` when there is no invoice with [id].
  Future<Result<Invoice>> find(String id);

  /// The number a new invoice gets, e.g. `INV-0007`.
  Future<Result<String>> suggestNumber();

  /// Inserts or updates with all lines, and moves the number sequence
  /// forward. Fails with `ValidationFailure('number')` when another invoice
  /// already uses the number.
  Future<Result<Invoice>> save(Invoice invoice);

  Future<Result<void>> delete(String id);
}
