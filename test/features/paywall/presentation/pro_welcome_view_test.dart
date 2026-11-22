import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/constants/app_constants.dart';
import 'package:receipt_maker/core/services/purchases/free_plan.dart';
import 'package:receipt_maker/core/services/url_launch_service.dart';
import 'package:receipt_maker/features/paywall/presentation/views/pro_welcome_view.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('lists what Pro unlocked and links to Google Play', (
    tester,
  ) async {
    String? launched;
    UrlLaunchService.urlLauncherOverride = (url) async {
      launched = url;
      return true;
    };
    addTearDown(() => UrlLaunchService.urlLauncherOverride = null);

    await tester.pumpApp(
      const ProWelcomeView(),
      surface: const Size(400, 1400),
    );
    expect(find.text('Welcome to Pro'), findsOneWidget);
    expect(
      find.text('All ${FreePlan.templateCount} templates'),
      findsOneWidget,
    );
    expect(find.text('No ads anywhere'), findsOneWidget);
    expect(find.text('Unlimited clients and items'), findsOneWidget);

    await tester.tap(find.text('Manage subscription'));
    await tester.pumpAndSettle();
    expect(launched, AppConstants.manageSubscriptionUrl);
  });

  testWidgets('fits at 2x font in Bangla', (tester) async {
    await tester.pumpApp(
      const ProWelcomeView(),
      language: 'bn',
      textScale: 2,
      surface: const Size(360, 740),
    );
    expect(tester.takeException(), isNull);
  });
}
