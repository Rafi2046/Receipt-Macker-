import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';

/// A question that opens to show its answer.
class FaqTile extends StatefulWidget {
  const FaqTile({required this.question, required this.answer, super.key});

  final String question;
  final String answer;

  @override
  State<FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<FaqTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Semantics(
      expanded: _open,
      button: true,
      child: InkWell(
        onTap: () => setState(() => _open = !_open),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AppSizes.minTapTarget - AppSpacing.xl,
                ),
                child: Row(
                  spacing: AppSpacing.md,
                  children: [
                    Expanded(
                      child: Text(
                        widget.question,
                        style: context.textStyles.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _open ? 0.25 : 0,
                      duration: kThemeAnimationDuration,
                      child: Icon(
                        AppIcons.chevronRight,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSize(
                duration: kThemeAnimationDuration,
                alignment: Alignment.topCenter,
                child: _open
                    ? Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: Text(
                          widget.answer,
                          style: context.textStyles.bodyMedium?.copyWith(
                            color: colors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
