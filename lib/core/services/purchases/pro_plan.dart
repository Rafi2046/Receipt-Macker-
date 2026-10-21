/// One subscription as the paywall shows it. [price] is the store's own
/// formatted string for the amount that is billed, not a trial phase.
class ProPlan {
  const ProPlan({
    required this.id,
    required this.period,
    required this.price,
    this.trialDays,
  });

  final String id;
  final ProPeriod period;
  final String price;
  final int? trialDays;
}

enum ProPeriod { monthly, yearly }
