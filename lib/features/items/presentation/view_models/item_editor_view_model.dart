import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/service_providers.dart';
import '../../../../core/utils/id_generator.dart';
import '../../domain/logic/item_validator.dart';
import '../../domain/models/item.dart';
import '../../providers.dart';
import 'item_editor_state.dart';

part 'item_editor_view_model.g.dart';

/// Adds an item ([itemId] null) or edits an existing one. New items use
/// the default currency from settings.
@riverpod
class ItemEditorViewModel extends _$ItemEditorViewModel {
  ItemEditorState? get _form => state.value;

  @override
  Future<ItemEditorState> build(String? itemId) async {
    final id = itemId;
    if (id == null) {
      final now = DateTime.now().toUtc();
      final currency =
          ref.read(appPreferencesProvider).defaultCurrency ??
          AppConstants.defaultCurrencyCode;
      final blank = Item(
        id: IdGenerator.next(),
        name: '',
        unitPriceMinor: 0,
        currencyCode: currency,
        createdAt: now,
        updatedAt: now,
      );
      return _initial(blank, isNew: true);
    }
    return switch (await ref.watch(itemRepositoryProvider).find(id)) {
      Ok(:final value) => _initial(value, isNew: false),
      Err(:final failure) => throw failure,
    };
  }

  static ItemEditorState _initial(Item item, {required bool isNew}) =>
      ItemEditorState(
        draft: item,
        initial: item,
        isNew: isNew,
        hasPrice: !isNew,
        errors: ItemValidator.validate(item, hasPrice: !isNew),
      );

  /// Applies [edit] to the draft (and price presence) and revalidates.
  void _edit(Item Function(Item draft) edit, {bool? hasPrice}) {
    final form = _form;
    if (form == null) return;
    final draft = edit(form.draft);
    final priced = hasPrice ?? form.hasPrice;
    state = AsyncData(
      form.copyWith(
        draft: draft,
        hasPrice: priced,
        errors: ItemValidator.validate(draft, hasPrice: priced),
      ),
    );
  }

  void _set(ItemEditorState Function(ItemEditorState form) update) {
    final form = _form;
    if (form != null) state = AsyncData(update(form));
  }

  void setName(String value) => _edit((d) => d.copyWith(name: value));

  void setDescription(String value) =>
      _edit((d) => d.copyWith(description: value));

  void setUnit(String value) => _edit((d) => d.copyWith(unit: value));

  /// [minor] is null while the field is empty.
  void setUnitPrice(int? minor) => _edit(
    (d) => d.copyWith(unitPriceMinor: minor ?? 0),
    hasPrice: minor != null,
  );

  void setCurrency(String code) => _edit((d) => d.copyWith(currencyCode: code));

  /// [basisPoints] is null for no default tax.
  void setDefaultTax(int? basisPoints) =>
      _edit((d) => d.copyWith(defaultTaxBasisPoints: basisPoints));

  void clearFailure() => _set((f) => f.copyWith(failure: null));

  /// Validates and saves. Returns the stored item, or null when invalid or
  /// the save failed (the failure is in state).
  Future<Item?> save() async {
    final form = _form;
    if (form == null || form.isBusy) return null;
    _set((f) => f.copyWith(showErrors: true));
    if (form.errors.isNotEmpty) return null;
    _set((f) => f.copyWith(isSaving: true));
    final result = await ref
        .read(itemRepositoryProvider)
        .save(form.draft.copyWith(updatedAt: DateTime.now().toUtc()));
    switch (result) {
      case Ok(:final value):
        _set(
          (f) => f.copyWith(
            draft: value,
            initial: value,
            isNew: false,
            hasPrice: true,
            isSaving: false,
          ),
        );
        return value;
      case Err(:final failure):
        _set((f) => f.copyWith(isSaving: false, failure: failure));
        return null;
    }
  }

  /// Deletes the stored item. Returns true on success.
  Future<bool> delete() async {
    final form = _form;
    if (form == null || form.isNew || form.isBusy) return false;
    _set((f) => f.copyWith(isDeleting: true));
    final result = await ref
        .read(itemRepositoryProvider)
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
