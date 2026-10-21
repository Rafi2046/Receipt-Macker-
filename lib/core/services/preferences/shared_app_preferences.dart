import 'package:shared_preferences/shared_preferences.dart';

import 'app_preferences.dart';

/// [AppPreferences] on shared_preferences with an in-memory cache, so reads
/// are synchronous after [create].
class SharedAppPreferences implements AppPreferences {
  SharedAppPreferences._(this._prefs);

  final SharedPreferencesWithCache _prefs;

  static const String _onboarding = 'onboarding_complete';
  static const String _language = 'language_code';
  static const String _theme = 'theme_name';
  static const String _currency = 'default_currency';
  static const String _pdfTemplate = 'pdf_template';
  static const String _pro = 'is_pro';
  static const String _firstLaunch = 'first_launch_millis';
  static const String _exports = 'completed_exports';
  static const String _lastAd = 'last_interstitial_millis';

  static Future<SharedAppPreferences> create() async => SharedAppPreferences._(
    await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {
          _onboarding,
          _language,
          _theme,
          _currency,
          _pdfTemplate,
          _pro,
          _firstLaunch,
          _exports,
          _lastAd,
        },
      ),
    ),
  );

  @override
  bool get onboardingComplete => _prefs.getBool(_onboarding) ?? false;

  @override
  Future<void> setOnboardingComplete({required bool value}) =>
      _prefs.setBool(_onboarding, value);

  @override
  String? get languageCode => _prefs.getString(_language);

  @override
  Future<void> setLanguageCode(String code) =>
      _prefs.setString(_language, code);

  @override
  String? get themeName => _prefs.getString(_theme);

  @override
  Future<void> setThemeName(String name) => _prefs.setString(_theme, name);

  @override
  String? get defaultCurrency => _prefs.getString(_currency);

  @override
  Future<void> setDefaultCurrency(String code) =>
      _prefs.setString(_currency, code);

  @override
  String? get pdfTemplate => _prefs.getString(_pdfTemplate);

  @override
  Future<void> setPdfTemplate(String id) => _prefs.setString(_pdfTemplate, id);

  @override
  bool get isPro => _prefs.getBool(_pro) ?? false;

  @override
  Future<void> setPro({required bool value}) => _prefs.setBool(_pro, value);

  @override
  int? get firstLaunchMillis => _prefs.getInt(_firstLaunch);

  @override
  Future<void> setFirstLaunchMillis(int millis) =>
      _prefs.setInt(_firstLaunch, millis);

  @override
  int get completedExports => _prefs.getInt(_exports) ?? 0;

  @override
  Future<void> setCompletedExports(int count) => _prefs.setInt(_exports, count);

  @override
  int? get lastInterstitialMillis => _prefs.getInt(_lastAd);

  @override
  Future<void> setLastInterstitialMillis(int millis) =>
      _prefs.setInt(_lastAd, millis);
}
