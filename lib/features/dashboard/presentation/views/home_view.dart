import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/empty_state.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../../../../core/widgets/layout/section_header.dart';
import '../../../business_profile/business_profile.dart';
import '../widgets/business_summary_card.dart';
import '../widgets/home_link_tile.dart';

/// Temporary home until the dashboard (M7): the business card, links to
/// clients and items, and what's next.
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profile = ref.watch(currentBusinessProfileProvider);
    return AppScaffold(
      title: l10n.appTitle,
      body: profile.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView.fromError(
          e,
          onRetry: () => ref.invalidate(currentBusinessProfileProvider),
        ),
        data: (p) => ListView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          children: [
            if (p != null)
              BusinessSummaryCard(
                profile: p,
                actionLabel: l10n.homeEditProfile,
                onTap: () => context.pushNamed(RouteNames.businessProfile),
              ),
            const _ListLinks(),
            EmptyState(
              icon: AppIcons.invoice,
              title: l10n.homeComingSoonTitle,
              message: l10n.homeComingSoonBody,
            ),
            if (kDebugMode) const _DebugLinks(),
          ],
        ),
      ),
    );
  }
}

class _ListLinks extends StatelessWidget {
  const _ListLinks();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sectionGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          SectionHeader(title: l10n.homeListsSection),
          HomeLinkTile(
            icon: AppIcons.invoice,
            label: l10n.invoicesTitle,
            onTap: () => context.pushNamed(RouteNames.invoices),
          ),
          HomeLinkTile(
            icon: AppIcons.client,
            label: l10n.clientsTitle,
            onTap: () => context.pushNamed(RouteNames.clients),
          ),
          HomeLinkTile(
            icon: AppIcons.item,
            label: l10n.itemsTitle,
            onTap: () => context.pushNamed(RouteNames.items),
          ),
        ],
      ),
    );
  }
}

class _DebugLinks extends StatelessWidget {
  const _DebugLinks();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        SectionHeader(title: l10n.debugTools),
        AppButton(
          label: l10n.themePreviewTitle,
          variant: AppButtonVariant.secondary,
          onPressed: () => context.pushNamed(RouteNames.themePreview),
        ),
        AppButton(
          label: l10n.galleryTitle,
          variant: AppButtonVariant.secondary,
          onPressed: () => context.pushNamed(RouteNames.widgetGallery),
        ),
      ],
    );
  }
}
