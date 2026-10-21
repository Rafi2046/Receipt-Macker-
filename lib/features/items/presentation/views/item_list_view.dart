import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/services/ads/list_ad_banner.dart';
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
import '../view_models/item_list_state.dart';
import '../view_models/item_list_view_model.dart';
import '../widgets/item_list_tile.dart';

/// All saved products and services, searchable. Tap one to edit it.
class ItemListView extends ConsumerWidget {
  const ItemListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final items = ref.watch(itemListViewModelProvider);
    final showFab = items.value?.isEmpty == false;
    return AppScaffold(
      title: l10n.itemsTitle,
      floatingActionButton: showFab
          ? AppFab(
              label: l10n.itemAdd,
              onPressed: () => _openNewItem(context, ref),
            )
          : null,
      bottomBar: const ListAdBanner(),
      // Keep the list (and the search box) on screen while a new search runs.
      body: items.when(
        skipLoadingOnReload: true,
        data: (state) => _ItemList(state: state),
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView.fromError(
          e,
          onRetry: () => ref.invalidate(itemListViewModelProvider),
        ),
      ),
    );
  }
}

class _ItemList extends ConsumerWidget {
  const _ItemList({required this.state});

  final ItemListState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return SearchableList(
      searchHint: l10n.itemsSearchHint,
      query: state.query,
      onSearch: ref.read(itemListViewModelProvider.notifier).search,
      isEmpty: state.isEmpty,
      empty: EmptyState(
        icon: AppIcons.item,
        title: l10n.itemsEmptyTitle,
        message: l10n.itemsEmptyBody,
        actionLabel: l10n.itemsEmptyAction,
        onAction: () => _openNewItem(context, ref),
      ),
      itemCount: state.items.length,
      itemBuilder: (context, i) {
        final item = state.items[i];
        return ItemListTile(
          item: item,
          onTap: () => context.pushNamed(
            RouteNames.itemEdit,
            pathParameters: {RouteNames.idParam: item.id},
          ),
        );
      },
    );
  }
}

Future<void> _openNewItem(BuildContext context, WidgetRef ref) async {
  final shown = ref.read(itemListViewModelProvider).asData?.value;
  final count = shown != null && !shown.isSearching
      ? shown.items.length
      : (await ref.read(itemRepositoryProvider).watchAll().first).length;
  if (!context.mounted) return;
  final allowed = FreePlan.canAdd(
    isPro: ref.read(proStatusProvider),
    count: count,
  );
  if (!allowed) {
    await context.pushNamed(RouteNames.paywall);
    return;
  }
  await context.pushNamed(RouteNames.itemNew);
}
