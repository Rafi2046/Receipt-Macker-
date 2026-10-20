import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// Screen frame: app bar, safe area, centered content capped at
/// [AppSizes.maxContentWidth] for tablets, optional FAB and bottom bar
/// (the ad banner slot on list screens).
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.bottomBar,
    this.padded = false,
    super.key,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomBar;
  final bool padded;

  @override
  Widget build(BuildContext context) {
    final heading = title;
    return Scaffold(
      appBar: heading == null
          ? null
          : AppBar(title: Text(heading), actions: actions),
      body: SafeArea(
        top: heading == null,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: padded
                ? Padding(
                    padding: const EdgeInsets.all(AppSpacing.pagePadding),
                    child: body,
                  )
                : body,
          ),
        ),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomBar,
    );
  }
}
