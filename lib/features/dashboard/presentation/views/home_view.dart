import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../home_snapshot.dart';
import '../view_models/home_view_model.dart';
import '../widgets/home_hero_card.dart';
import '../widgets/home_invoice_row.dart';

/// Home tab: what is owed, this month, and the newest invoices.
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
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        AppSpacing.lg,
        AppSpacing.pagePadding,
        AppSizes.fabClearance,
      ),
      children: [
        Text(
          _greeting(l10n, snapshot.hour),
          style: context.textStyles.bodyMedium?.copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
        Text(snapshot.businessName, style: context.textStyles.titleLarge),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            onPressed: () => context.pushNamed(RouteNames.businessProfile),
            child: Text(l10n.homeEditProfile),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        HomeHeroCard(snapshot: snapshot),
        if (snapshot.overdueCount > 0) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.homeOverdueLine(
              format.integer(snapshot.overdueCount),
              format.currency(snapshot.overdueMinor, snapshot.currencyCode),
            ),
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.appColors.danger,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        if (snapshot.hasInvoices)
          _Recent(snapshot: snapshot)
        else
          AppButton(
            label: l10n.invoicesEmptyAction,
            expand: true,
            onPressed: () => context.pushNamed(RouteNames.invoiceNew),
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

String _greeting(AppLocalizations l10n, int hour) {
  if (hour < 12) return l10n.greetingMorning;
  if (hour < 17) return l10n.greetingAfternoon;
  return l10n.greetingEvening;
}
