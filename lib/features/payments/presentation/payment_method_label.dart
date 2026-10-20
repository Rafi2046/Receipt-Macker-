import '../../../../l10n/gen/app_localizations.dart';
import '../domain/models/payment_method.dart';

extension PaymentMethodLabel on PaymentMethod {
  String label(AppLocalizations l10n) => switch (this) {
    PaymentMethod.cash => l10n.methodCash,
    PaymentMethod.bkash => l10n.methodBkash,
    PaymentMethod.nagad => l10n.methodNagad,
    PaymentMethod.rocket => l10n.methodRocket,
    PaymentMethod.bankTransfer => l10n.methodBankTransfer,
    PaymentMethod.card => l10n.methodCard,
    PaymentMethod.other => l10n.methodOther,
  };
}
