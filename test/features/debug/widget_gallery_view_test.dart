import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:receipt_maker/features/debug/presentation/views/widget_gallery_view.dart';

import '../../helpers/pump_app.dart';

void main() {
  setUpAll(initializeDateFormatting);

  final cases = [
    ('en', ThemeMode.light, 1.0),
    ('bn', ThemeMode.dark, 1.0),
    ('bn', ThemeMode.light, 2.0),
    ('en', ThemeMode.dark, 2.0),
  ];

  for (final (language, mode, scale) in cases) {
    testWidgets(
      'gallery renders without overflow: $language ${mode.name} ${scale}x',
      (tester) async {
        await tester.pumpApp(
          const WidgetGalleryView(),
          language: language,
          themeMode: mode,
          textScale: scale,
          surface: const Size(360, 780),
        );
        // Scroll through the whole list; any overflow throws and fails the test.
        final list = find.byType(Scrollable).first;
        for (var i = 0; i < 40; i++) {
          await tester.drag(list, const Offset(0, -300));
          await tester.pump();
        }
        expect(tester.takeException(), isNull);
      },
    );
  }
}
