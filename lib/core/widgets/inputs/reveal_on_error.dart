import 'package:flutter/widgets.dart';

/// Scrolls [child] into view when [errorText] appears, so a validation
/// line is not left under a Save bar while the keyboard is open.
class RevealOnError extends StatefulWidget {
  const RevealOnError({
    required this.errorText,
    required this.child,
    super.key,
  });

  final String? errorText;
  final Widget child;

  @override
  State<RevealOnError> createState() => _RevealOnErrorState();
}

class _RevealOnErrorState extends State<RevealOnError> {
  @override
  void didUpdateWidget(RevealOnError oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorText == null || widget.errorText == oldWidget.errorText) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Scrollable.ensureVisible(
        context,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      );
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
