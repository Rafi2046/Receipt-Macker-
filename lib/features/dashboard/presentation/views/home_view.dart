import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/display/avatar_initials.dart';
import '../../../../core/widgets/feedback/empty_state.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/app_menu_host.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../home_snapshot.dart';
import '../view_models/home_view_model.dart';
import '../widgets/home_hero_card.dart';
import '../widgets/home_invoice_row.dart';
import '../widgets/home_templates_carousel.dart';

/// Home tab: what is owed, templates, and recent invoices (or empty state).
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeViewModelProvider);
    return AppScaffold(
      body: home.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView.fromError(
          error,
          onRetry: () => ref.invalidate(homeViewModelProvider),
        ),
        data: (snapshot) => _HomeBody(snapshot: snapshot),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.snapshot});

  final HomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        AppSpacing.sm,
        AppSpacing.pagePadding,
        AppSizes.fabClearance,
      ),
      children: [
        Row(
          children: [
            IconButton(
              tooltip: l10n.menuOpen,
              onPressed: AppMenuHost.maybeOf(context),
              icon: Icon(AppIcons.menu, color: context.appColors.textPrimary),
            ),
            Expanded(
              child: Text(
                l10n.navHome,
                style: context.textStyles.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Tooltip(
              message: l10n.homeEditProfile,
              child: Material(
                color: context.appColors.surface.withValues(alpha: 0),
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  key: const Key('home_profile_avatar_button'),
                  onTap: () => context.pushNamed(RouteNames.businessProfile),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.appColors.primary.withValues(
                          alpha: 0.35,
                        ),
                        width: 1.5,
                      ),
                    ),
                    child: AvatarInitials(
                      name: snapshot.businessName,
                      size: 42,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        HomeHeroCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.lg),
        const HomeTemplatesCarousel(),
        const SizedBox(height: AppSpacing.lg),
        if (snapshot.hasInvoices)
          _Recent(snapshot: snapshot)
        else
          EmptyState(
            icon: AppIcons.invoice,
            title: l10n.invoicesEmptyTitle,
            message: l10n.invoicesEmptyBody,
            actionLabel: l10n.invoicesEmptyAction,
            onAction: () => context.pushNamed(RouteNames.invoiceNew),
          ),
      ],
    );
  }
}

class _Recent extends StatelessWidget {
  const _Recent({required this.snapshot});

  final HomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.homeRecent,
                style: context.textStyles.titleMedium,
              ),
            ),
            TextButton(
              onPressed: () => context.goNamed(RouteNames.invoices),
              child: Text(l10n.homeSeeAll),
            ),
          ],
        ),
        for (final invoice in snapshot.recent) ...[
          HomeInvoiceRow(
            invoice: invoice,
            onTap: () => context.pushNamed(
              RouteNames.invoiceDetail,
              pathParameters: {RouteNames.idParam: invoice.summary.id},
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
