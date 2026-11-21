import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import 'app_card.dart';

/// Rows of a form on one card, separated by hairlines.
class FormGroupCard extends StatelessWidget {
  const FormGroupCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, row) in children.indexed) ...[
            if (i > 0)
              const Divider(
                height: AppSizes.borderWidth,
                indent: AppSpacing.lg,
                endIndent: AppSpacing.lg,
              ),
            row,
          ],
        ],
      ),
    );
  }
}
