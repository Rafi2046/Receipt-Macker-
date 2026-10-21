import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_durations.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../studio_money.dart';
import '../studio_palette.dart';
import '../studio_scope.dart';
import '../studio_snapshot.dart';

/// Six rounded bars. The selected month is the accent; the rest are quiet.
class StudioMonthChart extends StatefulWidget {
  const StudioMonthChart({
    required this.months,
    required this.selected,
    super.key,
  });

  final List<StudioSnapshot> months;
  final int selected;

  @override
  State<StudioMonthChart> createState() => _StudioMonthChartState();
}

class _StudioMonthChartState extends State<StudioMonthChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int? _tapped;

  @override
  void didUpdateWidget(StudioMonthChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) _tapped = null;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppDurations.slow);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (MediaQuery.disableAnimationsOf(context)) {
        _controller.value = 1;
      } else {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final locale = Localizations.localeOf(context).toString();
    final labels = [
      for (final month in widget.months)
        DateFormat.MMM(locale).format(month.month),
    ];
    final values = [for (final month in widget.months) month.invoicedMinor];
    final focus = _tapped ?? widget.selected;
    final amount = values.isEmpty
        ? ''
        : '${labels[focus]} · ${studioMoney(context, values[focus])}';
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) => _tapBar(details.localPosition.dx),
            child: Semantics(
              label: amount,
              child: SizedBox(
                height: StudioPalette.chartHeight,
                width: double.infinity,
                child: CustomPaint(
                  painter: _BarPainter(
                    values: values,
                    selected: focus,
                    progress: _controller.value,
                    accent: palette.accent,
                    muted: palette.chartMuted,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _Labels(labels: labels, selected: focus),
          if (amount.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(amount, style: context.studioType.amountSm(palette.ink)),
          ],
        ],
      ),
    );
  }

  void _tapBar(double dx) {
    final box = context.findRenderObject();
    if (box is! RenderBox || widget.months.isEmpty) return;
    final width = box.size.width;
    if (width <= 0) return;
    final index = (dx / (width / widget.months.length)).floor();
    if (index < 0 || index >= widget.months.length) return;
    setState(() => _tapped = index);
  }
}

class _Labels extends StatelessWidget {
  const _Labels({required this.labels, required this.selected});

  final List<String> labels;
  final int selected;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final type = context.studioType;
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++)
          Expanded(
            child: Text(
              labels[i],
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: type.label(i == selected ? palette.accent : palette.muted),
            ),
          ),
      ],
    );
  }
}

class _BarPainter extends CustomPainter {
  const _BarPainter({
    required this.values,
    required this.selected,
    required this.progress,
    required this.accent,
    required this.muted,
  });

  final List<int> values;
  final int selected;
  final double progress;
  final Color accent;
  final Color muted;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    if (maxValue <= 0) return;
    final slot = size.width / values.length;
    final barWidth = slot * 0.42;
    for (var i = 0; i < values.length; i++) {
      final height = size.height * (values[i] / maxValue) * progress;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          slot * i + (slot - barWidth) / 2,
          size.height - height,
          barWidth,
          height,
        ),
        const Radius.circular(AppSpacing.sm),
      );
      canvas.drawRRect(rect, Paint()..color = i == selected ? accent : muted);
    }
  }

  @override
  bool shouldRepaint(_BarPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.selected != selected;
}
