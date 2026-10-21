import 'dart:io';

/// True while `flutter test` is running. Ads and Play are not started then.
bool get runningUnderTest => Platform.environment.containsKey('FLUTTER_TEST');
