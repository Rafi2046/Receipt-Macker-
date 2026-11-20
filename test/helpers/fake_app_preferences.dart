import 'package:receipt_maker/core/services/preferences/app_preferences.dart';

/// In-memory [AppPreferences] for tests.
class FakeAppPreferences implements AppPreferences {
  FakeAppPreferences({
    this.onboardingComplete = false,
    this.languageCode = 'en',
    this.themeName,
    this.defaultCurrency,
    this.defaultDueDays = 7,
    this.defaultTaxRateBasisPoints,
    this.defaultTaxInclusive = false,
    this.pdfTemplate,
    this.brandAccentColor,
    this.pdfPageSize,
    this.isPro = false,
    this.firstLaunchMillis,
    this.completedExports = 0,
    this.lastInterstitialMillis,
    this.lastBackupMillis,
  });

  @override
  bool onboardingComplete;

  @override
  String? languageCode;

  @override
  String? themeName;

  @override
  String? defaultCurrency;

  @override
  int defaultDueDays;

  @override
  int? defaultTaxRateBasisPoints;

  @override
  bool defaultTaxInclusive;

  @override
  Future<void> setDefaultDueDays(int days) async => defaultDueDays = days;

  @override
  Future<void> setDefaultTaxRateBasisPoints(int? basisPoints) async =>
      defaultTaxRateBasisPoints = basisPoints;

  @override
  Future<void> setDefaultTaxInclusive({required bool value}) async =>
      defaultTaxInclusive = value;

  @override
  Future<void> setOnboardingComplete({required bool value}) async =>
      onboardingComplete = value;

  @override
  Future<void> setLanguageCode(String code) async => languageCode = code;

  @override
  Future<void> setThemeName(String name) async => themeName = name;

  @override
  Future<void> setDefaultCurrency(String code) async => defaultCurrency = code;

  @override
  String? pdfTemplate;

  @override
  Future<void> setPdfTemplate(String id) async => pdfTemplate = id;

  @override
  String? pdfPageSize;

  @override
  Future<void> setPdfPageSize(String id) async => pdfPageSize = id;

  @override
  String? brandAccentColor;

  @override
  Future<void> setBrandAccentColor(String? hex) async => brandAccentColor = hex;

  @override
  bool isPro;

  @override
  int? firstLaunchMillis;

  @override
  int completedExports;

  @override
  int? lastInterstitialMillis;

  @override
  Future<void> setPro({required bool value}) async => isPro = value;

  @override
  Future<void> setFirstLaunchMillis(int millis) async =>
      firstLaunchMillis = millis;

  @override
  Future<void> setCompletedExports(int count) async => completedExports = count;

  @override
  Future<void> setLastInterstitialMillis(int millis) async =>
      lastInterstitialMillis = millis;

  @override
  int? lastBackupMillis;

  @override
  Future<void> setLastBackupMillis(int millis) async =>
      lastBackupMillis = millis;
}
