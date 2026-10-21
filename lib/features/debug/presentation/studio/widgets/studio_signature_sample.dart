import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../studio_scope.dart';
import 'studio_card.dart';

/// The saved signature, drawn as a stroke. Not a captured image.
class StudioSignatureSample extends StatelessWidget {
  const StudioSignatureSample({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    return StudioCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.signatureTitle,
            style: context.studioType.label(palette.muted),
          ),
          const SizedBox(height: AppSpacing.xs),
          SizedBox(
            height: AppSpacing.xxxl + AppSpacing.lg,
            width: double.infinity,
            child: CustomPaint(painter: _SignatureStroke(palette.ink)),
          ),
          Text(
            context.l10n.pdfSignature,
            style: context.studioType.label(palette.muted),
          ),
        ],
      ),
    );
  }
}

class _SignatureStroke extends CustomPainter {
  const _SignatureStroke(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.04, size.height * 0.62)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.05,
        size.width * 0.28,
        size.height * 0.95,
        size.width * 0.42,
        size.height * 0.48,
      )
      ..cubicTo(
        size.width * 0.52,
        size.height * 0.16,
        size.width * 0.6,
        size.height * 0.84,
        size.width * 0.78,
        size.height * 0.4,
      )
      ..quadraticBezierTo(
        size.width * 0.88,
        size.height * 0.22,
        size.width * 0.96,
        size.height * 0.46,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SignatureStroke oldDelegate) =>
      oldDelegate.color != color;
}
