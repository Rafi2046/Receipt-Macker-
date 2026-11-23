import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/widgets/feedback/confirm_dialog.dart';
import 'package:receipt_maker/l10n/gen/app_localizations.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('exit confirm dialog shows localized copy', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpApp(
      Builder(
        builder: (context) {
          l10n = AppLocalizations.of(context);
          return TextButton(
            onPressed: () => ConfirmDialog.show(
              context,
              title: l10n.exitAppTitle,
              message: l10n.exitAppMessage,
              confirmLabel: l10n.exitAppConfirm,
              destructive: true,
            ),
            child: const Text('Ask'),
          );
        },
      ),
    );
    await tester.tap(find.text('Ask'));
    await tester.pumpAndSettle();
    expect(find.text('Exit QuickBill?'), findsOneWidget);
    expect(
      find.text('Are you sure you want to close the app?'),
      findsOneWidget,
    );
    expect(find.text('Exit'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('exit confirm dialog shows Bangla copy', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpApp(
      Builder(
        builder: (context) {
          l10n = AppLocalizations.of(context);
          return TextButton(
            onPressed: () => ConfirmDialog.show(
              context,
              title: l10n.exitAppTitle,
              message: l10n.exitAppMessage,
              confirmLabel: l10n.exitAppConfirm,
              destructive: true,
            ),
            child: const Text('Ask'),
          );
        },
      ),
      language: 'bn',
    );
    await tester.tap(find.text('Ask'));
    await tester.pumpAndSettle();
    expect(find.text('QuickBill থেকে বের হবেন?'), findsOneWidget);
    expect(find.text('বের হোন'), findsOneWidget);
  });
}
