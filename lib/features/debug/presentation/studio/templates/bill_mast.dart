import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../studio_scope.dart';
import 'bill_colors.dart';
import 'bill_header_art.dart';
import 'bill_kinds.dart';

/// Seller and document title, arranged for one layout.
class BillMast extends StatelessWidget {
  const BillMast({
    required this.layout,
    required this.header,
    required this.colors,
    required this.title,
    required this.number,
    required this.seller,
    required this.detail,
    super.key,
  });

  final BillLayout layout;
  final BillHeader header;
  final BillColors colors;
  final String title;
  final String number;
  final String seller;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final onBrand = layout == BillLayout.band;
    final titleColor = onBrand ? colors.onBrand : colors.brand;
    final nameColor = onBrand ? colors.onBrand : colors.ink;
    final muted = onBrand ? colors.onBrand : colors.muted;
    final sellerBlock = _Party(
      name: seller,
      detail: detail,
      nameColor: nameColor,
      detailColor: muted,
    );
    final titleBlock = _Title(
      title: title,
      number: number,
      color: titleColor,
      align: layout == BillLayout.centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.end,
    );
    final body = switch (layout) {
      BillLayout.centered => Column(
        children: [
          titleBlock,
          const SizedBox(height: AppSpacing.sm),
          sellerBlock,
        ],
      ),
      BillLayout.split || BillLayout.statement => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: sellerBlock),
          const SizedBox(width: AppSpacing.sm),
          titleBlock,
        ],
      ),
      _ => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sellerBlock,
          const SizedBox(height: AppSpacing.sm),
          titleBlock,
        ],
      ),
    };
    return ColoredBox(
      color: onBrand ? colors.brand : colors.paper,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!onBrand)
            BillHeaderArt(header: header, colors: colors, onBrand: false),
          Padding(padding: const EdgeInsets.all(AppSpacing.md), child: body),
          if (onBrand)
            BillHeaderArt(header: header, colors: colors, onBrand: true),
          if (header == BillHeader.block && !onBrand)
            Container(height: AppSpacing.xs, color: colors.brand),
        ],
      ),
    );
  }
}

class _Party extends StatelessWidget {
  const _Party({
    required this.name,
    required this.detail,
    required this.nameColor,
    required this.detailColor,
  });

  final String name;
  final String detail;
  final Color nameColor;
  final Color detailColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: context.studioType.titleSm(nameColor)),
        Text(detail, style: context.studioType.label(detailColor)),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.title,
    required this.number,
    required this.color,
    required this.align,
  });

  final String title;
  final String number;
  final Color color;
  final CrossAxisAlignment align;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(title, style: context.studioType.title(color)),
        Text(number, style: context.studioType.label(color)),
      ],
    );
  }
}
