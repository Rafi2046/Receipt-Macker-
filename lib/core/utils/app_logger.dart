import 'dart:developer' as developer;

/// Debug-only logger. Silent in release builds. Never log personal or invoice data.
abstract final class AppLogger {
  static const bool _enabled = !bool.fromEnvironment('dart.vm.product');
  static const String _name = 'app';
  static const int _errorLevel = 1000;

  static void debug(String message) {
    if (!_enabled) return;
    developer.log(message, name: _name);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (!_enabled) return;
    developer.log(
      message,
      name: _name,
      level: _errorLevel,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
