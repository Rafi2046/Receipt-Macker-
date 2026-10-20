import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_fab.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../../../business_profile/business_profile.dart';
import '../widgets/business_summary_card.dart';

/// Home tab: the business, and a button to start an invoice.
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profile = ref.watch(currentBusinessProfileProvider);
    return AppScaffold(
      title: l10n.appTitle,
      floatingActionButton: AppFab(
        label: l10n.invoiceNewTitle,
        onPressed: () => context.pushNamed(RouteNames.invoiceNew),
      ),
      body: profile.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView.fromError(
          e,
          onRetry: () => ref.invalidate(currentBusinessProfileProvider),
        ),
        data: (p) => ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            AppSpacing.pagePadding,
            AppSpacing.pagePadding,
            AppSizes.fabClearance,
          ),
          children: [
            if (p != null)
              BusinessSummaryCard(
                profile: p,
                actionLabel: l10n.homeEditProfile,
                onTap: () => context.pushNamed(RouteNames.businessProfile),
              ),
          ],
        ),
      ),
    );
  }
}
