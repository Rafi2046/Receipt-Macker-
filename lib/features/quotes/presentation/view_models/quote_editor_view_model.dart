import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/service_providers.dart';
import '../../../../core/utils/calendar_date.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../business_profile/business_profile.dart';
import '../../../clients/domain/models/client.dart';
import '../../../invoices/domain/logic/invoice_calculator.dart';
import '../../../invoices/domain/logic/invoice_drafting.dart';
import '../../../invoices/domain/logic/invoice_number_generator.dart';
import '../../../invoices/domain/logic/invoice_validator.dart';
import '../../../invoices/domain/models/bill_to.dart';
import '../../../invoices/domain/models/discount.dart';
import '../../../invoices/domain/models/discount_type.dart';
import '../../../invoices/domain/models/line_item.dart';
import '../../../invoices/providers.dart';
import '../../../items/domain/models/item.dart';
import '../../../items/domain/models/item_discount_type.dart';
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
        Err() => '${AppConstants.defaultEstimatePrefix}0001',
      };
      final prefs = ref.read(appPreferencesProvider);
      final profile = (await ref.read(businessProfileRepositoryProvider).load())
          .valueOrNull;
      final blank = Quote(
        id: IdGenerator.next(),
        number: number,
        currencyCode: prefs.defaultCurrency ?? AppConstants.defaultCurrencyCode,
        issueDate: today,
        validUntil: today.addDays(prefs.defaultDueDays),
        taxRateBasisPoints: prefs.defaultTaxRateBasisPoints,
        taxInclusive: prefs.defaultTaxInclusive,
        notes: profile?.defaultNotes ?? '',
        terms: profile?.defaultTerms ?? '',
        paymentInstructions: profile?.paymentInstructions ?? '',
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

  void _edit(Quote Function(Quote draft) edit) =>
      _set((f) => f.copyWith(draft: edit(f.draft)));

  void clearFailure() => _set((f) => f.copyWith(failure: null));

  void setNumber(String value) => _edit((d) => d.copyWith(number: value));

  void setIssueDate(CalendarDate date) =>
      _edit((d) => d.copyWith(issueDate: date));

  void setValidUntil(CalendarDate date) =>
      _edit((d) => d.copyWith(validUntil: date));

  /// Switches currency keeping each amount's face value (৳500.00 becomes
  /// ¥500), the same way the invoice editor does.
  void setCurrency(String code) => _edit((d) => _withCurrency(d, code));

  static Quote _withCurrency(Quote d, String code) {
    if (code == d.currencyCode) return d;
    final rescaled = QuoteToInvoice.asInvoice(d).withCurrency(
      code,
      fromDecimals: AppFormatters.currencyDecimalDigits(d.currencyCode),
      toDecimals: AppFormatters.currencyDecimalDigits(code),
    );
    return d.copyWith(
      currencyCode: code,
      lines: rescaled.lines,
      shippingMinor: rescaled.shippingMinor,
      discount: rescaled.discount,
    );
  }

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

  /// Adds a catalog item as a line. The first item sets the currency. An
  /// item priced in another currency comes in with no price (and no flat
  /// discount), so a wrong amount is never copied silently.
  void addItem(Item item) => _set((f) {
    var draft = f.draft;
    if (draft.lines.isEmpty) draft = _withCurrency(draft, item.currencyCode);
    final foreign = item.currencyCode != draft.currencyCode;
    final line = LineItem(
      id: IdGenerator.next(),
      name: item.name,
      description: item.description,
      unit: item.unit,
      unitPriceMinor: foreign ? 0 : item.unitPriceMinor,
      quantityMilli: item.defaultQuantityMilli,
      discount: switch (item.discountType) {
        null => null,
        ItemDiscountType.percent => Discount(
          type: DiscountType.percent,
          value: item.discountValue,
        ),
        ItemDiscountType.flat =>
          foreign
              ? null
              : Discount(type: DiscountType.flat, value: item.discountValue),
      },
      itemId: item.id,
    );
    return f.copyWith(draft: draft.copyWith(lines: [...draft.lines, line]));
  });

  String addBlankLine() {
    final id = IdGenerator.next();
    _set((f) {
      final line = LineItem(id: id, name: '');
      return f.copyWith(
        draft: f.draft.copyWith(lines: [...f.draft.lines, line]),
      );
    });
    return id;
  }

  void updateLine(LineItem line) => _set((f) {
    return f.copyWith(
      draft: f.draft.copyWith(
        lines: [
          for (final l in f.draft.lines)
            if (l.id == line.id) line else l,
        ],
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

  int subtotalMinor() {
    final form = _form;
    if (form == null) return 0;
    return InvoiceCalculator.calculate(QuoteToInvoice.asInvoice(form.draft))
        .subtotal;
  }

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
    final saved = await _persist(form.draft);
    _set((f) => f.copyWith(isSaving: false));
    return saved;
  }

  /// Validates and stores [draft]; on an error it sets the failure and
  /// returns null. It does not touch the busy flags, so both [save] and
  /// [convertToInvoice] can use it.
  Future<Quote?> _persist(Quote draft) async {
    final check = InvoiceValidator.validate(QuoteToInvoice.asInvoice(draft));
    if (!check.isValid) {
      final field = check.fields.keys.firstOrNull?.name ?? 'lines';
      _set((f) => f.copyWith(failure: ValidationFailure(field)));
      return null;
    }
    final result = await ref
        .read(quoteRepositoryProvider)
        .save(draft.copyWith(updatedAt: DateTime.now().toUtc()));
    switch (result) {
      case Ok(:final value):
        _set((f) => f.copyWith(draft: value, initial: value, isNew: false));
        return value;
      case Err(:final failure):
        _set((f) => f.copyWith(failure: failure));
        return null;
    }
  }

  Future<String?> convertToInvoice() async {
    final form = _form;
    if (form == null || form.isBusy) return null;
    if (form.draft.convertedInvoiceId != null) {
      return form.draft.convertedInvoiceId;
    }
    _set((f) => f.copyWith(isConverting: true, failure: null));
    final saved = await _persist(form.draft);
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
        final link = await ref.read(quoteRepositoryProvider).save(linked);
        if (link case Err(:final failure)) {
          // The invoice exists; say so rather than let a second convert
          // make a duplicate.
          _set((f) => f.copyWith(isConverting: false, failure: failure));
          return value.id;
        }
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
