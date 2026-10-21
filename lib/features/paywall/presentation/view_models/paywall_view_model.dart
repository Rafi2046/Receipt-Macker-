import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/services/purchases/purchase_providers.dart';
import '../paywall_state.dart';

final paywallViewModelProvider =
    NotifierProvider<PaywallViewModel, PaywallState>(PaywallViewModel.new);

class PaywallViewModel extends Notifier<PaywallState> {
  @override
  PaywallState build() {
    Future.microtask(load);
    return const PaywallState();
  }

  void clearNotice() => state = state.copyWith(clearNotice: true);

  Future<void> load() async {
    state = state.copyWith(loading: true, clearNotice: true);
    final result = await ref.read(purchaseRepositoryProvider).loadPlans();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => state.copyWith(loading: false, plans: value),
      Err() => state.copyWith(loading: false, plans: const []),
    };
  }

  /// True when Pro was unlocked.
  Future<bool> buy(String productId) async {
    state = state.copyWith(busy: true, clearNotice: true);
    final result = await ref.read(purchaseRepositoryProvider).buy(productId);
    if (!ref.mounted) return false;
    return _finish(result);
  }

  Future<void> restore() async {
    state = state.copyWith(busy: true, clearNotice: true);
    final result = await ref.read(purchaseRepositoryProvider).restore();
    if (!ref.mounted) return;
    switch (result) {
      case Ok(value: true):
        await ref.read(proStatusProvider.notifier).setUnlocked(value: true);
        if (!ref.mounted) return;
        state = state.copyWith(busy: false, notice: PaywallNotice.restored);
      case Ok(value: false):
        state = state.copyWith(busy: false, notice: PaywallNotice.none);
      default:
        state = state.copyWith(busy: false, notice: PaywallNotice.failed);
    }
  }

  Future<bool> _finish(Result<bool> result) async {
    switch (result) {
      case Ok(value: true):
        await ref.read(proStatusProvider.notifier).setUnlocked(value: true);
        if (ref.mounted) state = state.copyWith(busy: false);
        return true;
      case Ok():
      case Err():
        state = state.copyWith(busy: false, notice: PaywallNotice.failed);
        return false;
    }
  }
}
