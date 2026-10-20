import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'client_search_query.g.dart';

/// What the user typed in the client search box. Resets when the list closes.
@riverpod
class ClientSearchQuery extends _$ClientSearchQuery {
  @override
  String build() => '';

  void search(String query) => state = query;
}
