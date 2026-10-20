import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/features/business_profile/business_profile.dart';
import 'package:receipt_maker/features/dashboard/presentation/widgets/business_summary_card.dart';

import '../../helpers/pump_app.dart';

void main() {
  final t = DateTime.utc(2026, 10, 20);
  final profile = BusinessProfile(
    id: 'p',
    name: 'রহমান ট্রেডার্স',
    phone: '01712345678',
    createdAt: t,
    updatedAt: t,
  );

  testWidgets('shows the phone with Bangla digits in Bangla', (tester) async {
    await tester.pumpApp(
      BusinessSummaryCard(profile: profile, actionLabel: 'edit', onTap: () {}),
      language: 'bn',
    );
    expect(find.text('০১৭১২৩৪৫৬৭৮'), findsOneWidget);
    expect(
      find.text('রট্রে'),
      findsOneWidget,
      reason: 'initials without a logo',
    );
  });

  testWidgets('keeps Latin digits in English', (tester) async {
    await tester.pumpApp(
      BusinessSummaryCard(profile: profile, actionLabel: 'edit', onTap: () {}),
    );
    expect(find.text('01712345678'), findsOneWidget);
  });
}
