import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:receipt_maker/core/services/purchases/play_purchase_repository.dart';

void main() {
  test('only a paid Play purchase counts; pending never unlocks Pro', () {
    expect(
      PlayPurchaseRepository.isPaid(PurchaseStateWrapper.purchased),
      isTrue,
    );
    expect(
      PlayPurchaseRepository.isPaid(PurchaseStateWrapper.pending),
      isFalse,
    );
    expect(
      PlayPurchaseRepository.isPaid(PurchaseStateWrapper.unspecified_state),
      isFalse,
    );
  });
}
