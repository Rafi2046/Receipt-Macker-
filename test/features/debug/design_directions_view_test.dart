import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/features/debug/presentation/directions/direction_palette.dart';
import 'package:receipt_maker/features/debug/presentation/views/design_directions_view.dart';

import '../../helpers/pump_app.dart';

void main() {
  test('the three directions use different accent colors', () {
    final ledger = DirectionPalette.of(DirectionKind.ledger, Brightness.light);
    final current = DirectionPalette.of(
      DirectionKind.current,
      Brightness.light,
    );
    final atelier = DirectionPalette.of(
      DirectionKind.atelier,
      Brightness.light,
    );
    expect(ledger.accent, isNot(current.accent));
    expect(current.accent, isNot(atelier.accent));
    expect(ledger.filledHero, isFalse);
    expect(current.filledHero, isTrue);
    expect(
      DirectionPalette.of(DirectionKind.ledger, Brightness.dark).background,
      isNot(ledger.background),
    );
  });

  testWidgets('home preview shows the overdue banner', (tester) async {
    await tester.pumpApp(const DesignDirectionsView());
    expect(find.text('Ledger'), findsOneWidget);
    expect(find.text('3 invoices overdue · ৳12,500'), findsOneWidget);
  });

  testWidgets('Bangla preview uses Bangla digits on the hero', (tester) async {
    await tester.pumpApp(const DesignDirectionsView(), language: 'bn');
    await tester.tap(find.text('কারেন্ট'));
    await tester.pumpAndSettle();
    expect(find.text('৳২৬,৫০০'), findsOneWidget);
    expect(
      find.text('৩টি ইনভয়েসের মেয়াদ পেরিয়েছে · ৳১২,৫০০'),
      findsOneWidget,
    );
  });
}
