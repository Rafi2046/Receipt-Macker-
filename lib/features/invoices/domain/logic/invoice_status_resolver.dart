import '../../../../core/utils/calendar_date.dart';
import '../models/invoice_stage.dart';
import '../models/invoice_status.dart';

/// Works out the status shown to the user from what is stored.
abstract final class InvoiceStatusResolver {
  /// - Draft until sent, unless a payment was recorded.
  /// - Paid once nothing is left to pay.
  /// - Overdue when the due date has passed (the whole due day counts, in
  ///   the phone's time zone) and something is still owed.
  /// - Partially paid when some but not all has been paid.
  /// - Otherwise sent.
  static InvoiceStatus resolve({
    required InvoiceStage stage,
    required int totalMinor,
    required int paidMinor,
    required CalendarDate dueDate,
    required CalendarDate today,
  }) {
    if (stage == InvoiceStage.draft && paidMinor == 0) {
      return InvoiceStatus.draft;
    }
    if (totalMinor - paidMinor <= 0) return InvoiceStatus.paid;
    if (today.isAfter(dueDate)) return InvoiceStatus.overdue;
    if (paidMinor > 0) return InvoiceStatus.partiallyPaid;
    return InvoiceStatus.sent;
  }
}
