import '../../../core/services/purchases/pro_plan.dart';

/// What the paywall is doing, and a one-shot message for the snackbar.
class PaywallState {
  const PaywallState({
    this.plans = const [],
    this.loading = true,
    this.busy = false,
    this.notice,
    this.selectedId,
  });

  final List<ProPlan> plans;
  final bool loading;
  final bool busy;
  final PaywallNotice? notice;

  /// The plan the Continue button buys; the yearly one by default.
  final String? selectedId;

  ProPlan? get selected {
    for (final plan in plans) {
      if (plan.id == selectedId) return plan;
    }
    return plans.isEmpty ? null : plans.first;
  }

  PaywallState copyWith({
    List<ProPlan>? plans,
    bool? loading,
    bool? busy,
    PaywallNotice? notice,
    String? selectedId,
    bool clearNotice = false,
  }) => PaywallState(
    plans: plans ?? this.plans,
    loading: loading ?? this.loading,
    busy: busy ?? this.busy,
    notice: clearNotice ? null : notice ?? this.notice,
    selectedId: selectedId ?? this.selectedId,
  );
}

enum PaywallNotice { restored, none, failed }
