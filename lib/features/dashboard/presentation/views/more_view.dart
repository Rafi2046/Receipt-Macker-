import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/purchases/purchase_providers.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../../../../core/widgets/layout/section_header.dart';
import '../../../debug/presentation/view_models/sample_data_view_model.dart';
import '../widgets/home_link_tile.dart';

/// Everything that is not a main tab: the business, the catalog, and
/// the debug tools.
class MoreView extends ConsumerWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return AppScaffold(
      title: l10n.navMore,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          AppSpacing.pagePadding,
          AppSpacing.pagePadding,
          AppSizes.fabClearance,
        ),
        children: [
          const _ProCard(),
          const SizedBox(height: AppSpacing.sm),
          HomeLinkTile(
            icon: AppIcons.business,
            label: l10n.businessProfileTitle,
            onTap: () => context.pushNamed(RouteNames.businessProfile),
          ),
          const SizedBox(height: AppSpacing.sm),
          HomeLinkTile(
            icon: AppIcons.item,
            label: l10n.itemsTitle,
            onTap: () => context.pushNamed(RouteNames.items),
          ),
          const SizedBox(height: AppSpacing.sm),
          HomeLinkTile(
            icon: AppIcons.info,
            label: l10n.privacyTitle,
            onTap: () => context.pushNamed(RouteNames.privacy),
          ),
          const SizedBox(height: AppSpacing.sm),
          HomeLinkTile(
            icon: AppIcons.info,
            label: l10n.termsTitle,
            onTap: () => context.pushNamed(RouteNames.terms),
          ),
          if (kDebugMode) ...[
            const SizedBox(height: AppSpacing.sectionGap),
            SectionHeader(title: l10n.debugTools),
            const SizedBox(height: AppSpacing.sm),
            HomeLinkTile(
              icon: AppIcons.widgets,
              label: l10n.themePreviewTitle,
              onTap: () => context.pushNamed(RouteNames.themePreview),
            ),
            const SizedBox(height: AppSpacing.sm),
            HomeLinkTile(
              icon: AppIcons.widgets,
              label: l10n.designDirectionsTitle,
              onTap: () => context.pushNamed(RouteNames.designDirections),
            ),
            const SizedBox(height: AppSpacing.sm),
            HomeLinkTile(
              icon: AppIcons.widgets,
              label: l10n.galleryTitle,
              onTap: () => context.pushNamed(RouteNames.widgetGallery),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: l10n.debugAddSamples,
              variant: AppButtonVariant.secondary,
              isLoading: ref.watch(sampleDataViewModelProvider),
              onPressed: () => ref
                  .read(sampleDataViewModelProvider.notifier)
                  .addSampleInvoices(),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProCard extends ConsumerWidget {
  const _ProCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final pro = ref.watch(proStatusProvider);
    return AppCard(
      onTap: () =>
          context.pushNamed(pro ? RouteNames.proWelcome : RouteNames.paywall),
      child: Row(
        children: [
          Icon(AppIcons.pro, color: context.appColors.secondary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.proMoreTitle, style: context.textStyles.titleMedium),
                Text(
                  pro ? l10n.proMoreActive : l10n.proMoreBody,
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: context.appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
