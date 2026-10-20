import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/features/business_profile/domain/repositories/business_profile_repository.dart';
import 'package:receipt_maker/features/clients/domain/models/client.dart';
import 'package:receipt_maker/features/clients/domain/repositories/client_repository.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice.dart';
import 'package:receipt_maker/features/invoices/domain/models/line_item.dart';
import 'package:receipt_maker/features/invoices/domain/repositories/invoice_repository.dart';
import 'package:receipt_maker/features/items/domain/models/item.dart';
import 'package:receipt_maker/features/items/domain/repositories/item_repository.dart';

class MockClientRepository extends Mock implements ClientRepository {}

class MockItemRepository extends Mock implements ItemRepository {}

class MockInvoiceRepository extends Mock implements InvoiceRepository {}

class MockBusinessProfileRepository extends Mock
    implements BusinessProfileRepository {}

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

Invoice testInvoice({
  String id = 'inv1',
  String number = 'INV-0001',
  List<LineItem> lines = const [
    LineItem(id: 'l1', name: 'Logo design', unitPriceMinor: 500000),
  ],
}) => Invoice(
  id: id,
  number: number,
  currencyCode: 'BDT',
  issueDate: CalendarDate(2026, 10, 20),
  dueDate: CalendarDate(2026, 10, 27),
  createdAt: testTime,
  updatedAt: testTime,
  lines: lines,
);

/// Call once in `setUpAll` before using `any()` with these types.
void registerRepositoryFallbacks() {
  registerFallbackValue(testClient());
  registerFallbackValue(testItem());
  registerFallbackValue(testInvoice());
}
