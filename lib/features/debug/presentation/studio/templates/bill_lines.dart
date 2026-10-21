import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../studio_money.dart';
import '../studio_scope.dart';
import 'bill_colors.dart';
import 'bill_kinds.dart';
import 'bill_sample.dart';

/// The lines that fit on one page.
class BillLines extends StatelessWidget {
  const BillLines({
    required this.lines,
    required this.colors,
    required this.ruled,
    required this.paper,
    super.key,
  });

  final List<BillLine> lines;
  final BillColors colors;
  final bool ruled;
  final BillPaper paper;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final line in lines)
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ruled ? colors.ink : colors.line,
                  width: ruled ? 0.6 : 1,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        line.name,
                        style: context.studioType.label(colors.ink),
                      ),
                      if (!paper.isThermal)
                        Text(
                          line.detail,
                          style: context.studioType.label(colors.muted),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  studioMoney(context, line.totalMinor),
                  style: context.studioType.amountSm(colors.ink),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
