import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../errors/result.dart';
import '../service_providers.dart';
import 'play_purchase_repository.dart';
import 'purchase_repository.dart';

/// Overridden in tests. The phone uses Play Billing.
final purchaseRepositoryProvider = Provider<PurchaseRepository>((ref) {
  final repository = PlayPurchaseRepository(InAppPurchase.instance);
  ref.onDispose(repository.dispose);
  return repository;
});

/// Cached Pro flag. [refreshFromStore] confirms it with Google Play.
final proStatusProvider = NotifierProvider<ProStatus, bool>(ProStatus.new);

class ProStatus extends Notifier<bool> {
  @override
  bool build() => ref.watch(appPreferencesProvider).isPro;

  Future<void> setUnlocked({required bool value}) async {
    await ref.read(appPreferencesProvider).setPro(value: value);
    state = value;
  }

  /// True unlocks, false clears, null (store down) leaves the cache.
  Future<void> refreshFromStore() async {
    final result = await ref.read(purchaseRepositoryProvider).restore();
    if (!ref.mounted) return;
    switch (result) {
      case Ok(value: true):
        await setUnlocked(value: true);
      case Ok(value: false):
        await setUnlocked(value: false);
      default:
        break;
    }
  }
}
