import 'package:receipt_maker/core/services/purchases/purchase_providers.dart';

/// A fixed Pro flag for widget tests.
class FakeProStatus extends ProStatus {
  FakeProStatus(this._isPro);

  final bool _isPro;

  @override
  bool build() => _isPro;
}
