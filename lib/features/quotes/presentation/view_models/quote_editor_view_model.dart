import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/utils/calendar_date.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../clients/domain/models/client.dart';
import '../../../invoices/domain/logic/invoice_calculator.dart';
import '../../../invoices/domain/logic/invoice_number_generator.dart';
import '../../../invoices/domain/models/bill_to.dart';
import '../../../invoices/domain/models/line_item.dart';
import '../../../invoices/providers.dart';
import '../../../items/domain/models/item.dart';
import '../../domain/logic/quote_to_invoice.dart';
import '../../domain/models/quote.dart';
import '../../domain/models/quote_status.dart';
import '../../providers.dart';
import 'quote_editor_state.dart';

part 'quote_editor_view_model.g.dart';

@riverpod
class QuoteEditorViewModel extends _$QuoteEditorViewModel {
  QuoteEditorState? get _form => state.value;

  @override
  Future<QuoteEditorState> build(String? quoteId) async {
    final repo = ref.watch(quoteRepositoryProvider);
    if (quoteId == null) {
      final next = await repo.nextNumber();
      final now = DateTime.now().toUtc();
      final today = CalendarDate.fromLocal(DateTime.now());
      final number = switch (next) {
        Ok(:final value) => InvoiceNumberGenerator.format(
          value.prefix,
          value.nextSequence,
          padding: AppConstants.invoiceNumberPadding,
        ),
        Err() => 'QUO-0001',
      };
      final blank = Quote(
        id: IdGenerator.next(),
        number: number,
        currencyCode: 'BDT',
        issueDate: today,
        validUntil: today.addDays(15),
        createdAt: now,
        updatedAt: now,
      );
      return QuoteEditorState(draft: blank, initial: blank, isNew: true);
    }
    return switch (await repo.find(quoteId)) {
      Ok(:final value) => QuoteEditorState(
        draft: value,
        initial: value,
        isNew: false,
      ),
      Err(:final failure) => throw failure,
    };
  }

  void _set(QuoteEditorState Function(QuoteEditorState) update) {
    final form = _form;
    if (form != null) state = AsyncData(update(form));
  }

  void clearFailure() => _set((f) => f.copyWith(failure: null));

  void setClient(Client client) => _set((f) {
    final draft = f.draft.copyWith(
      clientId: client.id,
      billTo: BillTo(
        name: client.name,
        phone: client.phone,
        email: client.email,
        address: [
          client.address,
          client.addressLine2,
        ].where((l) => l.trim().isNotEmpty).join('\n'),
      ),
    );
    return f.copyWith(draft: draft);
  });

  void clearClient() => _set(
    (f) => f.copyWith(draft: f.draft.copyWith(clientId: null, billTo: null)),
  );

  void addItem(Item item) => _set((f) {
    final line = LineItem(
      id: IdGenerator.next(),
      name: item.name,
      description: item.description,
      unit: item.unit,
      unitPriceMinor: item.unitPriceMinor,
      itemId: item.id,
    );
    return f.copyWith(
      draft: f.draft.copyWith(
        lines: [...f.draft.lines, line],
        currencyCode: item.currencyCode,
      ),
    );
  });

  void removeLine(String lineId) => _set((f) {
    return f.copyWith(
      draft: f.draft.copyWith(
        lines: [
          for (final l in f.draft.lines)
            if (l.id != lineId) l,
        ],
      ),
    );
  });

  void setStatus(QuoteStatus status) =>
      _set((f) => f.copyWith(draft: f.draft.copyWith(status: status)));

  int totalMinor() {
    final form = _form;
    if (form == null) return 0;
    return InvoiceCalculator.calculate(QuoteToInvoice.asInvoice(form.draft))
        .total;
  }

  Future<Quote?> save() async {
    final form = _form;
    if (form == null || form.isBusy) return null;
    _set((f) => f.copyWith(isSaving: true, failure: null));
    final result = await ref
        .read(quoteRepositoryProvider)
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

  /// Saves the quote (if needed) then creates a draft invoice from it.
  Future<String?> convertToInvoice() async {
    final form = _form;
    if (form == null || form.isBusy) return null;
    if (form.draft.convertedInvoiceId != null) {
      return form.draft.convertedInvoiceId;
    }
    _set((f) => f.copyWith(isConverting: true, failure: null));
    final saved = await save();
    if (saved == null) {
      _set((f) => f.copyWith(isConverting: false));
      return null;
    }
    final invRepo = ref.read(invoiceRepositoryProvider);
    final suggested = await invRepo.suggestNumber();
    if (suggested case Err(:final failure)) {
      _set((f) => f.copyWith(isConverting: false, failure: failure));
      return null;
    }
    final number = (suggested as Ok<String>).value;
    final now = DateTime.now().toUtc();
    final invoice = QuoteToInvoice.forConversion(
      quote: saved,
      invoiceId: IdGenerator.next(),
      invoiceNumber: number,
      now: now,
    );
    final created = await invRepo.save(invoice);
    switch (created) {
      case Ok(:final value):
        final linked = saved.copyWith(
          convertedInvoiceId: value.id,
          status: QuoteStatus.approved,
          updatedAt: now,
        );
        await ref.read(quoteRepositoryProvider).save(linked);
        _set(
          (f) =>
              f.copyWith(draft: linked, initial: linked, isConverting: false),
        );
        return value.id;
      case Err(:final failure):
        _set((f) => f.copyWith(isConverting: false, failure: failure));
        return null;
    }
  }
}
