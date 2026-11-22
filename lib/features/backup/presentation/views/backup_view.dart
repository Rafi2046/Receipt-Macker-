import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/calendar_date.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../../domain/models/backup_manifest.dart';
import '../view_models/backup_state.dart';
import '../view_models/backup_view_model.dart';

/// Backup & Restore view allowing users to export their database and media
/// into a .zip archive, or restore from a previously exported .zip backup.
class BackupView extends ConsumerWidget {
  const BackupView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(backupViewModelProvider);
    final locale = Localizations.localeOf(context).languageCode;
    final format = AppFormatters(locale);

    ref.listen<BackupState>(backupViewModelProvider, (prev, next) async {
      // 1. Error messages
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        AppSnackbar.show(context, switch (next.errorMessage) {
          BackupViewModel.errorNewer => l10n.backupErrorNewer,
          BackupViewModel.errorTooLarge => l10n.backupErrorTooLarge,
          BackupViewModel.errorFailed => l10n.backupErrorFailed,
          _ => l10n.backupErrorInvalid,
        }, tone: AppSnackbarTone.error);
        ref.read(backupViewModelProvider.notifier).clearFeedback();
      }

      // 2. Success messages
      if (next.successMessage != null &&
          next.successMessage != prev?.successMessage) {
        final text = next.successMessage == 'backupExportSuccess'
            ? l10n.backupExportSuccess
            : l10n.backupRestoreSuccess;
        AppSnackbar.show(context, text, tone: AppSnackbarTone.success);
        ref.read(backupViewModelProvider.notifier).clearFeedback();
      }

      // 3. Pending restore validation prompt
      if (next.pendingRestoreManifest != null &&
          prev?.pendingRestoreManifest == null) {
        final manifest = next.pendingRestoreManifest!;
        final confirmed = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) =>
              _RestoreConfirmationDialog(manifest: manifest, format: format),
        );
        if (confirmed == true) {
          await ref.read(backupViewModelProvider.notifier).confirmRestore();
        } else {
          ref.read(backupViewModelProvider.notifier).cancelPendingRestore();
        }
      }
    });

    return AppScaffold(
      title: l10n.backupTitle,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          AppSpacing.pagePadding,
          AppSpacing.pagePadding,
          AppSizes.fabClearance,
        ),
        children: [
          _ExportCard(
            state: state,
            format: format,
            onExport: () =>
                ref.read(backupViewModelProvider.notifier).createBackup(),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          _RestoreCard(
            state: state,
            onRestore: () => ref
                .read(backupViewModelProvider.notifier)
                .pickAndValidateBackup(),
          ),
        ],
      ),
    );
  }
}

class _ExportCard extends StatelessWidget {
  const _ExportCard({
    required this.state,
    required this.format,
    required this.onExport,
  });

  final BackupState state;
  final AppFormatters format;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lastDate = state.lastBackupDate;
    final lastDateText = lastDate != null
        ? l10n.backupLastDate(
            format.calendarDate(CalendarDate.fromLocal(lastDate)),
          )
        : l10n.backupNever;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                AppIcons.backup,
                color: context.appColors.primary,
                size: AppSizes.iconMd,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l10n.backupExportTitle,
                style: context.textStyles.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.backupExportDescription,
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            lastDateText,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.appColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: l10n.backupExportButton,
            icon: AppIcons.share,
            isLoading: state.isCreatingBackup,
            onPressed: state.isCreatingBackup || state.isRestoring
                ? null
                : onExport,
          ),
        ],
      ),
    );
  }
}

class _RestoreCard extends StatelessWidget {
  const _RestoreCard({required this.state, required this.onRestore});

  final BackupState state;
  final VoidCallback onRestore;

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
              Icon(
                AppIcons.restore,
                color: context.appColors.warning,
                size: AppSizes.iconMd,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l10n.backupRestoreTitle,
                style: context.textStyles.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.backupRestoreDescription,
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.appColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.sm),
              border: Border.all(
                color: context.appColors.warning.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  AppIcons.warning,
                  color: context.appColors.warning,
                  size: AppSizes.iconSm,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    l10n.backupRestoreWarning,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.appColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: l10n.backupRestoreButton,
            icon: AppIcons.download,
            variant: AppButtonVariant.secondary,
            isLoading: state.isRestoring,
            onPressed: state.isCreatingBackup || state.isRestoring
                ? null
                : onRestore,
          ),
        ],
      ),
    );
  }
}

class _RestoreConfirmationDialog extends StatelessWidget {
  const _RestoreConfirmationDialog({
    required this.manifest,
    required this.format,
  });

  final BackupManifest manifest;
  final AppFormatters format;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dateStr = format.calendarDate(
      CalendarDate.fromLocal(manifest.createdAt),
    );

    return AlertDialog(
      title: Text(l10n.backupConfirmRestoreTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.appColors.danger.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              child: Row(
                children: [
                  Icon(
                    AppIcons.warning,
                    color: context.appColors.danger,
                    size: AppSizes.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.backupConfirmWarning,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.appColors.danger,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _MetadataRow(
              icon: AppIcons.date,
              label: l10n.backupMetadataDate(dateStr),
            ),
            const SizedBox(height: AppSpacing.xs),
            _MetadataRow(
              icon: AppIcons.invoice,
              label: l10n.backupMetadataInvoices(manifest.invoiceCount),
            ),
            const SizedBox(height: AppSpacing.xs),
            _MetadataRow(
              icon: AppIcons.client,
              label: l10n.backupMetadataClients(manifest.clientCount),
            ),
            const SizedBox(height: AppSpacing.xs),
            _MetadataRow(
              icon: AppIcons.item,
              label: l10n.backupMetadataItems(manifest.itemCount),
            ),
            const SizedBox(height: AppSpacing.xs),
            _MetadataRow(
              icon: AppIcons.info,
              label: l10n.backupMetadataSchema(manifest.schemaVersion),
            ),
          ],
        ),
      ),
      actions: [
        AppButton(
          label: l10n.cancel,
          variant: AppButtonVariant.text,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        AppButton(
          label: l10n.backupConfirmButton,
          variant: AppButtonVariant.danger,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppSizes.iconSm,
          color: context.appColors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(label, style: context.textStyles.bodyMedium)),
      ],
    );
  }
}
