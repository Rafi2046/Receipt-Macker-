import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/display/avatar_initials.dart';
import '../../domain/models/client.dart';

/// One client row: initials, name, and phone / email when present.
class ClientListTile extends StatelessWidget {
  const ClientListTile({required this.client, required this.onTap, super.key});

  final Client client;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Bangla UI shows Bangla digits everywhere, including stored phones.
    final digits = AppFormatters(Localizations.localeOf(context).languageCode);
    final contact = digits.localizeDigits(
      [client.phone, client.email].where((s) => s.isNotEmpty).join(' · '),
    );
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pagePadding,
      ),
      leading: AvatarInitials(name: client.name),
      title: Text(client.name, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: contact.isEmpty
          ? null
          : Text(
              contact,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.bodySmall?.copyWith(
                color: context.appColors.textSecondary,
              ),
            ),
    );
  }
}
