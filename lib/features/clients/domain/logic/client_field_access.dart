import '../models/client.dart';
import '../models/client_field.dart';

/// Reads and writes a client's fields by [ClientField], so the editor can be
/// driven by one `updateField` intent.
extension ClientFieldAccess on Client {
  String valueOf(ClientField field) => switch (field) {
    ClientField.name => name,
    ClientField.phone => phone,
    ClientField.email => email,
    ClientField.address => address,
    ClientField.notes => notes,
  };

  Client withField(ClientField field, String value) => switch (field) {
    ClientField.name => copyWith(name: value),
    ClientField.phone => copyWith(phone: value),
    ClientField.email => copyWith(email: value),
    ClientField.address => copyWith(address: value),
    ClientField.notes => copyWith(notes: value),
  };

  /// Same content, ignoring timestamps. Used to detect unsaved edits.
  bool sameContentAs(Client other) =>
      copyWith(createdAt: other.createdAt, updatedAt: other.updatedAt) == other;
}
