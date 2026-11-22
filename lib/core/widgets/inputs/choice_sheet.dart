import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../layout/app_card.dart';

/// One option in a [ChoiceSheet]: its value, label and an optional icon.
typedef Choice<T> = ({T value, String label, IconData? icon});

/// Bottom sheet listing options in a card; the current one has a check.
/// Returns the picked value, or null when dismissed.
abstract final class ChoiceSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required List<Choice<T>> options,
    required T selected,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: context.appColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xxl),
        ),
      ),
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          0,
          AppSpacing.pagePadding,
          AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.md,
          children: [
            Text(
              title,
              style: context.textStyles.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final option in options)
                    _Row(
                      option: option,
                      selected: option.value == selected,
                      onTap: () => Navigator.of(context).pop(option.value),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row<T> extends StatelessWidget {
  const _Row({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final Choice<T> option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final icon = option.icon;
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              spacing: AppSpacing.md,
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    color: selected ? colors.primary : colors.textSecondary,
                  ),
                Expanded(
                  child: Text(
                    option.label,
                    style: context.textStyles.bodyLarge?.copyWith(
                      fontWeight: selected ? FontWeight.w700 : null,
                      color: selected ? colors.primary : colors.textPrimary,
                    ),
                  ),
                ),
                if (selected) Icon(AppIcons.check, color: colors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
