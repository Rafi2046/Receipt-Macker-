import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../studio_scope.dart';

/// One icon revealed when the row is dragged to the left.
class StudioSwipeAction {
  const StudioSwipeAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
}

/// Reveals [actions] behind [child]. Drag left, release past halfway to lock.
class StudioSwipeRow extends StatefulWidget {
  const StudioSwipeRow({required this.child, required this.actions, super.key});

  final Widget child;
  final List<StudioSwipeAction> actions;

  @override
  State<StudioSwipeRow> createState() => _StudioSwipeRowState();
}

class _StudioSwipeRowState extends State<StudioSwipeRow> {
  double _offset = 0;

  double get _width => widget.actions.length * AppSizes.minTapTarget;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (final action in widget.actions) _Button(action: action),
              ],
            ),
          ),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _offset = (_offset + details.delta.dx).clamp(-_width, 0);
              });
            },
            onHorizontalDragEnd: (_) {
              setState(() => _offset = _offset < -_width / 2 ? -_width : 0);
            },
            child: ColoredBox(
              color: context.studio.surface,
              child: Transform.translate(
                offset: Offset(_offset, 0),
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({required this.action});

  final StudioSwipeAction action;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: action.label,
      child: SizedBox(
        width: AppSizes.minTapTarget,
        height: AppSizes.minTapTarget,
        child: IconButton(
          tooltip: action.label,
          onPressed: action.onPressed,
          icon: Icon(action.icon, color: action.color),
        ),
      ),
    );
  }
}
