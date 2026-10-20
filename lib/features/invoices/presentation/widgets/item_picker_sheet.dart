import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/empty_state.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/searchable_list.dart';
import '../../../items/items.dart';
import 'item_pick.dart';
import 'picker_sheet_frame.dart';

/// Searchable list of saved items, plus "One-off line" and "New item".
/// Use [ItemPickerSheet.show]; null when dismissed.
class ItemPickerSheet extends ConsumerWidget {
  const ItemPickerSheet({super.key});

  /// Returned when the user asks for a new saved item.
  static const String _newItem = 'new';

  static Future<ItemPick?> show(BuildContext context) async {
    final picked = await showModalBottomSheet<Object>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const ItemPickerSheet(),
    );
    if (picked is ItemPick) return picked;
    if (picked == _newItem && context.mounted) {
      final item = await context.pushNamed<Item>(RouteNames.itemNew);
      return item == null ? null : ItemPick.saved(item);
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final items = ref.watch(itemListViewModelProvider);
    void close(Object result) => Navigator.of(context).pop(result);
    return PickerSheetFrame(
      title: l10n.chooseItem,
      actions: [
        AppButton(
          label: l10n.addOneOffLine,
          variant: AppButtonVariant.text,
          onPressed: () => close(const ItemPick.oneOff()),
        ),
        AppButton(
          label: l10n.itemNewTitle,
          icon: AppIcons.add,
          variant: AppButtonVariant.text,
          onPressed: () => close(_newItem),
        ),
      ],
      body: items.when(
        skipLoadingOnReload: true,
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView.fromError(
          e,
          onRetry: () => ref.invalidate(itemListViewModelProvider),
        ),
        data: (state) => SearchableList(
          searchHint: l10n.itemsSearchHint,
          query: state.query,
          onSearch: ref.read(itemListViewModelProvider.notifier).search,
          isEmpty: state.isEmpty,
          empty: EmptyState(
            icon: AppIcons.item,
            title: l10n.itemsEmptyTitle,
            message: l10n.itemsEmptyBody,
            actionLabel: l10n.itemsEmptyAction,
            onAction: () => close(_newItem),
          ),
          itemCount: state.items.length,
          itemBuilder: (context, i) => ItemListTile(
            item: state.items[i],
            onTap: () => close(ItemPick.saved(state.items[i])),
          ),
        ),
      ),
    );
  }
}
