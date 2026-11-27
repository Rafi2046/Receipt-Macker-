import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_bar_variant.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/clock.dart';
import '../../../../core/services/url_launch_service.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/buttons/app_icon_button.dart';
import '../../../../core/widgets/display/amount_text.dart';
import '../../../../core/widgets/display/avatar_initials.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/form_skeleton.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../../../../core/widgets/layout/section_header.dart';
import '../../../invoices/domain/logic/invoice_status_resolver.dart';
import '../../../invoices/presentation/view_models/invoice_list_state.dart';
import '../../../invoices/presentation/widgets/invoice_list_tile.dart';
import '../../domain/models/client_financial_summary.dart';
import '../view_models/client_detail_view_model.dart';

/// Client detail screen showing client profile, quick contact actions (Call, WhatsApp),
/// financial totals (Billed, Paid, Outstanding Balance), and a list of invoices.
class ClientDetailView extends ConsumerWidget {
  const ClientDetailView({required this.clientId, super.key});

  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final asyncState = ref.watch(clientDetailViewModelProvider(clientId));

    ref.listen(clientDetailViewModelProvider(clientId), (prev, next) {
      if (prev?.value?.client != null && next.value?.client == null) {
        Navigator.of(context).maybePop();
      }
    });

    return asyncState.when(
      loading: () => AppScaffold(
        title: l10n.clientDetailTitle,
        variant: AppBarVariant.pushed,
        body: const FormSkeleton(),
      ),
      error: (e, _) => AppScaffold(
        title: l10n.clientDetailTitle,
        variant: AppBarVariant.pushed,
        body: ErrorView.fromError(
          e,
          onRetry: () =>
              ref.invalidate(clientDetailViewModelProvider(clientId)),
        ),
      ),
      data: (state) {
        final client = state.client;
        if (client == null) {
          return AppScaffold(
            title: l10n.clientDetailTitle,
            variant: AppBarVariant.pushed,
            body: ErrorView(
              message: l10n.errorNotFound,
              onRetry: () => Navigator.of(context).maybePop(),
            ),
          );
        }

        final format = AppFormatters(
          Localizations.localeOf(context).languageCode,
        );
        final today = ref.watch(clockProvider).today();

        return AppScaffold(
          title: client.name,
          variant: AppBarVariant.pushed,
          actions: [
            AppIconButton(
              icon: AppIcons.edit,
              semanticLabel: l10n.edit,
              onPressed: () => context.pushNamed(
                RouteNames.clientEdit,
                pathParameters: {RouteNames.idParam: clientId},
              ),
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pagePadding,
              AppSpacing.pagePadding,
              AppSpacing.pagePadding,
              AppSizes.fabClearance,
            ),
            children: [
              _ProfileCard(
                clientName: client.name,
                phone: client.phone,
                email: client.email,
                address: client.address,
                notes: client.notes,
                onCall: () => _handleCall(context, client.phone),
                onWhatsApp: () => _handleWhatsApp(context, client.phone),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              SectionHeader(title: l10n.dashboardFinancialSummary),
              const SizedBox(height: AppSpacing.sm),
              _FinancialSummaryGrid(finances: state.finances, format: format),
              const SizedBox(height: AppSpacing.sectionGap),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SectionHeader(title: l10n.clientInvoicesHeader),
                  ),
                  TextButton(
                    onPressed: () => context.pushNamed(RouteNames.invoiceNew),
                    child: Text(l10n.invoiceNewTitle),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              if (state.invoices.isEmpty)
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Center(
                    child: Text(
                      l10n.clientNoInvoices,
                      style: context.textStyles.bodyMedium?.copyWith(
                        color: context.appColors.textSecondary,
                      ),
                    ),
                  ),
                )
              else
                for (final inv in state.invoices) ...[
                  InvoiceListTile(
                    entry: InvoiceListEntry(
                      summary: inv,
                      status: InvoiceStatusResolver.resolve(
                        stage: inv.stage,
                        dueDate: inv.dueDate,
                        today: today,
                        totalMinor: inv.totalMinor,
                        paidMinor: inv.paidMinor,
                      ),
                    ),
                    onTap: () => context.pushNamed(
                      RouteNames.invoiceDetail,
                      pathParameters: {RouteNames.idParam: inv.id},
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleCall(BuildContext context, String phone) async {
    final l10n = context.l10n;
    if (phone.trim().isEmpty) {
      AppSnackbar.show(context, l10n.clientNoPhone);
      return;
    }
    final launched = await UrlLaunchService.callPhone(phone);
    if (!launched && context.mounted) {
      AppSnackbar.show(
        context,
        l10n.couldNotLaunchPhone,
        tone: AppSnackbarTone.error,
      );
    }
  }

  Future<void> _handleWhatsApp(BuildContext context, String phone) async {
    final l10n = context.l10n;
    if (phone.trim().isEmpty) {
      AppSnackbar.show(context, l10n.clientNoPhone);
      return;
    }
    final launched = await UrlLaunchService.openWhatsApp(phone);
    if (!launched && context.mounted) {
      AppSnackbar.show(
        context,
        l10n.couldNotLaunchWhatsApp,
        tone: AppSnackbarTone.error,
      );
    }
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.clientName,
    required this.phone,
    required this.email,
    required this.address,
    required this.notes,
    required this.onCall,
    required this.onWhatsApp,
  });

  final String clientName;
  final String phone;
  final String email;
  final String address;
  final String notes;
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarInitials(name: clientName, size: AppSizes.avatarLg),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clientName,
                      style: context.textStyles.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (phone.isNotEmpty)
                      Text(
                        phone,
                        style: context.textStyles.bodyMedium?.copyWith(
                          color: context.appColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  icon: AppIcons.phone,
                  label: l10n.clientActionCall,
                  variant: AppButtonVariant.secondary,
                  onPressed: onCall,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  icon: AppIcons.chat,
                  label: l10n.clientActionWhatsApp,
                  variant: AppButtonVariant.secondary,
                  onPressed: onWhatsApp,
                ),
              ),
            ],
          ),
          if (email.isNotEmpty || address.isNotEmpty || notes.isNotEmpty) ...[
            const Divider(height: AppSpacing.xl),
            if (email.isNotEmpty) ...[
              _InfoRow(icon: AppIcons.email, text: email),
              const SizedBox(height: AppSpacing.xs),
            ],
            if (address.isNotEmpty) ...[
              _InfoRow(icon: AppIcons.address, text: address),
              const SizedBox(height: AppSpacing.xs),
            ],
            if (notes.isNotEmpty) ...[
              _InfoRow(icon: AppIcons.info, text: notes),
            ],
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: context.appColors.textSecondary),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _FinancialSummaryGrid extends StatelessWidget {
  const _FinancialSummaryGrid({required this.finances, required this.format});

  final ClientFinancialSummary finances;
  final AppFormatters format;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: l10n.clientTotalBilled,
            amountMinor: finances.totalBilledMinor,
            currencyCode: finances.currencyCode,
            format: format,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatCard(
            label: l10n.clientTotalPaid,
            amountMinor: finances.totalPaidMinor,
            currencyCode: finances.currencyCode,
            format: format,
            backgroundColor: context.appColors.info.withValues(alpha: 0.10),
            borderColor: context.appColors.info.withValues(alpha: 0.35),
            textColor: context.appColors.info,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatCard(
            label: l10n.clientBalanceDue,
            amountMinor: finances.balanceMinor,
            currencyCode: finances.currencyCode,
            format: format,
            backgroundColor: finances.balanceMinor > 0
                ? context.appColors.danger.withValues(alpha: 0.10)
                : null,
            borderColor: finances.balanceMinor > 0
                ? context.appColors.danger.withValues(alpha: 0.35)
                : null,
            textColor: finances.balanceMinor > 0
                ? context.appColors.danger
                : null,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.amountMinor,
    required this.currencyCode,
    required this.format,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
  });

  final String label;
  final int amountMinor;
  final String currencyCode;
  final AppFormatters format;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: backgroundColor,
      borderColor: borderColor,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: context.textStyles.bodySmall?.copyWith(
              color: textColor != null
                  ? textColor!.withValues(alpha: 0.8)
                  : context.appColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          AmountText(
            minor: amountMinor,
            currencyCode: currencyCode,
            color: textColor,
          ),
        ],
      ),
    );
  }
}
