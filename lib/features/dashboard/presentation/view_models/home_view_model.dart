import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/clock.dart';
import '../../../../core/utils/calendar_date.dart';
import '../../../business_profile/business_profile.dart';
import '../../../invoices/providers.dart';
import '../../../settings/presentation/view_models/app_settings_view_model.dart';
import '../home_snapshot.dart';

part 'home_view_model.g.dart';

/// Outstanding, this month's totals, and the newest invoices.
@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Stream<HomeSnapshot> build() {
    final currency = ref.watch(appSettingsViewModelProvider).defaultCurrency;
    final now = ref.watch(clockProvider)();
    final name = ref.watch(currentBusinessProfileProvider).value?.name ?? '';
    return ref
        .watch(invoiceRepositoryProvider)
        .watchAll()
        .map(
          (invoices) => assembleHome(
            invoices: invoices,
            today: CalendarDate.fromLocal(now),
            currencyCode: currency,
            businessName: name,
            hour: now.hour,
          ),
        );
  }
}
