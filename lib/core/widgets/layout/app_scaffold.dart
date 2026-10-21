import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import 'app_top_bar.dart';

/// Screen frame: app bar, safe area, centered content capped at
/// [AppSizes.maxContentWidth] for tablets, optional FAB and bottom bar
/// (the ad banner slot on list screens).
///
/// Form screens set [bottomBarAboveKeyboard] so their Save / Continue
/// button stays reachable while typing.
class AppScaffold extends StatefulWidget {
  const AppScaffold({
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.bottomBar,
    this.padded = false,
    this.bottomBarAboveKeyboard = false,
    super.key,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomBar;
  final bool padded;
  final bool bottomBarAboveKeyboard;

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

  @override
  Widget build(BuildContext context) {
    final heading = widget.title;
    final bar = widget.bottomBar;
    final body = widget.body;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      body: Column(
        children: [
          if (heading != null)
            AppTopBar(
              title: heading,
              actions: widget.actions,
              scrolled: _scrolled,
            ),
          Expanded(
            child: SafeArea(
              top: heading == null,
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
