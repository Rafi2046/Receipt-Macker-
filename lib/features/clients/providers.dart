import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database_provider.dart';
import 'data/repositories/client_repository_impl.dart';
import 'domain/repositories/client_repository.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
ClientRepository clientRepository(Ref ref) =>
    ClientRepositoryImpl(ref.watch(appDatabaseProvider).clientDao);
