import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import 'bill_kinds.dart';
import 'bill_page.dart';
import 'bill_sample.dart';
import 'bill_template.dart';

/// A real first page, scaled to fit a gallery card.
class BillThumbnail extends StatelessWidget {
  const BillThumbnail({required this.template, super.key});

  final BillTemplate template;

  @override
  Widget build(BuildContext context) {
    const paper = BillPaper.a4;
    final pages = billPageCount(billSampleCount, paper.linesPerPage);
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.sm),
      child: ColoredBox(
        color: template.colors.paper,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
          child: BillPage(
            template: template,
            paper: paper,
            page: 0,
            pageCount: pages,
          ),
        ),
      ),
    );
  }
}
