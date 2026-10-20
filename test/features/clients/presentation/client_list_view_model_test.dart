import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/features/clients/domain/models/client.dart';
import 'package:receipt_maker/features/clients/presentation/view_models/client_list_state.dart';
import 'package:receipt_maker/features/clients/presentation/view_models/client_list_view_model.dart';
import 'package:receipt_maker/features/clients/providers.dart';

import '../../../helpers/mock_repositories.dart';

void main() {
  late MockClientRepository repo;
  late ProviderContainer container;

  void stub(String query, List<Client> clients) =>
      when(() => repo.watchAll(query: query))
          .thenAnswer((_) => Stream.value(clients));

  Future<ClientListState> current() =>
      container.read(clientListViewModelProvider.future);

  /// Starts listening; call after stubbing the repository.
  Future<ClientListState> open() {
    container.listen(clientListViewModelProvider, (_, _) {});
    return current();
  }

  setUp(() {
    repo = MockClientRepository();
    container = ProviderContainer(
      overrides: [clientRepositoryProvider.overrideWithValue(repo)],
    );
  });
  tearDown(() => container.dispose());

  test('an empty catalog is "empty", not "no matches"', () async {
    stub('', []);
    final state = await open();
    expect(state.isEmpty, isTrue);
    expect(state.hasNoMatches, isFalse);
  });

  test('lists what the repository returns', () async {
    stub('', [testClient(), testClient(id: 'c2', name: 'Karim')]);
    final state = await open();
    expect(state.clients.map((c) => c.name), ['Rahman Traders', 'Karim']);
    expect(state.isEmpty, isFalse);
  });

  test('search passes the query to the repository', () async {
    stub('', [testClient()]);
    stub('zz', []);
    await open();
    container.read(clientListViewModelProvider.notifier).search('zz');
    final state = await current();
    expect(state.query, 'zz');
    expect(state.hasNoMatches, isTrue);
    expect(state.isEmpty, isFalse);
    verify(() => repo.watchAll(query: 'zz')).called(1);
  });
}
