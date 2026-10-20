import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/utils/id_generator.dart';
import '../../domain/logic/client_field_access.dart';
import '../../domain/logic/client_validator.dart';
import '../../domain/models/client.dart';
import '../../domain/models/client_field.dart';
import '../../providers.dart';
import 'client_editor_state.dart';

part 'client_editor_view_model.g.dart';

/// Adds a client ([clientId] null) or edits an existing one.
@riverpod
class ClientEditorViewModel extends _$ClientEditorViewModel {
  ClientEditorState? get _form => state.value;

  @override
  Future<ClientEditorState> build(String? clientId) async {
    final id = clientId;
    if (id == null) {
      final now = DateTime.now().toUtc();
      final blank = Client(
        id: IdGenerator.next(),
        name: '',
        createdAt: now,
        updatedAt: now,
      );
      return _initial(blank, isNew: true);
    }
    return switch (await ref.watch(clientRepositoryProvider).find(id)) {
      Ok(:final value) => _initial(value, isNew: false),
      Err(:final failure) => throw failure,
    };
  }

  static ClientEditorState _initial(Client c, {required bool isNew}) =>
      ClientEditorState(
        draft: c,
        initial: c,
        isNew: isNew,
        errors: ClientValidator.validate(c),
      );

  void _set(ClientEditorState Function(ClientEditorState form) update) {
    final form = _form;
    if (form != null) state = AsyncData(update(form));
  }

  void updateField(ClientField field, String value) => _set((f) {
    final draft = f.draft.withField(field, value);
    return f.copyWith(draft: draft, errors: ClientValidator.validate(draft));
  });

  void clearFailure() => _set((f) => f.copyWith(failure: null));

  /// Validates and saves. Returns the stored client, or null when invalid
  /// or the save failed (the failure is in state).
  Future<Client?> save() async {
    final form = _form;
    if (form == null || form.isBusy) return null;
    _set((f) => f.copyWith(showErrors: true));
    if (form.errors.isNotEmpty) return null;
    _set((f) => f.copyWith(isSaving: true));
    final result = await ref
        .read(clientRepositoryProvider)
        .save(form.draft.copyWith(updatedAt: DateTime.now().toUtc()));
    switch (result) {
      case Ok(:final value):
        _set(
          (f) => f.copyWith(
            draft: value,
            initial: value,
            isNew: false,
            isSaving: false,
          ),
        );
        return value;
      case Err(:final failure):
        _set((f) => f.copyWith(isSaving: false, failure: failure));
        return null;
    }
  }

  /// Deletes the stored client. Returns true on success.
  Future<bool> delete() async {
    final form = _form;
    if (form == null || form.isNew || form.isBusy) return false;
    _set((f) => f.copyWith(isDeleting: true));
    final result = await ref
        .read(clientRepositoryProvider)
        .delete(form.initial.id);
    switch (result) {
      case Ok():
        _set((f) => f.copyWith(isDeleting: false, draft: f.initial));
        return true;
      case Err(:final failure):
        _set((f) => f.copyWith(isDeleting: false, failure: failure));
        return false;
    }
  }
}
