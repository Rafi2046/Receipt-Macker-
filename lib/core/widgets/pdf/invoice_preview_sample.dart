/// Fixed demo content for catalog thumbnails (same on every card so layout
/// and color are what the user compares).
abstract final class InvoicePreviewSample {
  static const String seller = 'Green Leaf Studio';
  static const String sellerDetail = 'Dhaka';
  static const String buyer = 'Amy Clark';
  static const String buyerDetail = 'Sunrise LLC';
  static const String buyerText = '$buyer\n$buyerDetail';
  static const String number = 'INV-0005';
  static const String issueDate = '16/11/26';
  static const String dueDate = '30/11/26';

  static const List<({String name, String qty, String price, String amount})>
  lines = [
    (name: 'Website redesign', qty: '1', price: '8,000', amount: '8,000'),
    (name: 'Hosting (1 year)', qty: '1', price: '2,400', amount: '2,400'),
    (name: 'Support retainer', qty: '2', price: '1,500', amount: '3,000'),
  ];

  static const String subtotal = '13,400';
  static const String tax = '670';
  static const String total = '14,070';
}
