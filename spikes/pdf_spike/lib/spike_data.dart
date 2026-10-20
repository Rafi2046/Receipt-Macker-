/// Shared test content so every candidate renders exactly the same thing.
abstract final class SpikeData {
  static const title = 'INVOICE · চালান';
  static const conjuncts = 'ক্ষ   ন্দ্র   স্ত্র   ঙ্ক   জ্ঞ';
  static const conjunctWords = 'পরীক্ষা · চন্দ্র · বস্ত্র · অঙ্ক · জ্ঞান · কর্মী · ব্যবসা · উৎসব · রাষ্ট্র';
  static const vowelSigns = 'কি কী কু কূ কৃ কে কৈ কো কৌ  কং কঃ কঁ';
  static const digits = 'বাংলা অঙ্ক: ০১২৩৪৫৬৭৮৯   Latin: 0123456789';
  static const taka = 'মোট: ৳ ১,২৩,৪৫৬.৭৮   Total: ৳ 1,23,456.78';
  static const mixed = 'Bill to: রহিম উদ্দিন (Rahim Uddin), বাড়ি ১২, রোড ৫, মিরপুর-১০, ঢাকা ১২১৬';
  static const paragraph =
      'Thank you for your business. Payment is due within fifteen days of the invoice date. '
      'Please include the invoice number in the reference of your bank transfer or mobile banking payment so that we can '
      'match it quickly. Late payments may be subject to a fee as described in our terms. If you have any questions about '
      'this invoice, the items listed, or the amounts charged, contact us by phone or email and we will be happy to help. '
      'Goods once sold are returnable within seven days in their original packaging with this invoice. '
      'This paragraph is intentionally long so that line wrapping, justification and spacing can be compared between the '
      'candidate libraries on both the phone and a desktop viewer.';

  static const headers = ['#', 'Item / পণ্য', 'Qty', 'Unit price', 'Amount'];

  static const _items = [
    'Web design (ওয়েবসাইট ডিজাইন)',
    'চাল (মিনিকেট) ২৫ কেজি',
    'Graphic design — logo পরিবর্তন',
    'সরিষার তেল ৫ লিটার',
    'Laptop repair: কীবোর্ড প্রতিস্থাপন',
    'শিক্ষার্থীর মাসিক টিউশন ফি',
    'Delivery charge (ঢাকার বাইরে)',
  ];

  static const rowCount = 36;

  static List<List<String>> rows() => [
    for (var i = 0; i < rowCount; i++) _row(i),
  ];

  static List<String> _row(int i) {
    final qty = i % 5 + 1;
    final unit = 25000 + i * 13750; // poisha
    return [
      bn('${i + 1}'),
      _items[i % _items.length],
      bn('$qty'),
      '৳ ${money(unit)}',
      '৳ ${money(unit * qty)}',
    ];
  }

  /// Indian grouping with Bangla digits; spike-only, the app uses AppFormatters.
  static String money(int minor) {
    final whole = (minor ~/ 100).toString();
    final frac = (minor % 100).toString().padLeft(2, '0');
    final last3 = whole.length > 3 ? whole.substring(whole.length - 3) : whole;
    var rest = whole.length > 3 ? whole.substring(0, whole.length - 3) : '';
    final parts = <String>[];
    while (rest.length > 2) {
      parts.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) parts.insert(0, rest);
    return bn([...parts, last3].join(',') + '.$frac');
  }

  static String bn(String s) => s.replaceAllMapped(RegExp('[0-9]'), (m) => '০১২৩৪৫৬৭৮৯'[int.parse(m[0]!)]);
}
