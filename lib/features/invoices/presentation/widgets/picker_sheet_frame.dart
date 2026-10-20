import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Tall bottom sheet with a title, actions on the right, and [body]
/// filling the rest (a searchable list).
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
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pagePadding,
              AppSpacing.sm,
              AppSpacing.sm,
              0,
            ),
            // Actions wrap under the title at large font sizes.
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(title, style: context.textStyles.titleMedium),
                Wrap(children: actions),
              ],
            ),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
