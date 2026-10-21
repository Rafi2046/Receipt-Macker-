import 'package:flutter/material.dart';

import '../../../../../core/constants/app_images.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../studio_demo.dart';
import '../studio_icons.dart';
import '../studio_invoice.dart';
import '../studio_scope.dart';
import '../studio_snapshot.dart';
import 'studio_card.dart';
import 'studio_hero_card.dart';
import 'studio_invoice_tile.dart';
import 'studio_month_chart.dart';
import 'studio_month_switcher.dart';
import 'studio_overdue_banner.dart';
import 'studio_quick_actions.dart';

/// Home mock: greeting, hero, actions, chart, and recent invoices.
class StudioHomeView extends StatelessWidget {
  const StudioHomeView({
    required this.months,
    required this.monthIndex,
    required this.onMonth,
    required this.onOpen,
    required this.onSeeAll,
    required this.onNewInvoice,
    required this.onRecordPayment,
    required this.onAddClient,
    required this.onAddItem,
    required this.onSettings,
    super.key,
  });

  final List<StudioSnapshot> months;
  final int monthIndex;
  final ValueChanged<int> onMonth;
  final ValueChanged<StudioInvoice> onOpen;
  final VoidCallback onSeeAll;
  final VoidCallback onNewInvoice;
  final VoidCallback onRecordPayment;
  final VoidCallback onAddClient;
  final VoidCallback onAddItem;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final snapshot = months[monthIndex];
    final recent = StudioDemo.invoices.where((invoice) => invoice.inOctober);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        AppSpacing.sm,
        AppSpacing.pagePadding,
        AppSizes.fabClearance,
      ),
      children: [
        _Greeting(onSettings: onSettings),
        const SizedBox(height: AppSpacing.md),
        StudioMonthSwitcher(
          month: snapshot.month,
          onPrevious: monthIndex > 0 ? () => onMonth(monthIndex - 1) : null,
          onNext: monthIndex < months.length - 1
              ? () => onMonth(monthIndex + 1)
              : null,
        ),
        const SizedBox(height: AppSpacing.sm),
        StudioHeroCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.lg),
        StudioQuickActions(
          onNewInvoice: onNewInvoice,
          onRecordPayment: onRecordPayment,
          onAddClient: onAddClient,
          onAddItem: onAddItem,
        ),
        const SizedBox(height: AppSpacing.lg),
        StudioOverdueBanner(onReview: onSeeAll),
        const SizedBox(height: AppSpacing.md),
        StudioMonthChart(months: months, selected: monthIndex),
        const SizedBox(height: AppSpacing.lg),
        _RecentHeader(onSeeAll: onSeeAll),
        const SizedBox(height: AppSpacing.sm),
        StudioCard(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              for (final invoice in recent)
                StudioInvoiceTile(
                  invoice: invoice,
                  onTap: () => onOpen(invoice),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.onSettings});

  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final l10n = context.l10n;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.md),
          child: Image.asset(
            AppImages.logo,
            width: AppSizes.avatarLg,
            height: AppSizes.avatarLg,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n.greetingEvening}, ${StudioDemo.owner}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.studioType.titleSm(palette.ink),
              ),
              Text(
                StudioDemo.business,
                style: context.studioType.secondary(palette.muted),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: l10n.studioNotifications,
          onPressed: () {},
          icon: Icon(StudioIcons.bell, color: palette.ink),
        ),
        IconButton(
          tooltip: l10n.studioSettings,
          onPressed: onSettings,
          icon: Icon(StudioIcons.settings, color: palette.ink),
        ),
      ],
    );
  }
}

class _RecentHeader extends StatelessWidget {
  const _RecentHeader({required this.onSeeAll});

  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.studioRecentInvoices,
            style: context.studioType.titleSm(context.studio.ink),
          ),
        ),
        TextButton(onPressed: onSeeAll, child: Text(l10n.studioSeeAll)),
      ],
    );
  }
}
