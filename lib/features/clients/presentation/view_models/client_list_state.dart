import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/client.dart';

part 'client_list_state.freezed.dart';

@freezed
abstract class ClientListState with _$ClientListState {
  const factory ClientListState({
    required List<Client> clients,
    @Default('') String query,
  }) = _ClientListState;

  const ClientListState._();

  bool get isSearching => query.trim().isNotEmpty;

  /// Nothing saved yet: show the "add your first client" state.
  bool get isEmpty => clients.isEmpty && !isSearching;

  bool get hasNoMatches => clients.isEmpty && isSearching;
}
