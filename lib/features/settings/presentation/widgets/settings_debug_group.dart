import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/services/purchases/purchase_providers.dart';
import '../../../../core/widgets/layout/editor_row.dart';
import 'settings_group.dart';

/// Debug builds only: switch Pro on or off without Google Play.
/// Developer text, never shown to users, so it is not translated.
class SettingsDebugGroup extends ConsumerWidget {
  const SettingsDebugGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pro = ref.watch(proStatusProvider);
    void toggle(bool value) =>
        ref.read(proStatusProvider.notifier).setUnlocked(value: value);
    return SettingsGroup(
      title: 'Developer test mode',
      children: [
        EditorRow(
          icon: AppIcons.setDebug,
          iconSize: AppSizes.iconRow,
          title: 'Unlock all Pro features',
          subtitle: 'Templates, colors, no watermark and no ads',
          onTap: () => toggle(!pro),
          trailing: Switch.adaptive(value: pro, onChanged: toggle),
        ),
      ],
    );
  }
}
