/// App-wide limits, defaults, ids and URLs.
abstract final class AppConstants {
  static const String appName = 'QuickBill';

  /// Google Play listing title.
  static const String storeTitle = 'QuickBill: Invoice & Receipt';
  static const String packageId = 'com.rafi.quickbill';
  static const String publisher = 'IRR Dev Labs';
  static const String supportEmail = 'irrdevlabs.support@gmail.com';

  /// Where Google Play lists this app's subscription (manage or cancel).
  static const String manageSubscriptionUrl =
      'https://play.google.com/store/account/subscriptions?package=$packageId';

  /// Date shown as "last updated" on the privacy policy and terms.
  static final DateTime legalUpdatedOn = DateTime(2026, 11, 22);

  static const String databaseFileName = 'app.sqlite';

  static const String defaultCurrencyCode = 'BDT';
  static const String defaultInvoicePrefix = 'INV-';
  static const int invoiceNumberPadding = 4;
  static const String defaultReceiptPrefix = 'RCPT-';

  /// Estimate (quote) numbers. Existing users keep their saved prefix.
  static const String defaultEstimatePrefix = 'EST-';
  static const int receiptNumberPadding = 4;
  static const int defaultDueDays = 7;
  static const List<int> dueDayPresets = [0, 7, 15, 30];

  static const int minPickerYear = 2000;
  static const int maxPickerYear = 2100;

  // Interstitial caps (section 9.2).
  static const bool interstitialSkipFirstDay = true;
  static const int interstitialEveryNExports = 5;
  static const Duration interstitialMinInterval = Duration(minutes: 3);

  /// Free-tier limits: 10 clients, 20 catalog items. Pro is unlimited.
  static const int freeClientLimit = 10;
  static const int freeItemLimit = 20;

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

  static const String _privacyUrl = String.fromEnvironment(
    'PRIVACY_POLICY_URL',
  );
  static const String _termsUrl = String.fromEnvironment(
    'TERMS_OF_SERVICE_URL',
  );

  static const String defaultPrivacyUrl =
      'https://ishmakrafi.vercel.app/quickbill/privacy';
  static const String defaultTermsUrl =
      'https://ishmakrafi.vercel.app/quickbill/terms';

  static String get privacyPolicyUrl =>
      _privacyUrl.isNotEmpty ? _privacyUrl : defaultPrivacyUrl;

  static String get termsOfServiceUrl =>
      _termsUrl.isNotEmpty ? _termsUrl : defaultTermsUrl;
}
