import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_bar_variant.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/services/ads/list_ad_banner.dart';
import '../../../../core/services/purchases/free_plan.dart';
import '../../../../core/services/purchases/purchase_providers.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_fab.dart';
import '../../../../core/widgets/feedback/confirm_dialog.dart';
import '../../../../core/widgets/feedback/empty_state.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/list_skeleton.dart';
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
    final state = items.asData?.value;
    final showFab = state?.isEmpty == false;
    final showSearch = state != null && !state.isEmpty;
    return AppScaffold(
      // A list screen: the one place a banner ad may show (CLAUDE §9.2).
      bottomBar: const ListAdBanner(),
      title: l10n.itemsTitle,
      variant: AppBarVariant.search,
      searchHint: l10n.itemsSearchHint,
      searchQuery: state?.query ?? '',
      onSearch: showSearch
          ? ref.read(itemListViewModelProvider.notifier).search
          : null,
      floatingActionButton: showFab
          ? AppFab(
              label: l10n.itemAdd,
              onPressed: () => _openNewItem(context, ref),
            )
          : null,
      // Keep the list on screen while a new search runs.
      // Banner ads stay on the shell tab lists for now: an AdWidget on this
      // pushed route blanked the Flutter surface on Android 14.
      body: items.when(
        skipLoadingOnReload: true,
        data: (listState) => _ItemList(state: listState),
        loading: () =>
            const ListSkeleton(showSearch: false, showFilters: false),
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
      showSearch: false,
      onRefresh: () async {
        ref.invalidate(itemListViewModelProvider);
        await ref.read(itemListViewModelProvider.future);
      },
      isEmpty: state.isEmpty,
      empty: EmptyState(
        icon: AppIcons.item,
        title: l10n.itemsEmptyTitle,
        message: l10n.itemsEmptyBody,
        actionLabel: l10n.itemsEmptyAction,
        onAction: () => _openNewItem(context, ref),
      ),
      cards: true,
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
  final allowed = FreePlan.canAddItem(
    isPro: ref.read(proStatusProvider),
    count: count,
  );
  if (!allowed) {
    final confirmed = await ConfirmDialog.show(
      context,
      title: context.l10n.itemLimitReachedTitle,
      message: context.l10n.itemLimitReachedMessage(AppConstants.freeItemLimit),
      confirmLabel: context.l10n.upgradeToPro,
    );
    if (confirmed && context.mounted) {
      await context.pushNamed(RouteNames.paywall);
    }
    return;
  }
  await context.pushNamed(RouteNames.itemNew);
}
