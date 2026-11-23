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
import '../../domain/models/invoice_list_filter.dart';
import '../view_models/invoice_list_state.dart';
import '../view_models/invoice_list_view_model.dart';
import '../widgets/document_filter_sheet.dart';
import '../widgets/invoice_list_tile.dart';
import '../widgets/invoice_overview_section.dart';

/// All invoices, newest first: an overview of the chosen period, status
/// chips, more filters, search and the list.
class InvoiceListView extends ConsumerWidget {
  const InvoiceListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final invoices = ref.watch(invoiceListViewModelProvider);
    return AppScaffold(
      title: l10n.invoicesTitle,
      variant: AppBarVariant.root,
      body: invoices.when(
        skipLoadingOnReload: true,
        data: (state) => _InvoiceList(state: state),
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView.fromError(
          e,
          onRetry: () => ref.invalidate(invoiceListViewModelProvider),
        ),
      ),
    );
  }
}

class _InvoiceList extends ConsumerWidget {
  const _InvoiceList({required this.state});

  final InvoiceListState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final vm = ref.read(invoiceListViewModelProvider.notifier);
    return SearchableList(
      searchHint: l10n.invoicesSearchHint,
      query: state.query,
      onSearch: vm.search,
      isEmpty: state.isEmpty,
      header: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          0,
          AppSpacing.pagePadding,
          AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.md,
          children: [
            InvoiceOverviewSection(
              overview: state.overview,
              period: state.period,
              filter: state.filter,
              onPeriod: vm.setPeriod,
              onFilter: vm.setFilter,
            ),
            _FilterBar(state: state),
          ],
        ),
      ),
      empty: EmptyState(
        icon: AppIcons.invoice,
        title: l10n.invoicesEmptyTitle,
        message: l10n.invoicesEmptyBody,
        actionLabel: l10n.invoicesEmptyAction,
        onAction: () => context.pushNamed(RouteNames.invoiceNew),
      ),
      cards: true,
      itemCount: state.entries.length,
      itemBuilder: (context, i) {
        final entry = state.entries[i];
        return InvoiceListTile(
          entry: entry,
          onTap: () => context.pushNamed(
            RouteNames.invoiceDetail,
            pathParameters: {RouteNames.idParam: entry.summary.id},
          ),
        );
      },
    );
  }
}

/// The filter button, then one pill per status.
class _FilterBar extends ConsumerWidget {
  const _FilterBar({required this.state});

  final InvoiceListState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final vm = ref.read(invoiceListViewModelProvider.notifier);
    String label(InvoiceListFilter f) => switch (f) {
      InvoiceListFilter.all => l10n.filterAll,
      InvoiceListFilter.draft => l10n.statusDraft,
      InvoiceListFilter.unpaid => l10n.filterUnpaid,
      InvoiceListFilter.partiallyPaid => l10n.statusPartiallyPaid,
      InvoiceListFilter.overdue => l10n.filterOverdue,
      InvoiceListFilter.paid => l10n.filterPaid,
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: AppSpacing.xs,
        children: [
          FilterIconButton(
            active: state.hasAdvancedFilters,
            tooltip: l10n.filterOpen,
            onTap: () async {
              final picked = await DocumentFilterSheet.show(
                context,
                initial: state.advanced,
              );
              if (picked != null) vm.setAdvancedFilters(picked);
            },
          ),
          for (final f in InvoiceListFilter.values)
            FilterPill(
              label: label(f),
              selected: state.filter == f,
              onTap: () => vm.setFilter(f),
            ),
        ],
      ),
    );
  }
}
