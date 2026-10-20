import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/app/app.dart';
import 'package:receipt_maker/app/provider_retry.dart';

import 'test_env.dart';

/// pumpAndSettle that fails after 3s instead of hanging for 10 minutes.
Future<void> settle(WidgetTester tester) => tester.pumpAndSettle(
  const Duration(milliseconds: 100),
  EnginePhase.sendSemanticsUpdate,
  const Duration(seconds: 3),
);

extension AppHarness on WidgetTester {
  /// The whole app (router, theme, l10n) on a phone-sized screen.
  Future<void> pumpFullApp(TestEnv env) async {
    view.physicalSize = const Size(400, 860) * view.devicePixelRatio;
    addTearDown(view.resetPhysicalSize);
    await pumpWidget(
      ProviderScope(
        overrides: env.overrides,
        retry: appProviderRetry,
        child: const App(),
      ),
    );
    await settle(this);
  }

  /// Lets provider disposal finish in the fake zone before closing the DB
  /// for real, or the close waits on work that never runs.
  Future<void> tearDownFullApp(TestEnv env) async {
    await pumpWidget(const SizedBox());
    await settle(this);
    await runAsync(env.dispose);
  }
}
