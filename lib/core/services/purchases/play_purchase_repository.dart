import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../../constants/app_constants.dart';
import '../../errors/result.dart';
import 'billing_offer.dart';
import 'pro_plan.dart';
import 'purchase_repository.dart';

/// Google Play Billing. One purchase-stream listener for the app lifetime.
class PlayPurchaseRepository implements PurchaseRepository {
  PlayPurchaseRepository(this._billing) {
    _subscription = _billing.purchaseStream.listen(
      _onPurchases,
      onError: (Object _) {},
    );
  }

  final InAppPurchase _billing;
  late final StreamSubscription<List<PurchaseDetails>> _subscription;
  final List<void Function(List<PurchaseDetails>)> _listeners = [];

  static const Duration _buyTimeout = Duration(minutes: 2);
  static const Duration _restoreTimeout = Duration(seconds: 8);

  void dispose() => _subscription.cancel();

  @override
  Future<Result<List<ProPlan>>> loadPlans() => Result.guard(() async {
    if (!await _billing.isAvailable()) return const [];
    final response = await _billing.queryProductDetails(_ids);
    return _plans(response.productDetails);
  });

  @override
  Future<Result<bool>> buy(String productId) => Result.guard(() async {
    if (!await _billing.isAvailable()) return false;
    final response = await _billing.queryProductDetails({productId});
    final products = response.productDetails;
    final chosen = choosePlans(_offers(products))
        .where((plan) => plan.productId == productId)
        .firstOrNull;
    if (chosen == null) return false;
    final completer = Completer<bool>();
    void take(List<PurchaseDetails> purchases) {
      for (final purchase in purchases) {
        if (purchase.productID != productId) continue;
        if (purchase.status == PurchaseStatus.pending) continue;
        final ok =
            purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored;
        if (!completer.isCompleted) completer.complete(ok);
      }
    }

    _listeners.add(take);
    try {
      final started = await _billing.buyNonConsumable(
        purchaseParam: PurchaseParam(
          productDetails: products[chosen.offerIndex],
        ),
      );
      if (!started) return false;
      return await completer.future.timeout(
        _buyTimeout,
        onTimeout: () => false,
      );
    } finally {
      _listeners.remove(take);
    }
  });

  @override
  Future<Result<bool?>> restore() => Result.guard(() async {
    if (!await _billing.isAvailable()) return null;
    final completer = Completer<bool?>();
    void take(List<PurchaseDetails> purchases) {
      final active = purchases.any(
        (purchase) =>
            _ids.contains(purchase.productID) &&
            (purchase.status == PurchaseStatus.purchased ||
                purchase.status == PurchaseStatus.restored),
      );
      if (!completer.isCompleted) completer.complete(active);
    }

    _listeners.add(take);
    try {
      await _billing.restorePurchases();
      return await completer.future.timeout(
        _restoreTimeout,
        onTimeout: () => null,
      );
    } finally {
      _listeners.remove(take);
    }
  });

  void _onPurchases(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.pendingCompletePurchase) {
        _billing.completePurchase(purchase);
      }
    }
    for (final listener in [..._listeners]) {
      listener(purchases);
    }
  }

  List<ProPlan> _plans(List<ProductDetails> products) {
    final plans = <ProPlan>[];
    for (final chosen in choosePlans(_offers(products))) {
      final period = _period(chosen.productId);
      if (period == null) continue;
      plans.add(
        ProPlan(
          id: chosen.productId,
          period: period,
          price: chosen.price,
          trialDays: chosen.trialDays,
        ),
      );
    }
    plans.sort((a, b) {
      if (a.period == b.period) return 0;
      return a.period == ProPeriod.yearly ? -1 : 1;
    });
    return plans;
  }

  List<BillingOffer> _offers(List<ProductDetails> products) => [
    for (final product in products) _offer(product),
  ];

  BillingOffer _offer(ProductDetails product) {
    final phases = _phases(product);
    if (phases.isNotEmpty) {
      return BillingOffer(productId: product.id, phases: phases);
    }
    return BillingOffer(
      productId: product.id,
      phases: [
        BillingPhase(
          priceMicros: 1,
          formattedPrice: product.price,
          period: '',
          cycles: 1,
        ),
      ],
    );
  }

  List<BillingPhase> _phases(ProductDetails product) {
    if (product is! GooglePlayProductDetails) return const [];
    final index = product.subscriptionIndex;
    final offers = product.productDetails.subscriptionOfferDetails;
    if (index == null || offers == null || index >= offers.length) {
      return const [];
    }
    return [for (final phase in offers[index].pricingPhases) _phase(phase)];
  }

  BillingPhase _phase(PricingPhaseWrapper phase) => BillingPhase(
    priceMicros: phase.priceAmountMicros,
    formattedPrice: phase.formattedPrice,
    period: phase.billingPeriod,
    cycles: phase.billingCycleCount,
  );

  ProPeriod? _period(String id) => switch (id) {
    AppConstants.proYearlyId => ProPeriod.yearly,
    AppConstants.proMonthlyId => ProPeriod.monthly,
    _ => null,
  };

  static const Set<String> _ids = {
    AppConstants.proMonthlyId,
    AppConstants.proYearlyId,
  };
}
