import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

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
    // QuickBill is Android-first; skip on non-Android platforms where google-services.json is absent.
    if (kIsWeb || !Platform.isAndroid) return false;

    try {
      await Firebase.initializeApp();
      _initialized = true;
      return true;
    } on Object catch (e) {
      AppLogger.debug('Firebase initialization skipped: $e');
      _initialized = false;
      return false;
    }
  }

  /// Visible for testing to reset or set state.
  static void setInitializedForTesting(bool value) {
    _initialized = value;
  }
}
