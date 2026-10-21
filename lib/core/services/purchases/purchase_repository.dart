import '../../errors/result.dart';
import 'pro_plan.dart';

/// Store prices and purchases. Tests use a fake; the phone uses Play.
abstract interface class PurchaseRepository {
  Future<Result<List<ProPlan>>> loadPlans();

  /// True when the purchase completed and Pro should unlock.
  Future<Result<bool>> buy(String productId);

  /// True when Pro is active, false when the store has no purchase,
  /// null when the store could not be reached (keep the cache).
  Future<Result<bool?>> restore();
}
