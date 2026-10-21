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
  static const String defaultReceiptPrefix = 'RCPT-';
  static const int receiptNumberPadding = 4;
  static const int defaultDueDays = 7;
  static const List<int> dueDayPresets = [0, 7, 15, 30];

  static const int minPickerYear = 2000;
  static const int maxPickerYear = 2100;

  // Interstitial caps (section 9.2).
  static const bool interstitialSkipFirstDay = true;
  static const int interstitialEveryNExports = 5;
  static const Duration interstitialMinInterval = Duration(minutes: 3);

  /// Free clients and free catalog items, each. Working default until the
  /// owner picks N. Pro is unlimited.
  static const int freeRecordLimit = 20;

  /// Free PDFs include a "Made with QuickBill" line. Pro removes it.
  /// Working default until the owner says otherwise.
  static const bool freeShowsPdfFooter = true;

  /// Play Console subscription ids. Final once created there.
  static const String proMonthlyId = 'quickbill_pro_monthly';
  static const String proYearlyId = 'quickbill_pro_yearly';

  /// Google's sample AdMob app id. Release builds replace it with
  /// `-PADMOB_APP_ID=ca-app-pub-…` and pass `ADMOB_BANNER_ID` and
  /// `ADMOB_INTERSTITIAL_ID` as `--dart-define`. Debug always uses test ads.
  static const String admobTestAppId = 'ca-app-pub-3940256099942544~3347511713';
}
