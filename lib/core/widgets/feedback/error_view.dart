import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../utils/extensions/failure_message_extension.dart';
import '../../utils/extensions/l10n_extension.dart';
import 'empty_state.dart';

/// Error state with a localized message and an optional Retry.
class ErrorView extends StatelessWidget {
  const ErrorView({required String this.message, this.onRetry, super.key})
    : error = null;

  /// Picks the message from a [Failure] (or any error) for the current language.
  const ErrorView.fromError(Object this.error, {this.onRetry, super.key})
    : message = null;

  final String? message;
  final Object? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final retry = onRetry;
    return EmptyState(
      icon: AppIcons.error,
      iconColor: context.appColors.danger,
      title: l10n.errorTitle,
      message: message ?? l10n.messageFor(error),
      actionLabel: retry == null ? null : l10n.retry,
      actionIcon: AppIcons.retry,
      onAction: retry,
    );
  }
}
