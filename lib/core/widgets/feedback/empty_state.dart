import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../buttons/app_button.dart';
import 'empty_illustration.dart';

/// Centered animated illustration, title, message and an optional first action.
/// Scrolls instead of overflowing with large system fonts.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.actionIcon = AppIcons.add,
    this.onAction,
    this.iconColor,
    this.illustrated = true,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final IconData actionIcon;
  final VoidCallback? onAction;
  final Color? iconColor;

  /// The animated character wearing [icon]. False shows the plain icon,
  /// for errors.
  final bool illustrated;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final action = actionLabel;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSizes.emptyStateMaxWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (illustrated)
                EmptyIllustration(icon: icon)
              else
                Icon(
                  icon,
                  size: AppSizes.iconXl,
                  color: iconColor ?? colors.textSecondary,
                ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                style: context.textStyles.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: context.textStyles.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              if (action != null) ...[
                const SizedBox(height: AppSpacing.xl),
                AppButton(label: action, icon: actionIcon, onPressed: onAction),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
