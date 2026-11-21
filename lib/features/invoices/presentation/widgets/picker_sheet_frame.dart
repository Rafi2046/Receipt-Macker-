import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_icon_button.dart';

/// Tall bottom sheet: a title with a close button, a row of [actions]
/// sharing the width, and [body] filling the rest (a searchable list).
class PickerSheetFrame extends StatelessWidget {
  const PickerSheetFrame({
    required this.title,
    required this.body,
    this.actions = const [],
    super.key,
  });

  final String title;
  final Widget body;
  final List<Widget> actions;

  /// Share of the screen height the sheet takes.
  static const double heightFactor = 0.9;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: heightFactor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: AppSpacing.pagePadding,
              end: AppSpacing.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(title, style: context.textStyles.titleLarge),
                ),
                AppIconButton(
                  icon: AppIcons.close,
                  semanticLabel: context.l10n.close,
                  filled: true,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          if (actions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.sm,
                AppSpacing.pagePadding,
                AppSpacing.md,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.sm,
                children: [
                  for (final action in actions) Expanded(child: action),
                ],
              ),
            ),
          const Divider(height: AppSizes.borderWidth),
          Expanded(child: body),
        ],
      ),
    );
  }
}
