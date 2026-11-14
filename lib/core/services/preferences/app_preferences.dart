/// Small flags and choices kept outside the database (section 2: prefs for
/// small flags only). Business data never goes here.
abstract interface class AppPreferences {
  bool get onboardingComplete;
  Future<void> setOnboardingComplete({required bool value});

  /// `en` or `bn`; null until first run picks one.
  String? get languageCode;
  Future<void> setLanguageCode(String code);

  /// `system`, `light` or `dark`; null means system.
  String? get themeName;
  Future<void> setThemeName(String name);

  /// ISO 4217 code; null means the app default.
  String? get defaultCurrency;
  Future<void> setDefaultCurrency(String code);

  /// Default days until invoice due date.
  int get defaultDueDays;
  Future<void> setDefaultDueDays(int days);

  /// Default invoice tax rate in basis points (e.g. 500 = 5%); null for none.
  int? get defaultTaxRateBasisPoints;
  Future<void> setDefaultTaxRateBasisPoints(int? basisPoints);

  /// Whether tax is included in line item prices by default.
  bool get defaultTaxInclusive;
  Future<void> setDefaultTaxInclusive({required bool value});

  /// Id of the last PDF template used; null means the default.
  String? get pdfTemplate;
  Future<void> setPdfTemplate(String id);

  /// Brand accent color hex for PDF templates (e.g. '#006A4E'); null means default.
  String? get brandAccentColor;
  Future<void> setBrandAccentColor(String? hex);

  /// Cached Pro flag. Google Play is checked again on startup.
  bool get isPro;
  Future<void> setPro({required bool value});

  /// First time the app ran, for the day-one ad cap.
  int? get firstLaunchMillis;
  Future<void> setFirstLaunchMillis(int millis);

  int get completedExports;
  Future<void> setCompletedExports(int count);

  int? get lastInterstitialMillis;
  Future<void> setLastInterstitialMillis(int millis);

  /// Timestamp of the last successful backup export, or null if none.
  int? get lastBackupMillis;
  Future<void> setLastBackupMillis(int millis);
}
