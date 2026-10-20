import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/calendar_date.dart';
import 'invoice_stage.dart';

part 'invoice_summary.freezed.dart';

/// What the invoice list needs, without lines.
@freezed
abstract class InvoiceSummary with _$InvoiceSummary {
  const factory InvoiceSummary({
    required String id,
    required String number,
    required String currencyCode,
    required CalendarDate issueDate,
    required CalendarDate dueDate,
    required InvoiceStage stage,
    required int totalMinor,
    @Default(0) int paidMinor,
    String? clientName,
  }) = _InvoiceSummary;
}
