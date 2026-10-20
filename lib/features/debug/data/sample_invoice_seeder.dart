import '../../../core/utils/calendar_date.dart';
import '../../../core/utils/id_generator.dart';
import '../../clients/clients.dart';
import '../../invoices/domain/models/bill_to.dart';
import '../../invoices/domain/models/discount.dart';
import '../../invoices/domain/models/discount_type.dart';
import '../../invoices/domain/models/invoice.dart';
import '../../invoices/domain/models/line_item.dart';
import '../../invoices/domain/repositories/invoice_repository.dart';

/// Debug builds only: adds a long English invoice (40 lines, two pages or
/// more) and a Bangla one full of conjuncts, to check PDFs on a phone.
class SampleInvoiceSeeder {
  SampleInvoiceSeeder(this._invoices, this._clients);

  final InvoiceRepository _invoices;
  final ClientRepository _clients;

  static const int _longLineCount = 40;

  Future<void> seed(DateTime now) async {
    final today = CalendarDate.fromLocal(now);
    final buyer = Client(
      id: IdGenerator.next(),
      name:
          'Bangladesh Garments Export & Trading Company Limited (Head Office)',
      phone: '+880 1711-223344',
      email: 'accounts.payable@bd-garments-export.example.com',
      address: 'House 12, Road 7, Block C, Banani\nDhaka 1213, Bangladesh',
      createdAt: now,
      updatedAt: now,
    );
    await _clients.save(buyer);
    await _save(_long(today, now, buyer));
    await _save(_bangla(today, now));
  }

  /// Saves with the next number and fresh line ids (lines ids are unique
  /// across all invoices).
  Future<void> _save(Invoice Function(String number) build) async {
    final number = (await _invoices.suggestNumber()).valueOrNull ?? 'X';
    final invoice = build(number);
    await _invoices.save(
      invoice.copyWith(
        lines: [
          for (final l in invoice.lines) l.copyWith(id: IdGenerator.next()),
        ],
      ),
    );
  }

  Invoice Function(String) _long(CalendarDate today, DateTime now, Client c) =>
      (number) => Invoice(
        id: IdGenerator.next(),
        number: number,
        currencyCode: 'BDT',
        issueDate: today,
        dueDate: today.addDays(15),
        createdAt: now,
        updatedAt: now,
        clientId: c.id,
        billTo: BillTo(
          name: c.name,
          phone: c.phone,
          email: c.email,
          address: c.address,
        ),
        lines: [
          for (var i = 1; i <= _longLineCount; i++)
            LineItem(
              id: IdGenerator.next(),
              name: i.isEven
                  ? 'Cotton polo shirt, size ${i % 5 + 1}XL'
                  : 'Embroidery and logo printing on the front, back and both '
                        'sleeves, batch $i',
              description: i % 7 == 0 ? 'Rush order, deliver by Friday' : '',
              quantityMilli: (i % 9 + 1) * 1000 + (i.isOdd ? 500 : 0),
              unit: 'pcs',
              unitPriceMinor: 12550 * (i % 6 + 1),
              discount: i % 10 == 0
                  ? const Discount(type: DiscountType.percent, value: 500)
                  : null,
            ),
        ],
        discount: const Discount(type: DiscountType.flat, value: 100000),
        taxRateBasisPoints: 1500,
        shippingMinor: 250000,
        notes:
            'Thank you for your business. Goods once sold are not '
            'returnable without the original invoice.',
        terms: 'Payment within 15 days. Late payments are charged 2% a month.',
        paymentInstructions:
            'Bank: Dutch-Bangla Bank, A/C 123.456.7890\nbKash: 01712-345678',
      );

  Invoice Function(String) _bangla(CalendarDate today, DateTime now) =>
      (number) => Invoice(
        id: IdGenerator.next(),
        number: number,
        currencyCode: 'BDT',
        issueDate: today,
        dueDate: today.addDays(7),
        createdAt: now,
        updatedAt: now,
        billTo: const BillTo(
          name: 'মেসার্স রহমান অ্যান্ড সন্স (ক্ষুদ্র ও মাঝারি শিল্প)',
          phone: '০১৮১১-২২৩৩৪৪',
          address: 'বাড়ি ১২, সড়ক ৭, ধানমন্ডি, ঢাকা',
        ),
        lines: const [
          LineItem(
            id: 'bn1',
            name: 'লোগো ডিজাইন ও ব্র্যান্ড স্ট্র্যাটেজি',

            unit: 'প্যাকেজ',
            unitPriceMinor: 1500000,
          ),
          LineItem(
            id: 'bn2',
            name: 'ক্ষুদ্র ব্যবসার জন্য সন্দ্বীপ ও চন্দ্রঘোনা শাখার স্থাপত্য পরামর্শ',
            description: 'বিশেষজ্ঞ (জ্ঞান ও দক্ষতা): ঙ্ক, ক্ষ, ন্দ্র, স্ত্র',
            quantityMilli: 2500,
            unit: 'ঘণ্টা',
            unitPriceMinor: 120000,
            discount: Discount(type: DiscountType.percent, value: 1000),
          ),
          LineItem(id: 'bn3', name: 'ডেলিভারি সেটআপ', unitPriceMinor: 50000),
        ],
        taxRateBasisPoints: 750,
        taxInclusive: true,
        notes: 'আপনার ব্যবসার জন্য ধন্যবাদ।',
        paymentInstructions: 'বিকাশ: ০১৭১২-৩৪৫৬৭৮',
      );
}
