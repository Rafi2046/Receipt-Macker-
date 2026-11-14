import 'package:firebase_core/firebase_core.dart';

import '../../utils/app_logger.dart';
import '../ads/running_under_test.dart';

/// Initializes Firebase safely. Catches missing configuration or platform errors
/// without crashing app startup or tests.
abstract final class FirebaseInitializer {
  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  static Future<bool> initialize() async {
    if (runningUnderTest) return false;
    if (_initialized) return true;
    try {
      await Firebase.initializeApp();
      _initialized = true;
      return true;
    } on Object catch (e, s) {
      AppLogger.error('Firebase initialization skipped or failed: $e', e, s);
      _initialized = false;
      return false;
    }
  }

  /// Visible for testing to reset or set state.
  static void setInitializedForTesting(bool value) {
    _initialized = value;
  }
}
