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
              onPressed: () => context.pushNamed(RouteNames.clientNew),
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
        onAction: () => context.pushNamed(RouteNames.clientNew),
      ),
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
