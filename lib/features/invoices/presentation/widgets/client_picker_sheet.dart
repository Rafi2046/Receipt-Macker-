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
import '../../../clients/clients.dart';
import 'picker_sheet_frame.dart';

/// Searchable list of saved clients, with "New client".
/// Use [ClientPickerSheet.show]; it resolves to the chosen or new client,
/// or null when dismissed.
class ClientPickerSheet extends ConsumerWidget {
  const ClientPickerSheet({super.key});

  /// Returned when the user asks for a new client.
  static const String _newClient = 'new';

  static Future<Client?> show(BuildContext context) async {
    final picked = await showModalBottomSheet<Object>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const ClientPickerSheet(),
    );
    if (picked is Client) return picked;
    if (picked == _newClient && context.mounted) {
      return context.pushNamed<Client>(RouteNames.clientNew);
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final clients = ref.watch(clientListViewModelProvider);
    void createNew() => Navigator.of(context).pop(_newClient);
    return PickerSheetFrame(
      title: l10n.chooseClient,
      actions: [
        AppButton(
          label: l10n.clientNewTitle,
          icon: AppIcons.add,
          variant: AppButtonVariant.text,
          onPressed: createNew,
        ),
      ],
      body: clients.when(
        skipLoadingOnReload: true,
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView.fromError(
          e,
          onRetry: () => ref.invalidate(clientListViewModelProvider),
        ),
        data: (state) => SearchableList(
          searchHint: l10n.clientsSearchHint,
          query: state.query,
          onSearch: ref.read(clientListViewModelProvider.notifier).search,
          isEmpty: state.isEmpty,
          empty: EmptyState(
            icon: AppIcons.client,
            title: l10n.clientsEmptyTitle,
            message: l10n.clientsEmptyBody,
            actionLabel: l10n.clientsEmptyAction,
            onAction: createNew,
          ),
          itemCount: state.clients.length,
          itemBuilder: (context, i) => ClientListTile(
            client: state.clients[i],
            onTap: () => Navigator.of(context).pop(state.clients[i]),
          ),
        ),
      ),
    );
  }
}
