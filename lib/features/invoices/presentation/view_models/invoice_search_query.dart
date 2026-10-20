import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'invoice_search_query.g.dart';

/// What the user typed in the invoice search box. Resets when the list
/// closes.
@riverpod
class InvoiceSearchQuery extends _$InvoiceSearchQuery {
  @override
  String build() => '';

  void search(String query) => state = query;
}
