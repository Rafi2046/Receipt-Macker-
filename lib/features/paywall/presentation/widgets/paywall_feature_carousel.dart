import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/purchases/free_plan.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import 'paywall_slides.dart';

/// What Pro adds, one slide at a time. Swipe, or it moves on by itself.
class PaywallFeatureCarousel extends StatefulWidget {
  const PaywallFeatureCarousel({super.key});

  @override
  State<PaywallFeatureCarousel> createState() => _PaywallFeatureCarouselState();
}

class _PaywallFeatureCarouselState extends State<PaywallFeatureCarousel> {
  static const Duration _dwell = Duration(seconds: 4);
  static const double _artHeight = 170;
  static const int _count = 4;

  final _controller = PageController();
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_dwell, (_) {
      if (!_controller.hasClients) return;
      _controller.animateToPage(
        (_page + 1) % _count,
        duration: AppDurations.slow,
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final slides = <(Widget, String)>[
      (
        const TemplatesSlideArt(),
        l10n.paywallSlideTemplates(format.integer(FreePlan.designCount)),
      ),
      (const ColorsSlideArt(), l10n.paywallSlideColors),
      (const CleanSlideArt(), l10n.paywallSlideClean),
      (const UnlimitedSlideArt(), l10n.paywallSlideUnlimited),
    ];
    return Column(
      spacing: AppSpacing.md,
      children: [
        SizedBox(
          height: _artHeight,
          child: PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _page = i),
            children: [for (final (art, _) in slides) Center(child: art)],
          ),
        ),
        AnimatedSwitcher(
          duration: AppDurations.fast,
          child: Text(
            slides[_page].$2,
            key: ValueKey(_page),
            textAlign: TextAlign.center,
            style: context.textStyles.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppSpacing.xs,
          children: [
            for (var i = 0; i < _count; i++)
              AnimatedContainer(
                duration: AppDurations.fast,
                width: i == _page ? AppSpacing.lg : AppSpacing.sm,
                height: AppSpacing.sm,
                decoration: BoxDecoration(
                  color: i == _page ? colors.primary : colors.border,
                  borderRadius: AppRadius.chip,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
