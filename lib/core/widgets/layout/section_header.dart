import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_spacing.dart';

/// Section title with an optional trailing text action ("See all").
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final action = actionLabel;
    return Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(title, style: context.textStyles.titleMedium),
          ),
        ),
        if (action != null) ...[
          const SizedBox(width: AppSpacing.sm),
          TextButton(onPressed: onAction, child: Text(action)),
        ],
      ],
    );
  }
}
