import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/widgets/feedback/empty_illustration.dart';

/// Runs around every test file. The empty-state character loops forever,
/// which would keep `pumpAndSettle` from ever settling, so tests hold it
/// still.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUp(() => EmptyIllustration.loops = false);
  await testMain();
}
