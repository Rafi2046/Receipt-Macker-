import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/app/provider_retry.dart';
import 'package:receipt_maker/core/database/app_database.dart';
import 'package:receipt_maker/core/database/app_database_provider.dart';
import 'package:receipt_maker/core/services/image_picker_service.dart';
import 'package:receipt_maker/core/services/image_storage_service.dart';
import 'package:receipt_maker/core/services/service_providers.dart';

import 'fake_app_preferences.dart';

class MockImagePickerService extends Mock implements ImagePickerService {}

/// A small valid PNG (1x1, transparent) for image tests.
final Uint8List tinyPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==',
);

/// Real database (in memory), real image files (temp dir), fake prefs and a
/// mocked photo picker. Call [dispose] in tearDown.
class TestEnv {
  TestEnv({FakeAppPreferences? prefs})
    : prefs = prefs ?? FakeAppPreferences(),
      db = AppDatabase(NativeDatabase.memory()),
      imagesRoot = Directory.systemTemp.createTempSync('receipt_maker_test'),
      picker = MockImagePickerService() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  }

  final FakeAppPreferences prefs;
  final AppDatabase db;
  final Directory imagesRoot;
  final MockImagePickerService picker;

  List<Override> get overrides => [
    appPreferencesProvider.overrideWithValue(prefs),
    appDatabaseProvider.overrideWithValue(db),
    imageStorageServiceProvider.overrideWithValue(
      ImageStorageService(() async => imagesRoot),
    ),
    imagePickerServiceProvider.overrideWithValue(picker),
  ];

  ProviderContainer container() =>
      ProviderContainer(overrides: overrides, retry: appProviderRetry);

  /// Relative paths of every stored image file.
  List<String> storedImages() {
    final dir = Directory('${imagesRoot.path}/${ImageStorageService.folder}');
    if (!dir.existsSync()) return [];
    return dir
        .listSync()
        .map((f) => '${ImageStorageService.folder}/${f.uri.pathSegments.last}')
        .toList()
      ..sort();
  }

  Future<void> dispose() async {
    await db.close();
    if (imagesRoot.existsSync()) imagesRoot.deleteSync(recursive: true);
  }
}
