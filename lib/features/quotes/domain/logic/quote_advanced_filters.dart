import '../../../../core/utils/calendar_date.dart';
import '../models/quote_summary.dart';

/// Extra filters on the quotes list (with a status chip).
class QuoteAdvancedFilters {
  const QuoteAdvancedFilters({
    this.clientId,
    this.clientName,
    this.currencyCode,
    this.issueFrom,
    this.issueTo,
  });

  final String? clientId;
  final String? clientName;
  final String? currencyCode;
  final CalendarDate? issueFrom;
  final CalendarDate? issueTo;

  bool get isEmpty =>
      clientId == null &&
      currencyCode == null &&
      issueFrom == null &&
      issueTo == null;

  bool matches(QuoteSummary summary) {
    if (clientId != null && summary.clientId != clientId) return false;
    if (currencyCode != null && summary.currencyCode != currencyCode) {
      return false;
    }
    if (issueFrom != null && summary.issueDate.key < issueFrom!.key) {
      return false;
    }
    if (issueTo != null && summary.issueDate.key > issueTo!.key) return false;
    return true;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteAdvancedFilters &&
          clientId == other.clientId &&
          clientName == other.clientName &&
          currencyCode == other.currencyCode &&
          issueFrom == other.issueFrom &&
          issueTo == other.issueTo;

  @override
  int get hashCode =>
      Object.hash(clientId, clientName, currencyCode, issueFrom, issueTo);
}
