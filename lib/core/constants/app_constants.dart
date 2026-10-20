/// App-wide limits, defaults, ids and URLs.
abstract final class AppConstants {
  static const String appName = 'QuickBill';

  /// Google Play listing title.
  static const String storeTitle = 'QuickBill: Invoice & Receipt';
  static const String packageId = 'com.rafi.quickbill';
  static const String publisher = 'IRR Dev Labs';
  static const String supportEmail = 'irrdevlabs.support@gmail.com';

  static const String databaseFileName = 'app.sqlite';

  static const String defaultCurrencyCode = 'BDT';
  static const String defaultInvoicePrefix = 'INV-';
  static const int invoiceNumberPadding = 4;
  static const int defaultDueDays = 7;
  static const List<int> dueDayPresets = [0, 7, 15, 30];

  static const int minPickerYear = 2000;
  static const int maxPickerYear = 2100;

  // Interstitial caps (section 9.2).
  static const bool interstitialSkipFirstDay = true;
  static const int interstitialEveryNExports = 5;
  static const Duration interstitialMinInterval = Duration(minutes: 3);
}
