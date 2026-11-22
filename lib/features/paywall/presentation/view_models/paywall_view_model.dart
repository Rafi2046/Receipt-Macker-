import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/services/purchases/pro_plan.dart';
import '../../../../core/services/purchases/purchase_providers.dart';
import '../../../../core/services/telemetry/analytics_service.dart';
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

  void select(String productId) =>
      state = state.copyWith(selectedId: productId);

  List<ProPlan> _yearlyFirst(List<ProPlan> plans) => [
    ...plans.where((p) => p.period == ProPeriod.yearly),
    ...plans.where((p) => p.period != ProPeriod.yearly),
  ];

  /// Yearly when offered (the better price), else the first plan.
  String? _defaultPlan(List<ProPlan> plans) {
    for (final plan in plans) {
      if (plan.period == ProPeriod.yearly) return plan.id;
    }
    return plans.isEmpty ? null : plans.first.id;
  }

  Future<void> load() async {
    state = state.copyWith(loading: true, clearNotice: true);
    final result = await ref.read(purchaseRepositoryProvider).loadPlans();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => state.copyWith(
        loading: false,
        plans: _yearlyFirst(value),
        selectedId: _defaultPlan(value),
      ),
      Err() => state.copyWith(loading: false, plans: const []),
    };
  }

  /// True when Pro was unlocked.
  Future<bool> buy(String productId) async {
    state = state.copyWith(busy: true, clearNotice: true);
    final result = await ref.read(purchaseRepositoryProvider).buy(productId);
    if (!ref.mounted) return false;
    final success = await _finish(result);
    if (success && ref.mounted) {
      unawaited(
        ref
            .read(analyticsServiceProvider)
            .logProPurchased(productId: productId),
      );
    }
    return success;
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
