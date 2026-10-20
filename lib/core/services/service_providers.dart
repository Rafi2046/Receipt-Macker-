import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'image_picker_service.dart';
import 'image_storage_service.dart';
import 'preferences/app_preferences.dart';

part 'service_providers.g.dart';

/// Overridden in bootstrap with the loaded preferences (and with a fake in tests).
@Riverpod(keepAlive: true)
AppPreferences appPreferences(Ref ref) =>
    throw UnimplementedError('appPreferencesProvider must be overridden');

@Riverpod(keepAlive: true)
ImageStorageService imageStorageService(Ref ref) =>
    ImageStorageService(getApplicationDocumentsDirectory);

@Riverpod(keepAlive: true)
ImagePickerService imagePickerService(Ref ref) => ImagePickerService();
