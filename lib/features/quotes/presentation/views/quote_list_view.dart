import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_bar_variant.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/filter_icon_button.dart';
import '../../../../core/widgets/feedback/empty_state.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/inputs/filter_pill.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../../../../core/widgets/layout/searchable_list.dart';
import '../../../invoices/presentation/widgets/document_filter_sheet.dart';
import '../../domain/models/quote_list_filter.dart';
import '../view_models/quote_list_view_model.dart';
import '../widgets/quote_list_tile.dart';

class QuoteListView extends ConsumerWidget {
  const QuoteListView({super.key});

  Future<void> _openFilters(BuildContext context, WidgetRef ref) async {
    final state = ref.read(quoteListViewModelProvider).value;
    if (state == null) return;
    final result = await DocumentFilterSheet.show(
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
      variant: AppBarVariant.root,
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
                  FilterIconButton(
                    active: hasAdvanced,
                    tooltip: l10n.filterOpen,
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
