import 'package:flutter/material.dart';

import '../../constants/app_bar_variant.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import 'app_top_bar.dart';

/// Screen frame: floating pill app bar, safe area, centered content capped at
/// [AppSizes.maxContentWidth] for tablets, optional FAB and bottom bar
/// (the ad banner slot on list screens).
///
/// Form screens set [bottomBarAboveKeyboard] so their Save / Continue
/// button stays reachable while typing.
class AppScaffold extends StatefulWidget {
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

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  /// True once the page's main list has scrolled under the top bar.
  bool _scrolled = false;

  bool _onScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (notification.depth != 0 || metrics.axis != Axis.vertical) {
      return false;
    }
    final scrolled = metrics.extentBefore > 0;
    if (scrolled != _scrolled) setState(() => _scrolled = scrolled);
    return false;
  }

  AppBarVariant _resolveVariant(bool canPop) {
    final explicit = widget.variant;
    if (explicit != null) return explicit;
    return canPop ? AppBarVariant.pushed : AppBarVariant.root;
  }

  @override
  Widget build(BuildContext context) {
    final heading = widget.title;
    final bar = widget.bottomBar;
    final body = widget.body;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    final variant = _resolveVariant(canPop);
    final showBar = heading != null;
    return Scaffold(
      body: Column(
        children: [
          if (showBar)
            AppTopBar(
              title: heading,
              subtitle: widget.subtitle,
              variant: variant,
              actions: widget.actions,
              scrolled: _scrolled,
              showTitle: widget.showTitle,
              searchHint: widget.searchHint,
              searchQuery: widget.searchQuery,
              onSearch: widget.onSearch,
            ),
          Expanded(
            child: SafeArea(
              top: !showBar,
              child: NotificationListener<ScrollNotification>(
                onNotification: _onScroll,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppSizes.maxContentWidth,
                    ),
                    child: widget.padded
                        ? Padding(
                            padding: const EdgeInsets.all(
                              AppSpacing.pagePadding,
                            ),
                            child: body,
                          )
                        : body,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: bar != null && widget.bottomBarAboveKeyboard
          ? Padding(
              padding: EdgeInsets.only(bottom: keyboard),
              child: bar,
            )
          : bar,
    );
  }
}
