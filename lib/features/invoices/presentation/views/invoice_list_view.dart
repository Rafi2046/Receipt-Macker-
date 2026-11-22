import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/feedback/empty_state.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/inputs/filter_pill.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../../../../core/widgets/layout/searchable_list.dart';
import '../../domain/models/invoice_status.dart';
import '../view_models/invoice_list_state.dart';
import '../view_models/invoice_list_view_model.dart';
import '../widgets/invoice_list_tile.dart';

/// All invoices, newest first, searchable and filterable.
class InvoiceListView extends ConsumerWidget {
  const InvoiceListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final invoices = ref.watch(invoiceListViewModelProvider);
    return AppScaffold(
      title: l10n.invoicesTitle,
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

enum _InvoiceFilter { all, unpaid, overdue, paid }

class _InvoiceList extends ConsumerStatefulWidget {
  const _InvoiceList({required this.state});

  final InvoiceListState state;

  @override
  ConsumerState<_InvoiceList> createState() => _InvoiceListState();
}

class _InvoiceListState extends ConsumerState<_InvoiceList> {
  _InvoiceFilter _filter = _InvoiceFilter.all;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filtered = widget.state.entries.where((entry) {
      return switch (_filter) {
        _InvoiceFilter.all => true,
        _InvoiceFilter.unpaid => entry.status != InvoiceStatus.paid,
        _InvoiceFilter.overdue => entry.status == InvoiceStatus.overdue,
        _InvoiceFilter.paid => entry.status == InvoiceStatus.paid,
      };
    }).toList();

    return SearchableList(
      searchHint: l10n.invoicesSearchHint,
      query: widget.state.query,
      onSearch: ref.read(invoiceListViewModelProvider.notifier).search,
      isEmpty: widget.state.isEmpty,
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
              FilterPill(
                label: l10n.filterAll,
                selected: _filter == _InvoiceFilter.all,
                onTap: () => setState(() => _filter = _InvoiceFilter.all),
              ),
              const SizedBox(width: AppSpacing.xs),
              FilterPill(
                label: l10n.filterUnpaid,
                selected: _filter == _InvoiceFilter.unpaid,
                onTap: () => setState(() => _filter = _InvoiceFilter.unpaid),
              ),
              const SizedBox(width: AppSpacing.xs),
              FilterPill(
                label: l10n.filterOverdue,
                selected: _filter == _InvoiceFilter.overdue,
                onTap: () => setState(() => _filter = _InvoiceFilter.overdue),
              ),
              const SizedBox(width: AppSpacing.xs),
              FilterPill(
                label: l10n.filterPaid,
                selected: _filter == _InvoiceFilter.paid,
                onTap: () => setState(() => _filter = _InvoiceFilter.paid),
              ),
            ],
          ),
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
      itemCount: filtered.length,
      itemBuilder: (context, i) {
        final entry = filtered[i];
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
