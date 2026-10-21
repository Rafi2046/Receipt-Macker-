import '../../../core/services/purchases/pro_plan.dart';

/// What the paywall is doing, and a one-shot message for the snackbar.
class PaywallState {
  const PaywallState({
    this.plans = const [],
    this.loading = true,
    this.busy = false,
    this.notice,
  });

  final List<ProPlan> plans;
  final bool loading;
  final bool busy;
  final PaywallNotice? notice;

  PaywallState copyWith({
    List<ProPlan>? plans,
    bool? loading,
    bool? busy,
    PaywallNotice? notice,
    bool clearNotice = false,
  }) => PaywallState(
    plans: plans ?? this.plans,
    loading: loading ?? this.loading,
    busy: busy ?? this.busy,
    notice: clearNotice ? null : notice ?? this.notice,
  );
}

enum PaywallNotice { restored, none, failed }
