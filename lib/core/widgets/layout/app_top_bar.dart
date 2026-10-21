import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_durations.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../utils/extensions/l10n_extension.dart';
import 'top_bar_button.dart';

/// Page header that blends into the page. A tab root shows a large,
/// left-aligned title; a pushed screen shows a round back button and a
/// centered title. Once content scrolls under it ([scrolled]) the bar
/// takes the surface color and a hairline.
class AppTopBar extends StatelessWidget {
  const AppTopBar({
    required this.title,
    this.actions,
    this.scrolled = false,
    super.key,
  });

  final String title;
  final List<Widget>? actions;
  final bool scrolled;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    final barActions = actions ?? const <Widget>[];
    return AnimatedContainer(
      duration: AppDurations.medium,
      decoration: BoxDecoration(
        color: scrolled ? colors.surface : colors.background,
        border: Border(
          bottom: BorderSide(
            color: scrolled ? colors.border : colors.background,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: SizedBox(
            height: MediaQuery.textScalerOf(context)
                .scale(AppSizes.topBarHeight),
            child: canPop
                ? _PushedBar(title: title, actions: barActions)
                : _RootBar(title: title, actions: barActions),
          ),
        ),
      ),
    );
  }
}

class _RootBar extends StatelessWidget {
  const _RootBar({required this.title, required this.actions});

  final String title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.headlineSmall,
            ),
          ),
        ),
        ...actions,
      ],
    );
  }
}

class _PushedBar extends StatelessWidget {
  const _PushedBar({required this.title, required this.actions});

  final String title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return NavigationToolbar(
      middleSpacing: AppSpacing.sm,
      leading: TopBarButton(
        icon: AppIcons.back,
        semanticLabel: context.l10n.back,
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      middle: Semantics(
        header: true,
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: context.textStyles.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      trailing: actions.isEmpty
          ? null
          : Row(mainAxisSize: MainAxisSize.min, children: actions),
    );
  }
}
