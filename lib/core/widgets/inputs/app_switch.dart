import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_durations.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';

/// The app's compact on/off switch: a slim pill track and a white thumb
/// that slides with a soft shadow. Brand-colored when on. The tap area
/// stays 48dp even though the switch itself is small.
class AppSwitch extends StatelessWidget {
  const AppSwitch({required this.value, required this.onChanged, super.key});

  final bool value;

  /// Null disables the switch.
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final enabled = onChanged != null;
    const inset = (AppSizes.switchHeight - AppSizes.switchThumb) / 2;
    return Semantics(
      toggled: value,
      enabled: enabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => onChanged!(!value) : null,
        child: SizedBox(
          width: AppSizes.minTapTarget,
          height: AppSizes.minTapTarget,
          child: Center(
            child: AnimatedOpacity(
              duration: AppDurations.fast,
              opacity: enabled ? 1 : 0.4,
              child: AnimatedContainer(
                duration: AppDurations.medium,
                curve: Curves.easeOutCubic,
                width: AppSizes.switchWidth,
                height: AppSizes.switchHeight,
                padding: const EdgeInsets.all(inset),
                decoration: BoxDecoration(
                  borderRadius: AppRadius.chip,
                  color: value ? colors.primary : colors.surfaceAlt,
                  border: Border.all(
                    color: value ? colors.primary : colors.border,
                  ),
                ),
                child: AnimatedAlign(
                  duration: AppDurations.medium,
                  curve: Curves.easeOutBack,
                  alignment: value
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: AppSizes.switchThumb - AppSizes.borderWidth * 2,
                    height: AppSizes.switchThumb - AppSizes.borderWidth * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // White in both themes, like a real toggle.
                      color: colors.onPanel,
                      boxShadow: [
                        BoxShadow(
                          color: colors.textPrimary.withValues(alpha: 0.18),
                          blurRadius: AppSizes.borderWidth * 3,
                          offset: const Offset(0, AppSizes.borderWidth),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
