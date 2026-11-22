import 'calendar_date.dart';

/// Extra filters on a document list (invoices, estimates): one client, one
/// currency and an issue-date range. Empty means "show everything".
class DocumentFilters {
  const DocumentFilters({
    this.clientId,
    this.clientName,
    this.currencyCode,
    this.issueFrom,
    this.issueTo,
  });

  final String? clientId;

  /// Shown in the filter sheet; not used for matching.
  final String? clientName;
  final String? currencyCode;
  final CalendarDate? issueFrom;
  final CalendarDate? issueTo;

  bool get isEmpty =>
      clientId == null &&
      currencyCode == null &&
      issueFrom == null &&
      issueTo == null;

  bool matches({
    required String? clientId,
    required String currencyCode,
    required CalendarDate issueDate,
  }) {
    if (this.clientId != null && clientId != this.clientId) return false;
    if (this.currencyCode != null && currencyCode != this.currencyCode) {
      return false;
    }
    final from = issueFrom;
    if (from != null && issueDate.key < from.key) return false;
    final to = issueTo;
    if (to != null && issueDate.key > to.key) return false;
    return true;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentFilters &&
          clientId == other.clientId &&
          clientName == other.clientName &&
          currencyCode == other.currencyCode &&
          issueFrom == other.issueFrom &&
          issueTo == other.issueTo;

  @override
  int get hashCode =>
      Object.hash(clientId, clientName, currencyCode, issueFrom, issueTo);
}
