import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../studio_icons.dart';
import '../studio_scope.dart';

/// Previous and next month. The label follows the app language.
class StudioMonthSwitcher extends StatelessWidget {
  const StudioMonthSwitcher({
    required this.month,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  final DateTime month;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final locale = Localizations.localeOf(context).toString();
    final label = DateFormat.yMMMM(locale).format(month);
    return Row(
      children: [
        _Arrow(icon: StudioIcons.chevronLeft, onPressed: onPrevious),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: context.studioType.titleSm(palette.ink),
          ),
        ),
        _Arrow(icon: StudioIcons.chevronRight, onPressed: onNext),
      ],
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: AppSizes.iconMd,
      icon: Icon(icon, color: context.studio.ink),
    );
  }
}
