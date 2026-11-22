import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/feedback/empty_state.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/searchable_list.dart';
import '../../../items/items.dart';
import 'editor_add_dot.dart';
import 'editor_row.dart';
import 'item_pick.dart';
import 'picker_page_frame.dart';

/// Full-screen list of saved items to search and pick, under "New item"
/// and "One-off line". Use [ItemPickerSheet.show]; null when dismissed.
class ItemPickerSheet extends ConsumerWidget {
  const ItemPickerSheet({super.key});

  /// Returned when the user asks for a new saved item.
  static const String _newItem = 'new';

  static Future<ItemPick?> show(BuildContext context) async {
    final picked = await PickerPageFrame.push<Object>(
      context,
      (_) => const ItemPickerSheet(),
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
    final colors = context.appColors;
    return PickerPageFrame(
      title: l10n.chooseItem,
      listTitle: l10n.pickerSavedItems,
      actions: [
        EditorRow(
          icon: AppIcons.add,
          tone: colors.primary,
          title: l10n.itemNewTitle,
          subtitle: l10n.pickerNewItemHint,
          trailing: const EditorAddDot(),
          onTap: () => close(_newItem),
        ),
        EditorRow(
          icon: AppIcons.oneOff,
          tone: colors.info,
          title: l10n.addOneOffLine,
          subtitle: l10n.pickerOneOffHint,
          onTap: () => close(const ItemPick.oneOff()),
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
          cards: true,
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
