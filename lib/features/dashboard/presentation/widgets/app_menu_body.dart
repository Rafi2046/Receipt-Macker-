import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/display/pro_upgrade_banner.dart';
import '../../../../core/widgets/layout/menu_link_group.dart';
import '../../../../core/widgets/layout/menu_link_row.dart';
import '../../../../core/widgets/layout/section_header.dart';
import '../../../business_profile/providers.dart';
import '../../../debug/presentation/view_models/sample_data_view_model.dart';
import 'app_menu_header.dart';

/// Shared menu content for the side drawer and the More tab.
class AppMenuBody extends ConsumerWidget {
  const AppMenuBody({this.onNavigate, super.key});

  /// Called before a push so a drawer can close first.
  final VoidCallback? onNavigate;

  void _go(BuildContext context, String route) {
    final router = GoRouter.of(context);
    onNavigate?.call();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router.pushNamed(route);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profile = ref.watch(currentBusinessProfileProvider).asData?.value;
    final name = (profile?.name.trim().isNotEmpty ?? false)
        ? profile!.name.trim()
        : l10n.businessUntitled;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        AppSpacing.lg,
        AppSpacing.pagePadding,
        AppSizes.fabClearance,
      ),
      children: [
        AppMenuHeader(
          name: name,
          logoPath: profile?.logoPath,
          onEdit: () => _go(context, RouteNames.businessProfile),
        ),
        const SizedBox(height: AppSpacing.lg),
        ProUpgradeBanner(onNavigate: onNavigate),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: l10n.menuSectionBusiness),
        const SizedBox(height: AppSpacing.sm),
        MenuLinkGroup(
          children: [
            MenuLinkRow(
              icon: AppIcons.business,
              label: l10n.businessProfileTitle,
              onTap: () => _go(context, RouteNames.businessProfile),
            ),
            MenuLinkRow(
              icon: AppIcons.item,
              label: l10n.itemsTitle,
              onTap: () => _go(context, RouteNames.items),
            ),
            MenuLinkRow(
              icon: AppIcons.backup,
              label: l10n.backupTitle,
              onTap: () => _go(context, RouteNames.backup),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: l10n.menuSectionApp),
        const SizedBox(height: AppSpacing.sm),
        MenuLinkGroup(
          children: [
            MenuLinkRow(
              icon: AppIcons.settings,
              label: l10n.settingsTitle,
              onTap: () => _go(context, RouteNames.settings),
            ),
            MenuLinkRow(
              icon: AppIcons.privacy,
              label: l10n.privacyTitle,
              onTap: () => _go(context, RouteNames.privacy),
            ),
            MenuLinkRow(
              icon: AppIcons.terms,
              label: l10n.termsTitle,
              onTap: () => _go(context, RouteNames.terms),
            ),
            MenuLinkRow(
              icon: AppIcons.support,
              label: l10n.menuSupport,
              subtitle: l10n.menuSupportHint,
              onTap: () => _go(context, RouteNames.support),
            ),
          ],
        ),
        if (kDebugMode) ...[
          const SizedBox(height: AppSpacing.sectionGap),
          SectionHeader(title: l10n.debugTools),
          const SizedBox(height: AppSpacing.sm),
          MenuLinkGroup(
            children: [
              MenuLinkRow(
                icon: AppIcons.widgets,
                label: l10n.themePreviewTitle,
                onTap: () => _go(context, RouteNames.themePreview),
              ),
              MenuLinkRow(
                icon: AppIcons.widgets,
                label: l10n.designDirectionsTitle,
                onTap: () => _go(context, RouteNames.designDirections),
              ),
              MenuLinkRow(
                icon: AppIcons.widgets,
                label: l10n.galleryTitle,
                onTap: () => _go(context, RouteNames.widgetGallery),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: l10n.debugAddSamples,
            variant: AppButtonVariant.secondary,
            isLoading: ref.watch(sampleDataViewModelProvider),
            onPressed: () => ref
                .read(sampleDataViewModelProvider.notifier)
                .addSampleInvoices(),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        Text(
          AppConstants.publisher,
          textAlign: TextAlign.center,
          style: context.textStyles.labelSmall?.copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
