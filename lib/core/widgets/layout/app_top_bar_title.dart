import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

/// Title (+ optional subtitle) block used inside AppBar variants.
class AppTopBarTitle extends StatelessWidget {
  const AppTopBarTitle({
    required this.title,
    this.subtitle,
    this.large = false,
    this.subtitleAbove = false,
    this.align = TextAlign.start,
    this.showTitle = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool large;

  /// When true (Home), [subtitle] renders above [title] (e.g. greeting).
  final bool subtitleAbove;
  final TextAlign align;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    if (!showTitle) {
      return Semantics(header: true, label: title, child: const SizedBox());
    }
    final subtitleText = subtitle;
    final titleStyle = large
        ? context.textStyles.headlineSmall?.copyWith(fontWeight: FontWeight.w700)
        : context.textStyles.titleMedium?.copyWith(fontWeight: FontWeight.w700);
    final sub = subtitleText != null && subtitleText.isNotEmpty
        ? Text(
            subtitleText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: align,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.appColors.textSecondary,
            ),
          )
        : null;
    final main = Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: align,
      style: titleStyle,
    );
    return Semantics(
      header: true,
      child: Column(
        crossAxisAlignment: align == TextAlign.center
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (subtitleAbove && sub != null) sub,
          main,
          if (!subtitleAbove && sub != null) sub,
        ],
      ),
    );
  }
}
