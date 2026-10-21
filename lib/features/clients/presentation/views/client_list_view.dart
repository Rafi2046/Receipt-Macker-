import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/services/purchases/free_plan.dart';
import '../../../../core/services/purchases/purchase_providers.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_fab.dart';
import '../../../../core/widgets/feedback/empty_state.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../../../../core/widgets/layout/searchable_list.dart';
import '../../providers.dart';
import '../view_models/client_list_state.dart';
import '../view_models/client_list_view_model.dart';
import '../widgets/client_list_tile.dart';

/// All clients, searchable. Tap a client to edit it.
class ClientListView extends ConsumerWidget {
  const ClientListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final clients = ref.watch(clientListViewModelProvider);
    final showFab = clients.value?.isEmpty == false;
    return AppScaffold(
      title: l10n.clientsTitle,
      floatingActionButton: showFab
          ? AppFab(
              label: l10n.clientAdd,
              onPressed: () => _openNewClient(context, ref),
            )
          : null,
      // Keep the list (and the search box) on screen while a new search runs.
      body: clients.when(
        skipLoadingOnReload: true,
        data: (state) => _ClientList(state: state),
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView.fromError(
          e,
          onRetry: () => ref.invalidate(clientListViewModelProvider),
        ),
      ),
    );
  }
}

class _ClientList extends ConsumerWidget {
  const _ClientList({required this.state});

  final ClientListState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return SearchableList(
      searchHint: l10n.clientsSearchHint,
      query: state.query,
      onSearch: ref.read(clientListViewModelProvider.notifier).search,
      isEmpty: state.isEmpty,
      empty: EmptyState(
        icon: AppIcons.client,
        title: l10n.clientsEmptyTitle,
        message: l10n.clientsEmptyBody,
        actionLabel: l10n.clientsEmptyAction,
        onAction: () => _openNewClient(context, ref),
      ),
      cards: true,
      itemCount: state.clients.length,
      itemBuilder: (context, i) {
        final client = state.clients[i];
        return ClientListTile(
          client: client,
          onTap: () => context.pushNamed(
            RouteNames.clientEdit,
            pathParameters: {RouteNames.idParam: client.id},
          ),
        );
      },
    );
  }
}

Future<void> _openNewClient(BuildContext context, WidgetRef ref) async {
  final shown = ref.read(clientListViewModelProvider).asData?.value;
  final count = shown != null && !shown.isSearching
      ? shown.clients.length
      : (await ref.read(clientRepositoryProvider).watchAll().first).length;
  if (!context.mounted) return;
  final allowed = FreePlan.canAdd(
    isPro: ref.read(proStatusProvider),
    count: count,
  );
  if (!allowed) {
    await context.pushNamed(RouteNames.paywall);
    return;
  }
  await context.pushNamed(RouteNames.clientNew);
}
