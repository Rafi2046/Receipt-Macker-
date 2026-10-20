import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/features/clients/domain/models/client.dart';
import 'package:receipt_maker/features/clients/domain/repositories/client_repository.dart';
import 'package:receipt_maker/features/items/domain/models/item.dart';
import 'package:receipt_maker/features/items/domain/repositories/item_repository.dart';

class MockClientRepository extends Mock implements ClientRepository {}

class MockItemRepository extends Mock implements ItemRepository {}

final DateTime testTime = DateTime.utc(2026, 10, 20, 8);

Client testClient({String id = 'c1', String name = 'Rahman Traders'}) =>
    Client(id: id, name: name, createdAt: testTime, updatedAt: testTime);

Item testItem({
  String id = 'i1',
  String name = 'Logo design',
  int price = 500000,
  String currency = 'BDT',
}) => Item(
  id: id,
  name: name,
  unitPriceMinor: price,
  currencyCode: currency,
  createdAt: testTime,
  updatedAt: testTime,
);

/// Call once in `setUpAll` before using `any()` with these types.
void registerRepositoryFallbacks() {
  registerFallbackValue(testClient());
  registerFallbackValue(testItem());
}
