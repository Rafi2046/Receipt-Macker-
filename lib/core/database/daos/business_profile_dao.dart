import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/business_profiles_table.dart';

part 'business_profile_dao.g.dart';

@DriftAccessor(tables: [BusinessProfilesTable])
class BusinessProfileDao extends DatabaseAccessor<AppDatabase>
    with _$BusinessProfileDaoMixin {
  BusinessProfileDao(super.attachedDatabase);

  SimpleSelectStatement<$BusinessProfilesTableTable, BusinessProfileRow>
  _first() => select(businessProfilesTable)
    ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
    ..limit(1);

  /// The primary (oldest) profile, or null before onboarding.
  Stream<BusinessProfileRow?> watchPrimary() => _first().watchSingleOrNull();

  Future<BusinessProfileRow?> getPrimary() => _first().getSingleOrNull();

  Future<void> upsert(BusinessProfileRow row) =>
      into(businessProfilesTable).insertOnConflictUpdate(row);
}
