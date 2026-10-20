import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/clock.dart';
import '../../../../core/services/service_providers.dart';
import '../../../../core/utils/calendar_date.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../business_profile/business_profile.dart';
import '../../../clients/clients.dart';
import '../../../items/items.dart';
import '../../data/repositories/invoice_repository_impl.dart';
import '../../domain/logic/invoice_drafting.dart';
import '../../domain/logic/invoice_validator.dart';
import '../../domain/models/bill_to.dart';
import '../../domain/models/discount.dart';
import '../../domain/models/due_term.dart';
import '../../domain/models/invoice.dart';
import '../../domain/models/line_item.dart';
import '../../providers.dart';
import 'invoice_editor_state.dart';

part 'invoice_editor_view_model.g.dart';
part 'invoice_line_editing.dart';

/// Creates an invoice, edits one ([invoiceId]), or starts a new one as a
/// copy of another ([copyOf]). Line edits are in [InvoiceLineEditing].
@riverpod
class InvoiceEditorViewModel extends _$InvoiceEditorViewModel {
  InvoiceEditorState? get form => state.value;

  @override
  Future<InvoiceEditorState> build(String? invoiceId, String? copyOf) async {
    final repo = ref.watch(invoiceRepositoryProvider);
    final now = ref.read(clockProvider)();
    final today = CalendarDate.fromLocal(now);
    if (invoiceId != null) {
      return _start(_unwrap(await repo.find(invoiceId)), isNew: false);
    }
    final number = _unwrap(await repo.suggestNumber());
    if (copyOf != null) {
      final source = _unwrap(await repo.find(copyOf));
      final copy = source.duplicate(
        id: IdGenerator.next(),
        number: number,
        today: today,
        now: now,
        newLineId: IdGenerator.next,
      );
      return _start(copy, isNew: true, isCopy: true);
    }
    final profile =
        (await ref.read(businessProfileRepositoryProvider).load()).valueOrNull;
    final blank = Invoice(
      id: IdGenerator.next(),
      number: number,
      currencyCode:
          ref.read(appPreferencesProvider).defaultCurrency ??
          AppConstants.defaultCurrencyCode,
      issueDate: today,
      dueDate: today.addDays(AppConstants.defaultDueDays),
      createdAt: now,
      updatedAt: now,
      notes: profile?.defaultNotes ?? '',
      terms: profile?.defaultTerms ?? '',
      paymentInstructions: profile?.paymentInstructions ?? '',
    );
    return _start(blank, isNew: true);
  }

  static T _unwrap<T>(Result<T> result) => switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };

  static InvoiceEditorState _start(
    Invoice invoice, {
    required bool isNew,
    bool isCopy = false,
  }) => InvoiceEditorState(
    draft: invoice,
    initial: invoice,
    isNew: isNew,
    isCopy: isCopy,
    validation: InvoiceValidator.validate(invoice),
  );

  /// Applies [edit] to the draft and revalidates.
  void _edit(Invoice Function(Invoice draft) edit) {
    final f = form;
    if (f == null) return;
    final draft = edit(f.draft);
    state = AsyncData(
      f.copyWith(
        draft: draft,
        validation: InvoiceValidator.validate(draft),
        numberTaken: f.numberTaken && draft.number == f.draft.number,
      ),
    );
  }

  void _patch(InvoiceEditorState Function(InvoiceEditorState f) change) {
    final f = form;
    if (f != null) state = AsyncData(change(f));
  }

  void setNumber(String value) => _edit((d) => d.copyWith(number: value));

  void setIssueDate(CalendarDate date) => _edit((d) => d.withIssueDate(date));

  void setDueTerm(DueTerm term) => _edit((d) => d.withDueTerm(term));

  void setDueDate(CalendarDate date) => _edit((d) => d.copyWith(dueDate: date));

  /// Keeps the face value of amounts (৳500.00 becomes ¥500).
  void setCurrency(String code) {
    _edit((d) => withCurrency(d, code));
    _patch(
      (f) => f.copyWith(
        foreignPriceLines: {
          for (final e in f.foreignPriceLines.entries)
            if (e.value != code) e.key: e.value,
        },
      ),
    );
  }

  static Invoice withCurrency(Invoice d, String code) => d.withCurrency(
    code,
    fromDecimals: AppFormatters.currencyDecimalDigits(d.currencyCode),
    toDecimals: AppFormatters.currencyDecimalDigits(code),
  );

  /// Copies the client's details onto the invoice.
  void setClient(Client client) => _edit(
    (d) => d.withBillTo(
      clientId: client.id,
      billTo: BillTo(
        name: client.name,
        phone: client.phone,
        email: client.email,
        address: client.address,
      ),
    ),
  );

  void clearClient() => _edit((d) => d.withoutBillTo());

  void setDiscount(Discount? discount) =>
      _edit((d) => d.copyWith(discount: discount));

  void setTaxRate(int? basisPoints) =>
      _edit((d) => d.copyWith(taxRateBasisPoints: basisPoints));

  void setTaxInclusive({required bool inclusive}) =>
      _edit((d) => d.copyWith(taxInclusive: inclusive));

  void setShipping(int? minor) =>
      _edit((d) => d.copyWith(shippingMinor: minor ?? 0));

  void setNotes(String value) => _edit((d) => d.copyWith(notes: value));

  void setTerms(String value) => _edit((d) => d.copyWith(terms: value));

  void setPaymentInstructions(String value) =>
      _edit((d) => d.copyWith(paymentInstructions: value));

  void clearFailure() => _patch((f) => f.copyWith(failure: null));

  /// Validates and saves. Returns the stored invoice, or null when invalid
  /// or the save failed (the reason is in state).
  Future<Invoice?> save() async {
    final f = form;
    if (f == null || f.isSaving) return null;
    _patch((f) => f.copyWith(showErrors: true));
    if (!f.validation.isValid) return null;
    _patch((f) => f.copyWith(isSaving: true));
    final now = ref.read(clockProvider)();
    final result = await ref
        .read(invoiceRepositoryProvider)
        .save(f.draft.copyWith(updatedAt: now));
    switch (result) {
      case Ok(:final value):
        _patch(
          (f) => f.copyWith(
            draft: value,
            initial: value,
            isNew: false,
            isCopy: false,
            isSaving: false,
            validation: InvoiceValidator.validate(value),
          ),
        );
        return value;
      case Err(
        failure: ValidationFailure(field: InvoiceRepositoryImpl.numberField),
      ):
        _patch((f) => f.copyWith(isSaving: false, numberTaken: true));
        return null;
      case Err(:final failure):
        _patch((f) => f.copyWith(isSaving: false, failure: failure));
        return null;
    }
  }

  /// A line for [item]. Returns its id and whether the user must enter the
  /// price (the item is priced in another currency).
  ({String lineId, bool needsPrice}) addItem(Item item) {
    final f = form;
    final id = IdGenerator.next();
    if (f == null) return (lineId: id, needsPrice: false);
    var draft = f.draft;
    if (draft.lines.isEmpty && item.currencyCode != draft.currencyCode) {
      draft = withCurrency(draft, item.currencyCode);
    }
    final foreign = item.currencyCode != draft.currencyCode;
    draft = draft.withLine(
      LineItem(
        id: id,
        name: item.name,
        description: item.description,
        unit: item.unit,
        unitPriceMinor: foreign ? 0 : item.unitPriceMinor,
        itemId: item.id,
      ),
    );
    final tax = item.defaultTaxBasisPoints;
    if (draft.taxRateBasisPoints == null && tax != null) {
      draft = draft.copyWith(taxRateBasisPoints: tax);
    }
    _edit((_) => draft);
    if (foreign) {
      _patch(
        (f) => f.copyWith(
          foreignPriceLines: {...f.foreignPriceLines, id: item.currencyCode},
        ),
      );
    }
    return (lineId: id, needsPrice: foreign);
  }
}
