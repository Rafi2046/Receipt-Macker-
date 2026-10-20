import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_sizes.dart';

enum AppButtonVariant { primary, secondary, text, danger }

/// The app's one button. Pass `onPressed: null` to disable it.
/// While [isLoading], it shows a spinner and ignores taps.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.expand = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final callback = isLoading ? null : onPressed;
    final leading = isLoading
        ? const _ButtonSpinner()
        : (icon == null ? null : Icon(icon));
    final text = Text(label, textAlign: TextAlign.center);
    final colors = context.appColors;
    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton.icon(
        onPressed: callback,
        icon: leading,
        label: text,
      ),
      AppButtonVariant.secondary => OutlinedButton.icon(
        onPressed: callback,
        icon: leading,
        label: text,
      ),
      AppButtonVariant.text => TextButton.icon(
        onPressed: callback,
        icon: leading,
        label: text,
      ),
      AppButtonVariant.danger => FilledButton.icon(
        onPressed: callback,
        icon: leading,
        label: text,
        style: FilledButton.styleFrom(
          backgroundColor: colors.danger,
          foregroundColor: colors.onDanger,
        ),
      ),
    };
    final semantic = Semantics(liveRegion: isLoading, child: button);
    return expand
        ? SizedBox(width: double.infinity, child: semantic)
        : semantic;
  }
}

class _ButtonSpinner extends StatelessWidget {
  const _ButtonSpinner();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSizes.progressSm,
      child: CircularProgressIndicator(
        strokeWidth: AppSizes.progressStroke,
        color: IconTheme.of(context).color,
      ),
    );
  }
}
