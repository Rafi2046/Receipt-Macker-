import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../providers.dart';
import 'client_list_state.dart';
import 'client_search_query.dart';

part 'client_list_view_model.g.dart';

/// Clients A-Z, filtered by [ClientSearchQuery]. Updates live as clients
/// are added, edited or deleted.
@riverpod
class ClientListViewModel extends _$ClientListViewModel {
  @override
  Stream<ClientListState> build() {
    final query = ref.watch(clientSearchQueryProvider);
    return ref
        .watch(clientRepositoryProvider)
        .watchAll(query: query)
        .map((clients) => ClientListState(clients: clients, query: query));
  }

  void search(String query) =>
      ref.read(clientSearchQueryProvider.notifier).search(query);
}
