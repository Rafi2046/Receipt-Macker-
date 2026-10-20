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

  static Future<SharedAppPreferences> create() async => SharedAppPreferences._(
    await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {_onboarding, _language, _theme, _currency, _pdfTemplate},
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
}
