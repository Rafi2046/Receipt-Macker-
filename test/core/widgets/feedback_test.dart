import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/constants/app_icons.dart';
import 'package:receipt_maker/core/errors/failure.dart';
import 'package:receipt_maker/core/widgets/feedback/app_snackbar.dart';
import 'package:receipt_maker/core/widgets/feedback/confirm_dialog.dart';
import 'package:receipt_maker/core/widgets/feedback/empty_state.dart';
import 'package:receipt_maker/core/widgets/feedback/error_view.dart';
import 'package:receipt_maker/core/widgets/feedback/loading_view.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('EmptyState shows its first action', (tester) async {
    var taps = 0;
    await tester.pumpApp(
      EmptyState(
        icon: AppIcons.invoice,
        title: 'No invoices yet',
        message: 'Create one',
        actionLabel: 'Create your first invoice',
        onAction: () => taps++,
      ),
    );
    await tester.tap(find.text('Create your first invoice'));
    expect(taps, 1);
  });

  testWidgets('ErrorView maps failures to localized messages and retries', (
    tester,
  ) async {
    var retries = 0;
    await tester.pumpApp(
      ErrorView.fromError(const DatabaseFailure(), onRetry: () => retries++),
    );
    expect(
      find.text("Couldn't read or save your data. Try again."),
      findsOneWidget,
    );
    await tester.tap(find.text('Retry'));
    expect(retries, 1);
  });

  testWidgets('ErrorView in Bangla, unknown error falls back to generic', (
    tester,
  ) async {
    await tester.pumpApp(ErrorView.fromError(StateError('x')), language: 'bn');
    expect(
      find.text('কিছু একটা সমস্যা হয়েছে। আবার চেষ্টা করুন।'),
      findsOneWidget,
    );
    expect(find.text('আবার চেষ্টা করুন'), findsNothing);
  });

  testWidgets('LoadingView announces loading', (tester) async {
    await tester.pumpApp(const LoadingView(), settle: false);
    expect(find.bySemanticsLabel('Loading…'), findsOneWidget);
  });

  testWidgets('ConfirmDialog resolves true on confirm and false on cancel', (
    tester,
  ) async {
    final results = <bool>[];
    await tester.pumpApp(
      Builder(
        builder: (context) => TextButton(
          onPressed: () async => results.add(
            await ConfirmDialog.show(
              context,
              title: 'Delete?',
              message: 'Gone',
              confirmLabel: 'Delete',
              destructive: true,
            ),
          ),
          child: const Text('open'),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(results, [true, false]);
  });

  testWidgets('AppSnackbar shows message and action', (tester) async {
    await tester.pumpApp(
      Builder(
        builder: (context) => TextButton(
          onPressed: () => AppSnackbar.show(
            context,
            'Invoice saved',
            tone: AppSnackbarTone.success,
            actionLabel: 'Undo',
          ),
          child: const Text('go'),
        ),
      ),
    );
    await tester.tap(find.text('go'));
    await tester.pump();
    expect(find.text('Invoice saved'), findsOneWidget);
    expect(find.text('Undo'), findsOneWidget);
    expect(find.byIcon(AppIcons.success), findsOneWidget);
  });
}
