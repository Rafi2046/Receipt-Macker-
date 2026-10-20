import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';

/// Large selectable card for one UI language.
class LanguageOptionCard extends StatelessWidget {
  const LanguageOptionCard({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(
            color: selected ? c.primary : c.border,
            width: selected
                ? AppSizes.selectedBorderWidth
                : AppSizes.borderWidth,
          ),
        ),
        child: InkWell(
          borderRadius: AppRadius.card,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSizes.languageCardHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Text(label, style: context.textStyles.titleMedium),
                  ),
                  if (selected) Icon(AppIcons.check, color: c.primary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
