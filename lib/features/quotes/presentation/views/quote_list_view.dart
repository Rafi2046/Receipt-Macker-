import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/feedback/empty_state.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/inputs/filter_pill.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../../../../core/widgets/layout/searchable_list.dart';
import '../../domain/models/quote_list_filter.dart';
import '../view_models/quote_list_view_model.dart';
import '../widgets/quote_filter_sheet.dart';
import '../widgets/quote_list_tile.dart';

class QuoteListView extends ConsumerWidget {
  const QuoteListView({super.key});

  Future<void> _openFilters(BuildContext context, WidgetRef ref) async {
    final state = ref.read(quoteListViewModelProvider).value;
    if (state == null) return;
    final result = await QuoteFilterSheet.show(
      context,
      initial: state.advanced,
    );
    if (result == null) return;
    ref.read(quoteListViewModelProvider.notifier).setAdvancedFilters(result);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final async = ref.watch(quoteListViewModelProvider);
    final hasAdvanced = async.value?.hasAdvancedFilters ?? false;
    return AppScaffold(
      title: l10n.quotesTitle,
      body: async.when(
        skipLoadingOnReload: true,
        data: (state) => SearchableList(
          searchHint: l10n.quotesSearchHint,
          query: state.query,
          onSearch: ref.read(quoteListViewModelProvider.notifier).search,
          isEmpty: state.isEmpty,
          header: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pagePadding,
              0,
              AppSpacing.pagePadding,
              AppSpacing.sm,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterIconButton(
                    active: hasAdvanced,
                    onTap: () => _openFilters(context, ref),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  for (final filter in QuoteListFilter.values) ...[
                    if (filter != QuoteListFilter.values.first)
                      const SizedBox(width: AppSpacing.xs),
                    FilterPill(
                      label: switch (filter) {
                        QuoteListFilter.all => l10n.filterAll,
                        QuoteListFilter.pending => l10n.quoteStatusPending,
                        QuoteListFilter.approved => l10n.quoteStatusApproved,
                        QuoteListFilter.overdue => l10n.filterOverdue,
                        QuoteListFilter.cancelled => l10n.quoteStatusCancelled,
                      },
                      selected: state.filter == filter,
                      onTap: () => ref
                          .read(quoteListViewModelProvider.notifier)
                          .setFilter(filter),
                    ),
                  ],
                ],
              ),
            ),
          ),
          empty: EmptyState(
            icon: AppIcons.quote,
            title: l10n.quotesEmptyTitle,
            message: l10n.quotesEmptyBody,
            actionLabel: l10n.quotesEmptyAction,
            onAction: () => context.pushNamed(RouteNames.quoteNew),
          ),
          cards: true,
          itemCount: state.quotes.length,
          itemBuilder: (context, index) => QuoteListTile(
            summary: state.quotes[index],
            onTap: () => context.pushNamed(
              RouteNames.quoteEdit,
              pathParameters: {RouteNames.idParam: state.quotes[index].id},
            ),
          ),
        ),
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView.fromError(
          e,
          onRetry: () => ref.invalidate(quoteListViewModelProvider),
        ),
      ),
    );
  }
}

class _FilterIconButton extends StatelessWidget {
  const _FilterIconButton({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: active
          ? colors.primary.withValues(alpha: 0.15)
          : colors.surfaceAlt,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(
            AppIcons.filter,
            color: active ? colors.primary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
