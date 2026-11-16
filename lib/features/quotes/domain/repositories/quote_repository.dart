import '../../../../core/errors/result.dart';
import '../models/quote.dart';
import '../models/quote_summary.dart';

abstract interface class QuoteRepository {
  Stream<List<QuoteSummary>> watchAll({String query = ''});
  Future<Result<Quote>> find(String id);
  Stream<Quote?> watch(String id);
  Future<Result<Quote>> save(Quote quote);
  Future<Result<void>> delete(String id);
  Future<Result<({String prefix, int nextSequence})>> nextNumber();
}
