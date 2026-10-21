import 'package:flutter/material.dart';

import '../../constants/app_icons.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../utils/extensions/l10n_extension.dart';
import '../feedback/empty_state.dart';
import '../inputs/app_search_field.dart';
import 'app_divider.dart';

/// List screen body: a search box over the rows, a "no matches" message
/// while searching, and [empty] (with a first action) when nothing is saved.
class SearchableList extends StatelessWidget {
  const SearchableList({
    required this.searchHint,
    required this.query,
    required this.onSearch,
    required this.isEmpty,
    required this.empty,
    required this.itemCount,
    required this.itemBuilder,
    this.cards = false,
    super.key,
  });

  final String searchHint;
  final String query;
  final ValueChanged<String> onSearch;

  /// Nothing saved at all; shows [empty] without a search box.
  final bool isEmpty;
  final Widget empty;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// Rows are cards: inset to the page margin with gaps between them
  /// instead of full-width rows with dividers.
  final bool cards;

  @override
  Widget build(BuildContext context) {
    if (isEmpty) return empty;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            AppSpacing.sm,
            AppSpacing.pagePadding,
            AppSpacing.sm,
          ),
          child: AppSearchField(
            hint: searchHint,
            initialValue: query,
            onChanged: onSearch,
          ),
        ),
        Expanded(
          child: itemCount == 0
              ? _NoMatches(query: query.trim())
              : ListView.separated(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(
                    cards ? AppSpacing.pagePadding : 0,
                    cards ? AppSpacing.xs : 0,
                    cards ? AppSpacing.pagePadding : 0,
                    AppSizes.fabClearance,
                  ),
                  itemCount: itemCount,
                  itemBuilder: itemBuilder,
                  separatorBuilder: (_, _) => cards
                      ? const SizedBox(height: AppSpacing.sm)
                      : const AppDivider(
                          spacing: AppSpacing.xxs,
                          indent: AppSpacing.pagePadding,
                        ),
                ),
        ),
      ],
    );
  }
}

class _NoMatches extends StatelessWidget {
  const _NoMatches({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return EmptyState(
      icon: AppIcons.search,
      title: l10n.searchNoResultsTitle,
      message: l10n.searchNoResultsBody(query),
    );
  }
}
