import 'package:flutter/widgets.dart';

import '../studio/studio_shell.dart';

/// Debug route. Shows the high-fidelity Current mock, not the live screens.
class DesignDirectionsView extends StatelessWidget {
  const DesignDirectionsView({super.key});

  @override
  Widget build(BuildContext context) => const StudioShell();
}
