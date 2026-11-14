import '../../../../core/errors/result.dart';
import '../models/invoice.dart';
import '../models/invoice_numbering.dart';
import '../models/invoice_summary.dart';

abstract interface class InvoiceRepository {
  /// Newest first (by issue date, then number). A non-empty [query] matches
  /// the number or the client's name.
  Stream<List<InvoiceSummary>> watchAll({String query = ''});

  /// Invoices for a specific client, newest first.
  Stream<List<InvoiceSummary>> watchByClient(String clientId);

  /// Emits null once the invoice is deleted.
  Stream<Invoice?> watch(String id);

  /// Fails with `NotFoundFailure` when there is no invoice with [id].
  Future<Result<Invoice>> find(String id);

  /// The number a new invoice gets, e.g. `INV-0007`.
  Future<Result<String>> suggestNumber();

  /// Current prefix and next sequence configuration.
  Future<Result<InvoiceNumbering>> getNumbering();

  /// Updates the prefix and next sequence. Fails with `ValidationFailure('prefix')`
  /// if empty, or `ValidationFailure('nextSequence')` if less than or equal to
  /// the highest existing sequence for that prefix.
  Future<Result<void>> updateNumbering({
    required String prefix,
    required int nextSequence,
  });

  /// Highest sequence number found for [prefix]. Returns 0 if none found.
  Future<Result<int>> getHighestSequence(String prefix);

  /// Inserts or updates with all lines, and moves the number sequence
  /// forward. Fails with `ValidationFailure('number')` when another invoice
  /// already uses the number.
  Future<Result<Invoice>> save(Invoice invoice);

  Future<Result<void>> delete(String id);
}
