import '../../../../core/database/daos/item_dao.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/models/item.dart';
import '../../domain/repositories/item_repository.dart';
import '../mappers/item_mapper.dart';

class ItemRepositoryImpl implements ItemRepository {
  ItemRepositoryImpl(this._dao);

  final ItemDao _dao;

  static Failure _db(Object e, StackTrace s) =>
      e is Failure ? e : DatabaseFailure(cause: e, stackTrace: s);

  @override
  Stream<List<Item>> watchAll({String query = ''}) => _dao
      .watchAll(query: query.trim())
      .map((rows) => [for (final r in rows) r.toDomain()]);

  @override
  Future<Result<Item>> find(String id) => Result.guard(() async {
    final row = await _dao.findById(id);
    if (row == null) throw const NotFoundFailure();
    return row.toDomain();
  }, onError: _db);

  @override
  Future<Result<Item>> save(Item item) => Result.guard(() async {
    final row = item.toRow();
    await _dao.upsert(row);
    return row.toDomain();
  }, onError: _db);

  @override
  Future<Result<void>> delete(String id) =>
      Result.guard(() => _dao.deleteById(id), onError: _db);
}
