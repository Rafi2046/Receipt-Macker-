import '../../../../core/database/daos/client_dao.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/utils/money_input_parser.dart';
import '../../domain/models/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../mappers/client_mapper.dart';

class ClientRepositoryImpl implements ClientRepository {
  ClientRepositoryImpl(this._dao);

  final ClientDao _dao;

  static Failure _db(Object e, StackTrace s) =>
      e is Failure ? e : DatabaseFailure(cause: e, stackTrace: s);

  @override
  Stream<List<Client>> watchAll({String query = ''}) {
    final q = query.trim();
    return _dao
        .watchAll(query: q, phoneQuery: MoneyInputParser.normalize(q))
        .map((rows) => [for (final r in rows) r.toDomain()]);
  }

  @override
  Future<Result<Client>> find(String id) => Result.guard(() async {
    final row = await _dao.findById(id);
    if (row == null) throw const NotFoundFailure();
    return row.toDomain();
  }, onError: _db);

  @override
  Future<Result<Client>> save(Client client) => Result.guard(() async {
    final row = client.toRow();
    await _dao.upsert(row);
    return row.toDomain();
  }, onError: _db);

  @override
  Future<Result<void>> delete(String id) =>
      Result.guard(() => _dao.deleteById(id), onError: _db);
}
