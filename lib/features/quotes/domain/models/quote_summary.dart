import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/calendar_date.dart';
import 'quote_status.dart';

part 'quote_summary.freezed.dart';

@freezed
abstract class QuoteSummary with _$QuoteSummary {
  const factory QuoteSummary({
    required String id,
    required String number,
    required String currencyCode,
    required CalendarDate issueDate,
    required CalendarDate validUntil,
    required QuoteStatus status,
    required int totalMinor,
    String? clientId,
    String? clientName,
    String? convertedInvoiceId,
  }) = _QuoteSummary;
}
