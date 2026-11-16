import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/feedback/empty_state.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../../../../core/widgets/layout/searchable_list.dart';
import '../../domain/logic/quote_status_resolver.dart';
import '../../domain/models/quote_list_filter.dart';
import '../../domain/models/quote_status.dart';
import '../../domain/models/quote_summary.dart';
import '../view_models/quote_list_view_model.dart';

class QuoteListView extends ConsumerWidget {
  const QuoteListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final async = ref.watch(quoteListViewModelProvider);
    return AppScaffold(
      title: l10n.quotesTitle,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(RouteNames.quoteNew),
        child: const Icon(AppIcons.add),
      ),
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
                  for (final filter in QuoteListFilter.values) ...[
                    if (filter != QuoteListFilter.values.first)
                      const SizedBox(width: AppSpacing.xs),
                    _FilterChip(
                      label: switch (filter) {
                        QuoteListFilter.all => l10n.filterAll,
                        QuoteListFilter.pending => l10n.quoteStatusPending,
                        QuoteListFilter.approved => l10n.quoteStatusApproved,
                        QuoteListFilter.overdue => l10n.filterOverdue,
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
          itemCount: state.quotes.length,
          itemBuilder: (context, index) => _QuoteTile(
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: colors.primary.withValues(alpha: 0.15),
      checkmarkColor: colors.primary,
      labelStyle: context.textStyles.labelLarge?.copyWith(
        color: selected ? colors.primary : colors.textSecondary,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      ),
      side: BorderSide(color: selected ? colors.primary : colors.border),
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.chip),
    );
  }
}

class _QuoteTile extends StatelessWidget {
  const _QuoteTile({required this.summary, required this.onTap});

  final QuoteSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final overdue = QuoteStatusResolver.isOverdue(
      summary.status,
      summary.validUntil,
    );
    final statusLabel = overdue
        ? l10n.filterOverdue
        : switch (summary.status) {
            QuoteStatus.pending => l10n.quoteStatusPending,
            QuoteStatus.approved => l10n.quoteStatusApproved,
            QuoteStatus.rejected => l10n.quoteStatusRejected,
          };
    final statusColor = overdue
        ? colors.danger
        : switch (summary.status) {
            QuoteStatus.pending => colors.warning,
            QuoteStatus.approved => colors.success,
            QuoteStatus.rejected => colors.neutral,
          };

    return ListTile(
      onTap: onTap,
      title: Text(
        summary.clientName ?? l10n.noClient,
        style: context.textStyles.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${summary.number} · $statusLabel',
        style: context.textStyles.bodySmall?.copyWith(
          color: colors.textSecondary,
        ),
      ),
      trailing: Text(
        format.currency(summary.totalMinor, summary.currencyCode),
        style: context.textStyles.titleSmall?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w700,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
