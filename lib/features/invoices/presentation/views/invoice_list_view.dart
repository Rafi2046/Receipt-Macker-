import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_fab.dart';
import '../../../../core/widgets/feedback/empty_state.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../../../../core/widgets/layout/searchable_list.dart';
import '../view_models/invoice_list_state.dart';
import '../view_models/invoice_list_view_model.dart';
import '../widgets/invoice_list_tile.dart';

/// All invoices, newest first, searchable. Tap one to open it.
class InvoiceListView extends ConsumerWidget {
  const InvoiceListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final invoices = ref.watch(invoiceListViewModelProvider);
    final showFab = invoices.value?.isEmpty == false;
    return AppScaffold(
      title: l10n.invoicesTitle,
      floatingActionButton: showFab
          ? AppFab(
              label: l10n.invoiceNewTitle,
              onPressed: () => context.pushNamed(RouteNames.invoiceNew),
            )
          : null,
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
    return SearchableList(
      searchHint: l10n.invoicesSearchHint,
      query: state.query,
      onSearch: ref.read(invoiceListViewModelProvider.notifier).search,
      isEmpty: state.isEmpty,
      empty: EmptyState(
        icon: AppIcons.invoice,
        title: l10n.invoicesEmptyTitle,
        message: l10n.invoicesEmptyBody,
        actionLabel: l10n.invoicesEmptyAction,
        onAction: () => context.pushNamed(RouteNames.invoiceNew),
      ),
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
