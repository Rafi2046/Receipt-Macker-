import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/services/pdf/brand_swatch.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template.dart';
import 'package:receipt_maker/core/widgets/pdf/template_studio_sheet.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('TemplateStudioSheet renders all templates and swatches', (
    tester,
  ) async {
    PdfTemplate? selected;
    String? selectedColor;
    final total = PdfTemplate.values.length;
    final proCount = PdfTemplate.values.where((t) => t.requiresPro).length;

    await tester.pumpApp(
      TemplateStudioSheet(
        selectedTemplate: PdfTemplate.classic,
        selectedAccentHex: BrandSwatch.emerald.hex,
        isPro: false,
        onSelectTemplate: (t) => selected = t,
        onSelectAccentHex: (c) => selectedColor = c,
      ),
      surface: const Size(400, 900),
    );

    // Title and Brand color section
    expect(find.text('Template Studio'), findsOneWidget);
    expect(find.text('Brand Accent Color'), findsOneWidget);

    // Filter chips
    expect(find.text('All ($total)'), findsOneWidget);
    expect(find.text('Free (1)'), findsOneWidget);
    expect(find.text('Pro ($proCount)'), findsOneWidget);

    // Swatches exist
    expect(find.text('Emerald'), findsOneWidget);
    expect(find.text('Navy'), findsOneWidget);

    // Tapping a color swatch triggers onSelectAccentHex
    await tester.tap(find.text('Navy'));
    await tester.pumpAndSettle();
    expect(selectedColor, BrandSwatch.navy.hex);

    // Free template Classic is visible
    expect(find.text('Classic'), findsOneWidget);
    // Tapping Classic triggers onSelectTemplate
    await tester.tap(find.text('Classic'));
    expect(selected, PdfTemplate.classic);
  });

  testWidgets('TemplateStudioSheet filtering works for Free and Pro tabs', (
    tester,
  ) async {
    await tester.pumpApp(
      TemplateStudioSheet(
        selectedTemplate: PdfTemplate.classic,
        selectedAccentHex: BrandSwatch.emerald.hex,
        isPro: true,
        onSelectTemplate: (_) {},
        onSelectAccentHex: (_) {},
      ),
      surface: const Size(400, 900),
    );

    // Default: All tab
    expect(find.text('Classic'), findsOneWidget);
    expect(find.text('Minimal'), findsOneWidget);

    // Tap Free tab
    await tester.tap(find.text('Free (1)'));
    await tester.pumpAndSettle();

    expect(find.text('Classic'), findsOneWidget);
    expect(find.text('Minimal'), findsNothing);
    expect(find.text('Modern'), findsNothing);

    // Tap Pro tab
    final proCount = PdfTemplate.values.where((t) => t.requiresPro).length;
    await tester.tap(find.text('Pro ($proCount)'));
    await tester.pumpAndSettle();

    expect(find.text('Classic'), findsNothing);
    expect(find.text('Minimal'), findsOneWidget);
    expect(find.text('Modern'), findsOneWidget);
  });

  testWidgets(
    'TemplateStudioSheet shows Unlock Pro banner when user is not Pro',
    (tester) async {
      await tester.pumpApp(
        TemplateStudioSheet(
          selectedTemplate: PdfTemplate.classic,
          selectedAccentHex: BrandSwatch.emerald.hex,
          isPro: false,
          onSelectTemplate: (_) {},
          onSelectAccentHex: (_) {},
        ),
        surface: const Size(500, 1500),
      );

      final bannerFinder = find.text('Unlock All Premium Templates');
      expect(bannerFinder, findsOneWidget);
      expect(find.text('Upgrade to Pro'), findsOneWidget);
    },
  );

  testWidgets('TemplateStudioSheet hides Unlock Pro banner when user is Pro', (
    tester,
  ) async {
    await tester.pumpApp(
      TemplateStudioSheet(
        selectedTemplate: PdfTemplate.classic,
        selectedAccentHex: BrandSwatch.emerald.hex,
        isPro: true,
        onSelectTemplate: (_) {},
        onSelectAccentHex: (_) {},
      ),
      surface: const Size(400, 900),
    );

    expect(find.text('Unlock All 8 Premium Templates'), findsNothing);
  });
}
