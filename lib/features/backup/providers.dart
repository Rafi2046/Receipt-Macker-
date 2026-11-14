import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database_provider.dart';
import '../../core/services/service_providers.dart';
import 'data/repositories/backup_repository_impl.dart';
import 'domain/repositories/backup_repository.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
BackupRepository backupRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final prefs = ref.watch(appPreferencesProvider);
  final shareService = ref.watch(shareServiceProvider);
  return BackupRepositoryImpl(db: db, prefs: prefs, shareService: shareService);
}
