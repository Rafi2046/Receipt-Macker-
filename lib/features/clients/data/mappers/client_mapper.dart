import '../../../../core/database/app_database.dart';
import '../../../../core/utils/money_input_parser.dart';
import '../../domain/models/client.dart';

/// Converts between DB rows and the domain model. Dates are stored in UTC.
extension ClientRowMapper on ClientRow {
  Client toDomain() => Client(
    id: id,
    name: name,
    phone: phone,
    email: email,
    address: address,
    notes: notes,
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
  );
}

extension ClientToRow on Client {
  /// Trims text and stores phone digits in Latin form, so a number typed
  /// with Bangla digits is found by either kind of search.
  ClientRow toRow() => ClientRow(
    id: id,
    name: name.trim(),
    phone: MoneyInputParser.normalize(phone.trim()),
    email: email.trim(),
    address: address.trim(),
    notes: notes.trim(),
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
  );
}
