import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/service_providers.dart';
import '../../../invoices/domain/models/invoice_summary.dart';
import '../../../invoices/providers.dart';
import '../../domain/logic/client_finance_calculator.dart';
import '../../domain/models/client.dart';
import '../../providers.dart';
import 'client_detail_state.dart';

part 'client_detail_view_model.g.dart';

@riverpod
class ClientDetailViewModel extends _$ClientDetailViewModel {
  @override
  Stream<ClientDetailState> build(String clientId) {
    final controller = StreamController<ClientDetailState>();
    Client? currentClient;
    List<InvoiceSummary> currentInvoices = const [];

    void emit() {
      if (controller.isClosed) return;
      final defaultCurrency =
          ref.read(appPreferencesProvider).defaultCurrency ??
          AppConstants.defaultCurrencyCode;
      final finances = ClientFinanceCalculator.calculate(
        currentInvoices,
        defaultCurrency: defaultCurrency,
      );
      controller.add(
        ClientDetailState(
          client: currentClient,
          invoices: currentInvoices,
          finances: finances,
        ),
      );
    }

    final sub1 = ref.watch(clientRepositoryProvider).watch(clientId).listen((
      c,
    ) {
      currentClient = c;
      emit();
    }, onError: controller.addError);

    final sub2 = ref
        .watch(invoiceRepositoryProvider)
        .watchByClient(clientId)
        .listen((invs) {
          currentInvoices = invs;
          emit();
        }, onError: controller.addError);

    ref.onDispose(() {
      sub1.cancel();
      sub2.cancel();
      controller.close();
    });

    return controller.stream;
  }
}
