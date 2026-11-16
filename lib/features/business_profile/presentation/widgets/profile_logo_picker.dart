import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../view_models/profile_form_state.dart';
import '../view_models/profile_form_view_model.dart';
import 'profile_image_preview.dart';

/// Compact logo row: small square + change/remove — no tall empty card.
class ProfileLogoPicker extends ConsumerWidget {
  const ProfileLogoPicker({required this.form, super.key});

  final ProfileFormState form;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final vm = ref.read(profileFormViewModelProvider.notifier);
    final path = form.draft.logoPath;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Material(
            color: colors.surface.withValues(alpha: 0),
            child: InkWell(
              onTap: form.isPickingImage ? null : vm.pickLogo,
              borderRadius: AppRadius.card,
              child: path == null
                  ? _DashedLogoSlot(
                      busy: form.isPickingImage,
                      label: l10n.logoTitle,
                    )
                  : SizedBox.square(
                      dimension: AppSizes.logoPicker,
                      child: ProfileImagePreview(
                        relativePath: path,
                        semanticLabel: l10n.logoTitle,
                        height: AppSizes.logoPicker,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.logoTitle,
                  style: context.textStyles.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  l10n.logoHint,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: form.isPickingImage ? null : vm.pickLogo,
                      child: Text(path == null ? l10n.addLogo : l10n.change),
                    ),
                    if (path != null)
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: colors.danger,
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: vm.removeLogo,
                        child: Text(l10n.remove),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLogoSlot extends StatelessWidget {
  const _DashedLogoSlot({required this.busy, required this.label});

  final bool busy;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return CustomPaint(
      painter: _DashBorderPainter(color: colors.border),
      child: SizedBox.square(
        dimension: AppSizes.logoPicker,
        child: busy
            ? const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                AppIcons.business,
                color: colors.primary,
                size: AppSizes.iconMd,
                semanticLabel: label,
              ),
      ),
    );
  }
}

class _DashBorderPainter extends CustomPainter {
  _DashBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSizes.borderWidth;
    const dash = 5.0;
    const gap = 4.0;
    final r = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(AppRadius.md),
    );
    final path = Path()..addRRect(r);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dash;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}
