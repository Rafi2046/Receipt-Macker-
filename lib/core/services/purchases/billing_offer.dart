/// One price phase from a store offer. Money stays in micros, never double.
class BillingPhase {
  const BillingPhase({
    required this.priceMicros,
    required this.formattedPrice,
    required this.period,
    required this.cycles,
  });

  final int priceMicros;
  final String formattedPrice;

  /// ISO 8601 period, such as `P7D` or `P1Y`. Empty when unknown.
  final String period;
  final int cycles;
}

/// One offer for a product. A subscription can have several (base plan, trial).
class BillingOffer {
  const BillingOffer({required this.productId, required this.phases});

  final String productId;
  final List<BillingPhase> phases;
}

/// The offer the paywall shows and the purchase flow buys.
class ChosenPlan {
  const ChosenPlan({
    required this.productId,
    required this.price,
    required this.trialDays,
    required this.offerIndex,
  });

  final String productId;

  /// Formatted recurring price, never the free-trial phase.
  final String price;
  final int? trialDays;
  final int offerIndex;
}

/// Days in a Play billing period. Unknown shapes return null.
int? periodToDays(String iso, int cycles) {
  final match = RegExp(r'^P(\d+)([DWMY])$').firstMatch(iso);
  final amount = match?.group(1);
  final unit = match?.group(2);
  if (amount == null || unit == null) return null;
  final count = int.parse(amount) * (cycles < 1 ? 1 : cycles);
  return switch (unit) {
    'D' => count,
    'W' => count * 7,
    'M' => count * 30,
    'Y' => count * 365,
    _ => null,
  };
}

/// One plan per product. Prefers an offer that has a free trial, and always
/// shows the paid phase as the price.
List<ChosenPlan> choosePlans(List<BillingOffer> offers) {
  final byId = <String, List<int>>{};
  for (var i = 0; i < offers.length; i++) {
    byId.putIfAbsent(offers[i].productId, () => []).add(i);
  }
  final chosen = <ChosenPlan>[];
  for (final indexes in byId.values) {
    final plan = _best(offers, indexes);
    if (plan != null) chosen.add(plan);
  }
  return chosen;
}

ChosenPlan? _best(List<BillingOffer> offers, List<int> indexes) {
  int? trialIndex;
  int? paidIndex;
  for (final index in indexes) {
    final phases = offers[index].phases;
    if (phases.isEmpty) continue;
    final hasFree = phases.any((phase) => phase.priceMicros == 0);
    final hasPaid = phases.any((phase) => phase.priceMicros > 0);
    if (hasFree && hasPaid) trialIndex ??= index;
    if (hasPaid) paidIndex ??= index;
  }
  final index = trialIndex ?? paidIndex;
  if (index == null) return null;
  final phases = offers[index].phases;
  final paid = phases.lastWhere((phase) => phase.priceMicros > 0);
  return ChosenPlan(
    productId: offers[index].productId,
    price: paid.formattedPrice,
    trialDays: _trialDays(phases),
    offerIndex: index,
  );
}

int? _trialDays(List<BillingPhase> phases) {
  var days = 0;
  var found = false;
  for (final phase in phases) {
    if (phase.priceMicros != 0) break;
    final part = periodToDays(phase.period, phase.cycles);
    if (part == null) return null;
    days += part;
    found = true;
  }
  return found ? days : null;
}
