import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../services/pdf/brand_swatch.dart';
import '../../services/pdf/pdf_template.dart';
import '../../utils/color_from_hex.dart';
import '../../utils/extensions/l10n_extension.dart';
import '../../utils/hex_color.dart';
import '../buttons/app_button.dart';
import '../inputs/app_text_field.dart';
import '../inputs/gradient_slider.dart';
import 'mini_layout_thumbnail.dart';

/// Bottom sheet to pick any accent color: hue and shade sliders plus a hex
/// code, with a live mini invoice. Returns `#RRGGBB`, or null if dismissed.
abstract final class CustomColorSheet {
  static Future<String?> show(
    BuildContext context, {
    required String initialHex,
    required PdfTemplate template,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: context.appColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xxl),
        ),
      ),
      builder: (_) => _Body(initialHex: initialHex, template: template),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.initialHex, required this.template});

  final String initialHex;
  final PdfTemplate template;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  static const double _minShade = 0.18;
  static const double _maxShade = 0.62;
  static const double _vivid = 0.72;

  late double _hue;
  late double _sat;
  late double _shade;
  late final TextEditingController _hexText;
  bool _invalid = false;

  String get _hex => HexColor.fromHsl(_hue, _sat, _shade);

  @override
  void initState() {
    super.initState();
    final start =
        HexColor.normalize(widget.initialHex) ?? BrandSwatch.coral.hex;
    final (h, s, l) = HexColor.toHsl(start);
    _hue = h;
    _sat = s;
    _shade = l.clamp(_minShade, _maxShade);
    _hexText = TextEditingController(text: _hex);
  }

  @override
  void dispose() {
    _hexText.dispose();
    super.dispose();
  }

  void _fromSliders({double? hue, double? shade}) {
    setState(() {
      _hue = hue ?? _hue;
      _shade = shade ?? _shade;
      // A grey has no visible hue; moving the hue slider brings color in.
      if (hue != null) _sat = math.max(_sat, _vivid);
      _invalid = false;
      _hexText.text = _hex;
    });
  }

  void _fromText(String text) {
    final hex = HexColor.normalize(text);
    setState(() {
      _invalid = hex == null;
      if (hex == null) return;
      final (h, s, l) = HexColor.toHsl(hex);
      _hue = h;
      _sat = s;
      _shade = l.clamp(_minShade, _maxShade);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = colorFromHex(_hex, fallback: context.appColors.primary);
    Color at(double h, double l) =>
        colorFromHex(HexColor.fromHsl(h, _sat, l), fallback: current);
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        0,
        AppSpacing.pagePadding,
        AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          _Header(template: widget.template, color: current, hex: _hex),
          _Label(l10n.customColorHue),
          GradientSlider(
            colors: [for (var h = 0; h <= 360; h += 30) at(h.toDouble(), 0.5)],
            value: _hue,
            max: 359,
            thumbColor: at(_hue, 0.5),
            semanticLabel: l10n.customColorHue,
            onChanged: (v) => _fromSliders(hue: v),
          ),
          _Label(l10n.customColorShade),
          GradientSlider(
            colors: [at(_hue, _minShade), at(_hue, 0.4), at(_hue, _maxShade)],
            value: _shade,
            min: _minShade,
            max: _maxShade,
            thumbColor: current,
            semanticLabel: l10n.customColorShade,
            onChanged: (v) => _fromSliders(shade: v),
          ),
          AppTextField(
            label: l10n.customColorHex,
            controller: _hexText,
            errorText: _invalid ? l10n.customColorInvalid : null,
            textInputAction: TextInputAction.done,
            onChanged: _fromText,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: l10n.customColorApply,
            expand: true,
            onPressed: _invalid ? null : () => Navigator.of(context).pop(_hex),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.template,
    required this.color,
    required this.hex,
  });

  final PdfTemplate template;
  final Color color;
  final String hex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MiniLayoutThumbnail(
          template: template,
          accentColor: color,
          width: AppSizes.colorPreviewWidth,
          height: AppSizes.colorPreviewHeight,
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.sm,
            children: [
              Text(
                context.l10n.accentCustomColor,
                style: context.textStyles.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                spacing: AppSpacing.sm,
                children: [
                  Container(
                    width: AppSizes.accentDot,
                    height: AppSizes.accentDot,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(hex, style: context.textStyles.titleMedium),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: context.textStyles.labelLarge?.copyWith(
      color: context.appColors.textSecondary,
    ),
  );
}
