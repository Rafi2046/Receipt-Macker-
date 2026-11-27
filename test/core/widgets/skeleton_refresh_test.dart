import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/widgets/feedback/app_refresh.dart';
import 'package:receipt_maker/core/widgets/feedback/form_skeleton.dart';
import 'package:receipt_maker/core/widgets/feedback/home_skeleton.dart';
import 'package:receipt_maker/core/widgets/feedback/list_skeleton.dart';
import 'package:receipt_maker/core/widgets/feedback/shimmer.dart';
import 'package:receipt_maker/core/widgets/feedback/skeleton_box.dart';
import 'package:receipt_maker/core/widgets/layout/searchable_list.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('skeletons fit a small phone at 2x font, light and dark', (
    tester,
  ) async {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      for (final page in const <Widget>[
        ListSkeleton(),
        HomeSkeleton(),
        FormSkeleton(),
      ]) {
        await tester.pumpApp(
          Scaffold(body: page),
          themeMode: mode,
          textScale: 2,
          surface: const Size(320, 568),
          settle: false,
        );
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('the shimmer sweeps when asked and stops when disposed', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(
        body: Shimmer(animate: true, child: SkeletonBox(height: 20)),
      ),
      settle: false,
    );
    expect(tester.hasRunningAnimations, isTrue);
    await tester.pumpWidget(const SizedBox());
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('pulling a list down calls onRefresh once', (tester) async {
    var refreshed = 0;
    await tester.pumpApp(
      Scaffold(
        body: SearchableList(
          searchHint: 'Search',
          query: '',
          onSearch: (_) {},
          isEmpty: false,
          empty: const SizedBox(),
          onRefresh: () async => refreshed++,
          itemCount: 3,
          itemBuilder: (_, i) => ListTile(title: Text('Row $i')),
        ),
      ),
    );
    await tester.drag(find.text('Row 0'), const Offset(0, 300));
    await tester.pumpAndSettle();
    await tester.pump(AppRefresh.minVisible);
    await tester.pumpAndSettle();
    expect(refreshed, 1);
  });
}
