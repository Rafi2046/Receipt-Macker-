import 'package:flutter/material.dart';

import '../../../../../core/constants/app_durations.dart';

/// Counts an amount up once. Reduced motion jumps to the final value.
class StudioCountUp extends StatefulWidget {
  const StudioCountUp({
    required this.minor,
    required this.style,
    required this.format,
    super.key,
  });

  final int minor;
  final TextStyle style;
  final String Function(int minor) format;

  @override
  State<StudioCountUp> createState() => _StudioCountUpState();
}

class _StudioCountUpState extends State<StudioCountUp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _curve;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppDurations.slow);
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _start();
    });
  }

  @override
  void didUpdateWidget(StudioCountUp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.minor != widget.minor) _start();
  }

  void _start() {
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
      return;
    }
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, _) {
        final shown = (widget.minor * _curve.value).round();
        return Text(widget.format(shown), style: widget.style);
      },
    );
  }
}
