import 'package:flutter/material.dart';

import '../../constants/app_bar_variant.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../inputs/app_search_field.dart';
import 'app_top_bar_title.dart';
import 'top_bar_back_link.dart';

/// Page header — title only on the scaffold background (no bar fill / line).
class AppTopBar extends StatelessWidget {
  const AppTopBar({
    required this.title,
    required this.variant,
    this.subtitle,
    this.actions,
    this.showTitle = true,
    this.searchHint,
    this.searchQuery,
    this.onSearch,
    super.key,
  });

  final String title;
  final AppBarVariant variant;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showTitle;
  final String? searchHint;
  final String? searchQuery;
  final ValueChanged<String>? onSearch;

  @override
  Widget build(BuildContext context) {
    final barActions = actions ?? const <Widget>[];
    // Transparent over the scaffold background — no fill, no bottom line.
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        child: _content(context, barActions),
      ),
    );
  }

  Widget _content(BuildContext context, List<Widget> barActions) {
    return switch (variant) {
      AppBarVariant.home => _HomeRow(
          title: title,
          subtitle: subtitle,
          actions: barActions,
          showTitle: showTitle,
        ),
      AppBarVariant.root => _RootRow(
          title: title,
          subtitle: subtitle,
          actions: barActions,
          showTitle: showTitle,
        ),
      AppBarVariant.search => _SearchRow(
          title: title,
          actions: barActions,
          showTitle: showTitle,
          searchHint: searchHint ?? '',
          searchQuery: searchQuery ?? '',
          onSearch: onSearch,
          showBack: ModalRoute.of(context)?.canPop ?? false,
        ),
      AppBarVariant.pushed || AppBarVariant.editor => _PushedRow(
          title: title,
          subtitle: subtitle,
          actions: barActions,
          showTitle: showTitle,
        ),
    };
  }
}

class _HomeRow extends StatelessWidget {
  const _HomeRow({
    required this.title,
    required this.actions,
    required this.showTitle,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.textScalerOf(context).scale(AppSizes.topBarHeight),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.xs),
              child: AppTopBarTitle(
                title: title,
                subtitle: subtitle,
                large: true,
                subtitleAbove: true,
                showTitle: showTitle,
              ),
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}

class _RootRow extends StatelessWidget {
  const _RootRow({
    required this.title,
    required this.actions,
    required this.showTitle,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.textScalerOf(context).scale(AppSizes.topBarHeight),
      child: Row(
        children: [
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: AppTopBarTitle(
              title: title,
              subtitle: subtitle,
              large: true,
              showTitle: showTitle,
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}

/// Pushed / editor: text Back · centered title · trailing actions.
class _PushedRow extends StatelessWidget {
  const _PushedRow({
    required this.title,
    required this.actions,
    required this.showTitle,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.textScalerOf(context).scale(AppSizes.topBarHeight),
      child: NavigationToolbar(
        middleSpacing: AppSpacing.sm,
        leading: const TopBarBackLink(),
        middle: AppTopBarTitle(
          title: title,
          subtitle: subtitle,
          align: TextAlign.center,
          showTitle: showTitle,
        ),
        trailing: actions.isEmpty
            ? null
            : Row(mainAxisSize: MainAxisSize.min, children: actions),
      ),
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({
    required this.title,
    required this.actions,
    required this.showTitle,
    required this.searchHint,
    required this.searchQuery,
    required this.showBack,
    this.onSearch,
  });

  final String title;
  final List<Widget> actions;
  final bool showTitle;
  final String searchHint;
  final String searchQuery;
  final ValueChanged<String>? onSearch;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: MediaQuery.textScalerOf(context).scale(AppSizes.topBarHeight),
          child: showBack
              ? NavigationToolbar(
                  middleSpacing: AppSpacing.sm,
                  leading: const TopBarBackLink(),
                  middle: AppTopBarTitle(
                    title: title,
                    align: TextAlign.center,
                    showTitle: showTitle,
                  ),
                  trailing: actions.isEmpty
                      ? null
                      : Row(mainAxisSize: MainAxisSize.min, children: actions),
                )
              : Row(
                  children: [
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: AppTopBarTitle(
                        title: title,
                        large: true,
                        showTitle: showTitle,
                      ),
                    ),
                    ...actions,
                  ],
                ),
        ),
        if (onSearch != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: AppSearchField(
              hint: searchHint,
              initialValue: searchQuery,
              onChanged: onSearch!,
            ),
          ),
      ],
    );
  }
}
