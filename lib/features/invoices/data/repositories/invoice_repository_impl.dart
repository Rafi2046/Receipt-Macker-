import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/business_profile_dao.dart';
import '../../../../core/database/daos/invoice_dao.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/logic/invoice_calculator.dart';
import '../../domain/logic/invoice_number_generator.dart';
import '../../domain/models/invoice.dart';
import '../../domain/models/invoice_summary.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../mappers/invoice_mapper.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  InvoiceRepositoryImpl(this._dao, this._profiles);

  final InvoiceDao _dao;
  final BusinessProfileDao _profiles;

  /// Field name used in `ValidationFailure` for a duplicate number.
  static const String numberField = 'number';

  static Failure _db(Object e, StackTrace s) =>
      e is Failure ? e : DatabaseFailure(cause: e, stackTrace: s);

  @override
  Stream<List<InvoiceSummary>> watchAll({String query = ''}) => _dao
      .watchAll(query: query.trim())
      .map((rows) => [for (final r in rows) r.toSummary()]);

  @override
  Stream<Invoice?> watch(String id) => _dao.watchById(id).asyncMap((row) async {
    if (row == null) return null;
    return row.toDomain(await _dao.linesOf(id));
  });

  @override
  Future<Result<Invoice>> find(String id) => Result.guard(() async {
    final row = await _dao.findById(id);
    if (row == null) throw const NotFoundFailure();
    return row.toDomain(await _dao.linesOf(id));
  }, onError: _db);

  @override
  Future<Result<String>> suggestNumber() => Result.guard(() async {
    final numbering = await _numbering(await _profileId());
    return InvoiceNumberGenerator.format(
      numbering.prefix,
      numbering.nextSequence,
      padding: AppConstants.invoiceNumberPadding,
    );
  }, onError: _db);

  @override
  Future<Result<Invoice>> save(Invoice invoice) => Result.guard(
    () => _dao.transaction(() async {
      final profileId = await _profileId();
      final number = invoice.number.trim();
      if (await _dao.numberTaken(profileId, number, exceptId: invoice.id)) {
        throw const ValidationFailure(numberField);
      }
      final paid = (await _dao.findById(invoice.id))?.paidMinor ?? 0;
      final stored = invoice.copyWith(paidMinor: paid);
      final total = InvoiceCalculator.calculate(stored).total;
      final row = stored.toRow(profileId: profileId, totalMinor: total);
      await _dao.upsertWithLines(row, invoice.toLineRows());
      final numbering = await _numbering(profileId);
      final next = InvoiceNumberGenerator.nextAfterSaving(
        numbering.nextSequence,
        numbering.prefix,
        number,
      );
      await _dao.upsertNumbering(numbering.copyWith(nextSequence: next));
      return row.toDomain(await _dao.linesOf(invoice.id));
    }),
    onError: _db,
  );

  @override
  Future<Result<void>> delete(String id) =>
      Result.guard(() => _dao.deleteById(id), onError: _db);

  Future<String> _profileId() async {
    final profile = await _profiles.getPrimary();
    if (profile == null) throw const NotFoundFailure();
    return profile.id;
  }

  Future<InvoiceNumberingRow> _numbering(String profileId) async =>
      await _dao.numberingOf(profileId) ??
      InvoiceNumberingRow(
        profileId: profileId,
        prefix: AppConstants.defaultInvoicePrefix,
        nextSequence: 1,
      );
}
