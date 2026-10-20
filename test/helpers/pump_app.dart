import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/app/theme/app_theme.dart';
import 'package:receipt_maker/l10n/gen/app_localizations.dart';

extension PumpApp on WidgetTester {
  /// Pumps [child] inside the real theme and localizations.
  Future<void> pumpApp(
    Widget child, {
    String language = 'en',
    ThemeMode themeMode = ThemeMode.light,
    double textScale = 1,
    Size? surface,
    bool settle = true,
  }) async {
    if (surface != null) {
      view.physicalSize = surface * view.devicePixelRatio;
      addTearDown(view.resetPhysicalSize);
    }
    await pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          locale: Locale(language),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, app) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: app ?? const SizedBox.shrink(),
          ),
          home: Scaffold(body: child),
        ),
      ),
    );
    // Spinners never settle; pass settle: false when one is on screen.
    settle ? await pumpAndSettle() : await pump();
  }
}
