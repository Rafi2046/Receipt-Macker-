import 'package:flutter/material.dart';

import '../../constants/app_icons.dart';
import '../../constants/app_spacing.dart';

enum AppSnackbarTone { info, success, error }

/// Short floating message at the bottom. Tone is shown by icon, not color alone.
abstract final class AppSnackbar {
  static void show(
    BuildContext context,
    String message, {
    AppSnackbarTone tone = AppSnackbarTone.info,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final label = actionLabel;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: _SnackContent(message: message, tone: tone),
          action: label == null
              ? null
              : SnackBarAction(label: label, onPressed: onAction ?? () {}),
        ),
      );
  }
}

class _SnackContent extends StatelessWidget {
  const _SnackContent({required this.message, required this.tone});

  final String message;
  final AppSnackbarTone tone;

  @override
  Widget build(BuildContext context) {
    final icon = switch (tone) {
      AppSnackbarTone.info => AppIcons.info,
      AppSnackbarTone.success => AppIcons.success,
      AppSnackbarTone.error => AppIcons.error,
    };
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.onInverseSurface),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(message)),
      ],
    );
  }
}
