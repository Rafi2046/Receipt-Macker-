import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/purchases/purchase_providers.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/inputs/app_switch.dart';
import '../../../../core/widgets/layout/editor_row.dart';
import '../../../debug/presentation/view_models/sample_data_view_model.dart';
import 'settings_group.dart';

/// Debug builds only: the Pro switch, design tools and sample data.
/// The Pro switch text is developer-only, so it is not translated.
class SettingsDebugGroup extends ConsumerWidget {
  const SettingsDebugGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final pro = ref.watch(proStatusProvider);
    void toggle(bool value) =>
        ref.read(proStatusProvider.notifier).setUnlocked(value: value);
    EditorRow tool(String title, String route) => EditorRow(
      icon: AppIcons.widgets,
      iconSize: AppSizes.iconRow,
      title: title,
      onTap: () => context.pushNamed(route),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        SettingsGroup(
          title: l10n.debugTools,
          children: [
            EditorRow(
              icon: AppIcons.setDebug,
              iconSize: AppSizes.iconRow,
              title: 'Unlock all Pro features',
              subtitle: 'Templates, colors, no watermark and no ads',
              onTap: () => toggle(!pro),
              trailing: AppSwitch(value: pro, onChanged: toggle),
            ),
            tool(l10n.themePreviewTitle, RouteNames.themePreview),
            tool(l10n.designDirectionsTitle, RouteNames.designDirections),
            tool(l10n.galleryTitle, RouteNames.widgetGallery),
          ],
        ),
        AppButton(
          label: l10n.debugAddSamples,
          variant: AppButtonVariant.secondary,
          isLoading: ref.watch(sampleDataViewModelProvider),
          onPressed: () => ref
              .read(sampleDataViewModelProvider.notifier)
              .addSampleInvoices(),
        ),
      ],
    );
  }
}
