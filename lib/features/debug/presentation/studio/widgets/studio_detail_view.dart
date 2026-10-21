import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../studio_icons.dart';
import '../studio_invoice.dart';
import '../studio_money.dart';
import '../studio_scope.dart';
import 'studio_avatar.dart';
import 'studio_card.dart';
import 'studio_page_header.dart';
import 'studio_status_chip.dart';

/// Invoice detail: amount, progress, actions, and a payment timeline.
class StudioDetailView extends StatelessWidget {
  const StudioDetailView({
    required this.invoice,
    required this.onBack,
    super.key,
  });

  final StudioInvoice invoice;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.studio.background,
      child: Column(
        children: [
          StudioPageHeader(
            title: studioFormat(context).localizeDigits(invoice.number),
            onBack: onBack,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.sm,
                AppSpacing.pagePadding,
                AppSpacing.xl,
              ),
              children: [
                _Header(invoice: invoice),
                const SizedBox(height: AppSpacing.lg),
                const _Actions(),
                const SizedBox(height: AppSpacing.lg),
                _Client(invoice: invoice),
                const SizedBox(height: AppSpacing.lg),
                _Timeline(invoice: invoice),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.invoice});

  final StudioInvoice invoice;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final l10n = context.l10n;
    final progress = invoice.totalMinor == 0
        ? 0.0
        : invoice.paidMinor / invoice.totalMinor;
    return StudioCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudioStatusChip(status: invoice.status),
          const SizedBox(height: AppSpacing.sm),
          FittedBox(
            child: Text(
              studioMoney(context, invoice.totalMinor),
              style: context.studioType.display(palette.ink),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.xs),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: AppSpacing.sm,
              backgroundColor: palette.line,
              color: palette.accent,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.studioPaidOf(
              studioMoney(context, invoice.paidMinor),
              studioMoney(context, invoice.totalMinor),
            ),
            style: context.studioType.secondary(palette.muted),
          ),
          Text(
            '${l10n.studioBalanceDue} ${studioMoney(context, invoice.balanceMinor)}',
            style: context.studioType.body(palette.ink),
          ),
        ],
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        _Action(icon: StudioIcons.pdf, label: l10n.studioPreviewPdf),
        _Action(icon: StudioIcons.whatsApp, label: l10n.studioWhatsApp),
        _Action(icon: StudioIcons.payment, label: l10n.recordPayment),
        _Action(icon: StudioIcons.more, label: l10n.navMore),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            children: [
              Icon(icon, color: palette.accent, size: AppSizes.iconMd),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.studioType.label(palette.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Client extends StatelessWidget {
  const _Client({required this.invoice});

  final StudioInvoice invoice;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final phone = studioFormat(context).localizeDigits(invoice.phone);
    return StudioCard(
      child: Row(
        children: [
          StudioAvatar(name: invoice.client),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.client,
                  style: context.studioType.titleSm(palette.ink),
                ),
                Text(phone, style: context.studioType.secondary(palette.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.invoice});

  final StudioInvoice invoice;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.studio;
    final paid = invoice.paidMinor;
    return StudioCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.studioPaymentHistory,
            style: context.studioType.titleSm(palette.ink),
          ),
          const SizedBox(height: AppSpacing.md),
          if (paid == 0)
            Text(
              l10n.paymentsEmpty,
              style: context.studioType.body(palette.muted),
            )
          else ...[
            _Event(
              label: l10n.methodBkash,
              minor: (paid * 2) ~/ 3,
              date: DateTime(2026, 10, 12),
            ),
            _Event(
              label: l10n.methodCash,
              minor: paid - (paid * 2) ~/ 3,
              date: DateTime(2026, 10, 18),
            ),
          ],
        ],
      ),
    );
  }
}

class _Event extends StatelessWidget {
  const _Event({required this.label, required this.minor, required this.date});

  final String label;
  final int minor;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final when = studioFormat(context).date(date);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: AppSpacing.md,
            height: AppSpacing.md,
            decoration: BoxDecoration(
              color: palette.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.studioType.body(palette.ink)),
                Text(when, style: context.studioType.secondary(palette.muted)),
              ],
            ),
          ),
          Text(
            studioMoney(context, minor),
            style: context.studioType.amountSm(palette.ink),
          ),
        ],
      ),
    );
  }
}
