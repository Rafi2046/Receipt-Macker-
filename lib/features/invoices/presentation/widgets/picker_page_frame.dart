import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_bar_variant.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';

/// A full-screen picker: a back button and [title], a card of [actions]
/// (create new, one-off…), a [listTitle], then [body] (a searchable list).
/// Open it with [push]; pop it with the result.
class PickerPageFrame extends StatelessWidget {
  const PickerPageFrame({
    required this.title,
    required this.body,
    this.actions = const [],
    this.listTitle,
    super.key,
  });

  final String title;
  final Widget body;
  final List<Widget> actions;
  final String? listTitle;

  /// Pushes the page built by [builder]; resolves to what it pops with.
  static Future<T?> push<T>(BuildContext context, WidgetBuilder builder) =>
      Navigator.of(context).push<T>(MaterialPageRoute<T>(builder: builder));

  @override
  Widget build(BuildContext context) {
    final listTitle = this.listTitle;
    return AppScaffold(
      title: title,
      variant: AppBarVariant.pushed,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (actions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.sm,
                AppSpacing.pagePadding,
                AppSpacing.md,
              ),
              child: AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (i, action) in actions.indexed) ...[
                      if (i > 0)
                        const Divider(
                          height: AppSizes.borderWidth,
                          indent:
                              AppSpacing.lg + AppSizes.avatarMd + AppSpacing.md,
                          endIndent: AppSpacing.lg,
                        ),
                      action,
                    ],
                  ],
                ),
              ),
            ),
          if (listTitle != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.sm,
                AppSpacing.pagePadding,
                0,
              ),
              child: Text(
                listTitle.toUpperCase(),
                style: context.textStyles.labelMedium?.copyWith(
                  color: context.appColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
