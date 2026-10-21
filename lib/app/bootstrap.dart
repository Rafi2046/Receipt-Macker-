import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../core/services/preferences/shared_app_preferences.dart';
import '../core/services/service_providers.dart';
import '../features/settings/domain/models/app_language.dart';
import 'app.dart';
import 'provider_retry.dart';

/// Startup work before the first frame. Ads and Play start after the first
/// frame. Firebase analytics is M9.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  final prefs = await SharedAppPreferences.create();
  // First run: follow the phone's language if it is Bangla.
  if (prefs.languageCode == null) {
    final device = WidgetsBinding.instance.platformDispatcher.locale;
    final isBangla = device.languageCode == AppLanguage.bn.code;
    await prefs.setLanguageCode(
      (isBangla ? AppLanguage.bn : AppLanguage.en).code,
    );
  }
  runApp(
    ProviderScope(
      overrides: [appPreferencesProvider.overrideWithValue(prefs)],
      retry: appProviderRetry,
      child: const App(),
    ),
  );
}
