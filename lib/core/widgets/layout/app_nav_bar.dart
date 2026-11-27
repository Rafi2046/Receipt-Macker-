import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_opacity.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import 'nav_bar_create_button.dart';
import 'nav_bar_tab.dart';
import 'notched_dock_painter.dart';

/// Floating pill dock with a notch in the middle: two tabs, the create
/// button floating in the notch, two tabs. The selected tab gets a colored
/// circle that animates in.
class AppNavBar extends StatelessWidget {
  const AppNavBar({
    required this.index,
    required this.labels,
    required this.createLabel,
    required this.onSelected,
    required this.onCreate,
    super.key,
  }) : assert(labels.length == 4, 'The dock has exactly four tabs.');

  final int index;
  final List<String> labels;
  final String createLabel;
  final ValueChanged<int> onSelected;
  final VoidCallback onCreate;

  static const _icons = [
    AppIcons.dashboard,
    AppIcons.invoice,
    AppIcons.quote,
    AppIcons.clients,
  ];

  /// The notch leaves a small ring of space around the create button.
  static const double _notchRadius = AppSizes.navCreateSize / 2 + AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    Widget tab(int i) => Expanded(
      child: NavBarTab(
        icon: _icons[i],
        label: labels[i],
        selected: index == i,
        onTap: () => onSelected(i),
      ),
    );
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          0,
          AppSpacing.pagePadding,
          AppSpacing.md,
        ),
        child: SizedBox(
          height: AppSizes.navDockHeight + AppSizes.navCreateSize / 2,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                top: AppSizes.navCreateSize / 2,
                child: CustomPaint(
                  painter: NotchedDockPainter(
                    color: colors.surface,
                    borderColor: colors.border,
                    shadowColor: colors.shadowOf(AppOpacity.shadow * 3),
                    notchRadius: _notchRadius,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        tab(0),
                        tab(1),
                        const SizedBox(width: _notchRadius * 2),
                        tab(2),
                        tab(3),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: NavBarCreateButton(
                  tooltip: createLabel,
                  onPressed: onCreate,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
