import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_spacing.dart';

/// Pull down to refresh, in the app's colors: a brand spinner on a raised
/// surface disc. The spinner stays at least [minVisible] so a fast local
/// reload still reads as "done", not as a flicker.
class AppRefresh extends StatelessWidget {
  const AppRefresh({required this.onRefresh, required this.child, super.key});

  final Future<void> Function() onRefresh;

  /// Must be a scrollable that can always be pulled (see
  /// [AlwaysScrollableScrollPhysics]).
  final Widget child;

  static const Duration minVisible = Duration(milliseconds: 700);

  Future<void> _refresh() async {
    await Future.wait([onRefresh(), Future<void>.delayed(minVisible)]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return RefreshIndicator(
      onRefresh: _refresh,
      color: colors.primary,
      backgroundColor: colors.surface,
      displacement: AppSpacing.xxl,
      child: child,
    );
  }
}
