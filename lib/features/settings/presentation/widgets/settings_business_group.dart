import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/layout/editor_row.dart';
import 'settings_group.dart';

/// The business's own records: profile, clients, items and backups.
class SettingsBusinessGroup extends StatelessWidget {
  const SettingsBusinessGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    EditorRow row(IconData icon, String title, String route) => EditorRow(
      icon: icon,
      iconSize: AppSizes.iconRow,
      title: title,
      onTap: () => context.pushNamed(route),
    );
    return SettingsGroup(
      title: l10n.menuSectionBusiness,
      children: [
        row(
          AppIcons.business,
          l10n.businessProfileTitle,
          RouteNames.businessProfile,
        ),
        row(AppIcons.clients, l10n.clientsTitle, RouteNames.clients),
        row(AppIcons.item, l10n.itemsTitle, RouteNames.items),
        row(AppIcons.setBackup, l10n.backupTitle, RouteNames.backup),
      ],
    );
  }
}
