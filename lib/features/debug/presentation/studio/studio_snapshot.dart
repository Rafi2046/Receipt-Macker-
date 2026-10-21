/// One month of the home hero. Money is minor units.
class StudioSnapshot {
  const StudioSnapshot({
    required this.month,
    required this.invoicedMinor,
    required this.receivedMinor,
    required this.outstandingMinor,
    required this.changePercent,
  });

  final DateTime month;
  final int invoicedMinor;
  final int receivedMinor;
  final int outstandingMinor;

  /// Whole percent versus the previous month, already signed.
  final int changePercent;
}
