/// App-wide limits, defaults, ids and URLs.
abstract final class AppConstants {
  // TODO(owner): replace placeholders before M8 (package id drives Firebase, AdMob, Play Billing).
  static const String appName = '[APP_NAME]';
  static const String packageId = 'com.rafi.appname';
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
