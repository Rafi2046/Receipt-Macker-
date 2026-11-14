import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/preferences/app_preferences.dart';
import '../../../../core/services/service_providers.dart';
import '../../../invoices/providers.dart';
import '../../domain/models/app_language.dart';
import '../../domain/models/app_theme_preference.dart';
import 'app_settings_state.dart';

part 'app_settings_view_model.g.dart';

/// App-wide settings, persisted in preferences and database.
@Riverpod(keepAlive: true)
class AppSettingsViewModel extends _$AppSettingsViewModel {
  AppPreferences get _prefs => ref.read(appPreferencesProvider);

  @override
  AppSettingsState build() {
    final prefs = ref.watch(appPreferencesProvider);
    return AppSettingsState(
      theme:
          AppThemePreference.values.asNameMap()[prefs.themeName] ??
          AppThemePreference.system,
      language: AppLanguage.values.firstWhere(
        (l) => l.code == prefs.languageCode,
        orElse: () => AppLanguage.en,
      ),
      defaultCurrency:
          prefs.defaultCurrency ?? AppConstants.defaultCurrencyCode,
      defaultDueDays: prefs.defaultDueDays,
      defaultTaxRateBasisPoints: prefs.defaultTaxRateBasisPoints,
      defaultTaxInclusive: prefs.defaultTaxInclusive,
    );
  }

  Future<void> setTheme(AppThemePreference theme) async {
    state = state.copyWith(theme: theme);
    await _prefs.setThemeName(theme.name);
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = state.copyWith(language: language);
    await _prefs.setLanguageCode(language.code);
  }

  Future<void> setDefaultCurrency(String code) async {
    state = state.copyWith(defaultCurrency: code);
    await _prefs.setDefaultCurrency(code);
  }

  Future<void> setDefaultDueDays(int days) async {
    state = state.copyWith(defaultDueDays: days);
    await _prefs.setDefaultDueDays(days);
  }

  Future<void> setDefaultTaxRateBasisPoints(int? basisPoints) async {
    state = state.copyWith(defaultTaxRateBasisPoints: basisPoints);
    await _prefs.setDefaultTaxRateBasisPoints(basisPoints);
  }

  Future<void> setDefaultTaxInclusive({required bool value}) async {
    state = state.copyWith(defaultTaxInclusive: value);
    await _prefs.setDefaultTaxInclusive(value: value);
  }

  /// Loads current prefix and sequence from the database.
  Future<void> loadNumbering() async {
    final invoiceRepo = ref.read(invoiceRepositoryProvider);
    final numberingResult = await invoiceRepo.getNumbering();
    if (numberingResult case Ok(:final value)) {
      final highestResult = await invoiceRepo.getHighestSequence(value.prefix);
      final highest = highestResult.valueOrNull ?? 0;
      state = state.copyWith(
        invoicePrefix: value.prefix,
        nextInvoiceSequence: value.nextSequence,
        highestInvoiceSequence: highest,
      );
    }
  }

  /// Updates prefix and sequence with validation.
  Future<bool> updateNumbering({
    required String prefix,
    required int nextSequence,
  }) async {
    final trimmedPrefix = prefix.trim();
    if (trimmedPrefix.isEmpty) {
      state = state.copyWith(
        failure: const ValidationFailure('prefix'),
        numberingSaved: false,
      );
      return false;
    }

    final invoiceRepo = ref.read(invoiceRepositoryProvider);
    final highestResult = await invoiceRepo.getHighestSequence(trimmedPrefix);
    final highest = highestResult.valueOrNull ?? 0;

    if (nextSequence <= highest) {
      state = state.copyWith(
        highestInvoiceSequence: highest,
        failure: const ValidationFailure('nextSequence'),
        numberingSaved: false,
      );
      return false;
    }

    state = state.copyWith(isSaving: true, failure: null);
    final result = await invoiceRepo.updateNumbering(
      prefix: trimmedPrefix,
      nextSequence: nextSequence,
    );

    return switch (result) {
      Ok() => () {
        state = state.copyWith(
          invoicePrefix: trimmedPrefix,
          nextInvoiceSequence: nextSequence,
          highestInvoiceSequence: highest,
          isSaving: false,
          numberingSaved: true,
          failure: null,
        );
        return true;
      }(),
      Err(:final failure) => () {
        state = state.copyWith(
          isSaving: false,
          failure: failure,
          numberingSaved: false,
        );
        return false;
      }(),
    };
  }

  void clearFeedback() {
    state = state.copyWith(failure: null, numberingSaved: false);
  }
}
