import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/quote_list_filter.dart';
import '../../domain/models/quote_summary.dart';

part 'quote_list_state.freezed.dart';

@freezed
abstract class QuoteListState with _$QuoteListState {
  const factory QuoteListState({
    @Default([]) List<QuoteSummary> quotes,
    @Default('') String query,
    @Default(QuoteListFilter.all) QuoteListFilter filter,
  }) = _QuoteListState;

  const QuoteListState._();

  bool get isEmpty => quotes.isEmpty && query.isEmpty;
}
