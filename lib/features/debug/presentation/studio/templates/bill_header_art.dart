import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import 'bill_colors.dart';
import 'bill_kinds.dart';

/// Header decoration drawn with shapes. No artwork files.
class BillHeaderArt extends StatelessWidget {
  const BillHeaderArt({
    required this.header,
    required this.colors,
    required this.onBrand,
    super.key,
  });

  final BillHeader header;
  final BillColors colors;
  final bool onBrand;

  @override
  Widget build(BuildContext context) {
    final color = onBrand ? colors.onBrand : colors.brand;
    return switch (header) {
      BillHeader.plain || BillHeader.block => const SizedBox.shrink(),
      BillHeader.rule => Container(height: AppSpacing.xs, color: color),
      BillHeader.ribbon => Container(height: AppSpacing.sm, color: color),
      BillHeader.corner => SizedBox(
        height: AppSpacing.xxl,
        width: double.infinity,
        child: CustomPaint(painter: _CornerMark(color)),
      ),
      BillHeader.wave => SizedBox(
        height: AppSpacing.xxl,
        width: double.infinity,
        child: CustomPaint(painter: _Wave(color)),
      ),
    };
  }
}

class _CornerMark extends CustomPainter {
  const _CornerMark(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width - AppSpacing.xxxl, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, AppSpacing.xxl)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_CornerMark oldDelegate) => oldDelegate.color != color;
}

class _Wave extends CustomPainter {
  const _Wave(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.35)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height,
        size.width,
        size.height * 0.2,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_Wave oldDelegate) => oldDelegate.color != color;
}
