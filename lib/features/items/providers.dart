import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database_provider.dart';
import 'data/repositories/item_repository_impl.dart';
import 'domain/repositories/item_repository.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
ItemRepository itemRepository(Ref ref) =>
    ItemRepositoryImpl(ref.watch(appDatabaseProvider).itemDao);
