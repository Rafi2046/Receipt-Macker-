import 'package:flutter/material.dart';

import '../../constants/app_bar_variant.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import 'app_top_bar.dart';

/// Screen frame: title bar, safe area, centered content capped at
/// [AppSizes.maxContentWidth] for tablets, optional FAB and bottom bar
/// (the ad banner slot on list screens).
///
/// Form screens set [bottomBarAboveKeyboard] so their Save / Continue
/// button stays reachable while typing.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.title,
    this.subtitle,
    this.variant,
    this.actions,
    this.floatingActionButton,
    this.bottomBar,
    this.padded = false,
    this.bottomBarAboveKeyboard = false,
    this.showTitle = true,
    this.searchHint,
    this.searchQuery,
    this.onSearch,
    super.key,
  });

  final Widget body;
  final String? title;
  final String? subtitle;

  /// When null, inferred: `canPop` → [AppBarVariant.pushed], else [AppBarVariant.root].
  final AppBarVariant? variant;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomBar;
  final bool padded;
  final bool bottomBarAboveKeyboard;

  /// When false with a [title], the top bar still shows (back / actions) but
  /// hides the visible title.
  final bool showTitle;

  final String? searchHint;
  final String? searchQuery;
  final ValueChanged<String>? onSearch;

  AppBarVariant _resolveVariant(bool canPop) {
    final explicit = variant;
    if (explicit != null) return explicit;
    return canPop ? AppBarVariant.pushed : AppBarVariant.root;
  }

  @override
  Widget build(BuildContext context) {
    final heading = title;
    final bar = bottomBar;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    final resolved = _resolveVariant(canPop);
    final showBar = heading != null;
    return Scaffold(
      body: Column(
        children: [
          if (showBar)
            AppTopBar(
              title: heading,
              subtitle: subtitle,
              variant: resolved,
              actions: actions,
              showTitle: showTitle,
              searchHint: searchHint,
              searchQuery: searchQuery,
              onSearch: onSearch,
            ),
          Expanded(
            child: SafeArea(
              top: !showBar,
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
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bar != null && bottomBarAboveKeyboard
          ? Padding(
              padding: EdgeInsets.only(bottom: keyboard),
              child: bar,
            )
          : bar,
    );
  }
}
