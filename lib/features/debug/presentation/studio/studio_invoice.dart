import 'studio_status.dart';

/// One sample invoice. Money is minor units (poisha).
class StudioInvoice {
  const StudioInvoice({
    required this.client,
    required this.number,
    required this.phone,
    required this.totalMinor,
    required this.paidMinor,
    required this.dueInDays,
    required this.status,
    required this.inOctober,
  });

  final String client;
  final String number;
  final String phone;
  final int totalMinor;
  final int paidMinor;
  final int dueInDays;
  final StudioStatus status;
  final bool inOctober;

  int get balanceMinor => totalMinor - paidMinor;
}
