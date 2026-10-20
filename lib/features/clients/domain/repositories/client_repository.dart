import '../../../../core/errors/result.dart';
import '../models/client.dart';

abstract interface class ClientRepository {
  /// All clients A-Z; a non-empty [query] filters by name, phone or email.
  Stream<List<Client>> watchAll({String query = ''});

  /// Fails with `NotFoundFailure` when there is no client with [id].
  Future<Result<Client>> find(String id);

  /// Inserts or updates; returns the client as stored.
  Future<Result<Client>> save(Client client);

  Future<Result<void>> delete(String id);
}
