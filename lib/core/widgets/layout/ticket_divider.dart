import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// A dashed tear line with a notch at each end, like a ticket stub. Put it
/// in a card with no horizontal padding so the notches bite the edges.
class TicketDivider extends StatelessWidget {
  const TicketDivider({super.key});

  static const double _notchRadius = AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SizedBox(
      height: _notchRadius * 2,
      child: CustomPaint(
        painter: _TicketPainter(
          line: colors.border,
          notch: colors.background,
          radius: _notchRadius,
        ),
      ),
    );
  }
}

class _TicketPainter extends CustomPainter {
  _TicketPainter({
    required this.line,
    required this.notch,
    required this.radius,
  });

  final Color line;
  final Color notch;
  final double radius;

  static const double _dash = 6;
  static const double _gap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final stroke = Paint()
      ..color = line
      ..strokeWidth = AppSizes.borderWidth
      ..style = PaintingStyle.stroke;
    final end = size.width - radius - _gap;
    for (var x = radius + _gap; x < end; x += _dash + _gap) {
      canvas.drawLine(Offset(x, y), Offset(x + _dash, y), stroke);
    }
    for (final x in [0.0, size.width]) {
      canvas
        ..drawCircle(Offset(x, y), radius, Paint()..color = notch)
        ..drawCircle(Offset(x, y), radius, stroke);
    }
  }

  @override
  bool shouldRepaint(_TicketPainter old) =>
      old.line != line || old.notch != notch || old.radius != radius;
}
