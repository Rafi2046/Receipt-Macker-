import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../utils/extensions/l10n_extension.dart';

/// Centered spinner with an optional message. Announced to screen readers.
/// Scrolls rather than overflowing in a small space at large font sizes.
class LoadingView extends StatelessWidget {
  const LoadingView({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final text = message;
    return Center(
      child: SingleChildScrollView(
        child: Semantics(
          label: text ?? context.l10n.loading,
          liveRegion: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (text != null) ...[
                const SizedBox(height: AppSpacing.md),
                ExcludeSemantics(
                  child: Text(text, style: context.textStyles.bodyMedium),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
