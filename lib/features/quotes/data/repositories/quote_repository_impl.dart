import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/daos/business_profile_dao.dart';
import '../../../../core/database/daos/quote_dao.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../invoices/domain/logic/invoice_calculator.dart';
import '../../../invoices/domain/logic/invoice_number_generator.dart';
import '../../domain/logic/quote_to_invoice.dart';
import '../../domain/models/quote.dart';
import '../../domain/models/quote_summary.dart';
import '../../domain/repositories/quote_repository.dart';
import '../mappers/quote_mapper.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  QuoteRepositoryImpl(this._dao, this._profiles);

  final QuoteDao _dao;
  final BusinessProfileDao _profiles;

  static const String numberField = 'number';

  static Failure _db(Object e, StackTrace s) =>
      e is Failure ? e : DatabaseFailure(cause: e, stackTrace: s);

  Future<String> _profileId() async {
    final profile = await _profiles.getPrimary();
    if (profile == null) throw const NotFoundFailure();
    return profile.id;
  }

  @override
  Stream<List<QuoteSummary>> watchAll({String query = ''}) => _dao
      .watchAll(query: query.trim())
      .map((rows) => [for (final r in rows) r.toSummary()]);

  @override
  Stream<Quote?> watch(String id) => _dao.watchById(id).asyncMap((row) async {
    if (row == null) return null;
    return row.toDomain(await _dao.linesOf(id));
  });

  @override
  Future<Result<Quote>> find(String id) => Result.guard(() async {
    final row = await _dao.findById(id);
    if (row == null) throw const NotFoundFailure();
    return row.toDomain(await _dao.linesOf(id));
  }, onError: _db);

  @override
  Future<Result<({String prefix, int nextSequence})>> nextNumber() =>
      Result.guard(() async {
        final numbering = await _dao.numberingFor(await _profileId());
        return (prefix: numbering.prefix, nextSequence: numbering.nextSequence);
      }, onError: _db);

  @override
  Future<Result<Quote>> save(Quote quote) => Result.guard(() async {
    final profileId = await _profileId();
    final number = quote.number.trim();
    if (await _dao.numberTaken(profileId, number, exceptId: quote.id)) {
      throw const ValidationFailure(numberField);
    }
    final total = InvoiceCalculator.calculate(QuoteToInvoice.asInvoice(quote))
        .total;
    await _dao.upsert(
      quote.toRow(profileId: profileId, totalMinor: total),
      quote.toLineRows(),
    );
    await _dao.bumpNumbering(
      profileId: profileId,
      prefix: 'QUO-',
      savedNumber: number,
    );
    final saved = await _dao.findById(quote.id);
    if (saved == null) throw const NotFoundFailure();
    return saved.toDomain(await _dao.linesOf(quote.id));
  }, onError: _db);

  @override
  Future<Result<void>> delete(String id) =>
      Result.guard(() => _dao.deleteById(id), onError: _db);

  String suggestFormatted(({String prefix, int nextSequence}) n) =>
      InvoiceNumberGenerator.format(
        n.prefix,
        n.nextSequence,
        padding: AppConstants.invoiceNumberPadding,
      );
}
