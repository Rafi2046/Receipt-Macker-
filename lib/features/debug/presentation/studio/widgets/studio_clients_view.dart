import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../../core/utils/initials.dart';
import '../studio_client.dart';
import '../studio_demo.dart';
import '../studio_money.dart';
import '../studio_scope.dart';
import 'studio_avatar.dart';
import 'studio_card.dart';
import 'studio_search_field.dart';

/// Clients grouped by the first letter, with what each one still owes.
class StudioClientsView extends StatefulWidget {
  const StudioClientsView({super.key});

  @override
  State<StudioClientsView> createState() => _StudioClientsViewState();
}

class _StudioClientsViewState extends State<StudioClientsView> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final groups = _groups();
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        AppSpacing.sm,
        AppSpacing.pagePadding,
        AppSpacing.lg,
      ),
      children: [
        Text(
          l10n.clientsTitle,
          style: context.studioType.title(context.studio.ink),
        ),
        const SizedBox(height: AppSpacing.md),
        StudioSearchField(
          hint: l10n.studioSearchClients,
          onChanged: (value) =>
              setState(() => _query = value.trim().toLowerCase()),
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final entry in groups.entries) ...[
          Text(
            entry.key,
            style: context.studioType.label(context.studio.muted),
          ),
          const SizedBox(height: AppSpacing.sm),
          StudioCard(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                for (final client in entry.value) _ClientRow(client: client),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ],
    );
  }

  Map<String, List<StudioClient>> _groups() {
    final matched = [
      for (final client in StudioDemo.clients)
        if (_query.isEmpty || client.name.toLowerCase().contains(_query))
          client,
    ];
    final groups = <String, List<StudioClient>>{};
    for (final client in matched) {
      final letter = Initials.of(client.name, max: 1);
      groups.putIfAbsent(letter, () => []).add(client);
    }
    return groups;
  }
}

class _ClientRow extends StatelessWidget {
  const _ClientRow({required this.client});

  final StudioClient client;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final phone = studioFormat(context).localizeDigits(client.phone);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          StudioAvatar(name: client.name),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.studioType.titleSm(palette.ink),
                ),
                Text(phone, style: context.studioType.secondary(palette.muted)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            studioMoney(context, client.outstandingMinor),
            style: context.studioType.amountSm(palette.ink),
          ),
        ],
      ),
    );
  }
}
