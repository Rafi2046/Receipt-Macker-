import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../studio_scope.dart';
import '../widgets/studio_page_header.dart';
import 'bill_kinds.dart';
import 'bill_page.dart';
import 'bill_sample.dart';
import 'bill_template.dart';

/// Full pages for one template, including thermal widths.
class BillPreviewView extends StatefulWidget {
  const BillPreviewView({
    required this.template,
    required this.selected,
    required this.onBack,
    required this.onUse,
    super.key,
  });

  final BillTemplate template;
  final bool selected;
  final VoidCallback onBack;
  final VoidCallback onUse;

  @override
  State<BillPreviewView> createState() => _BillPreviewViewState();
}

class _BillPreviewViewState extends State<BillPreviewView> {
  BillPaper _paper = BillPaper.a4;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.studio;
    final pages = billPageCount(billSampleCount, _paper.linesPerPage);
    return ColoredBox(
      color: palette.background,
      child: Column(
        children: [
          StudioPageHeader(title: widget.template.name, onBack: widget.onBack),
          _Papers(
            paper: _paper,
            onPaper: (paper) => setState(() => _paper = paper),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              itemCount: pages,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) => _Sheet(
                template: widget.template,
                paper: _paper,
                page: index,
                pageCount: pages,
              ),
            ),
          ),
          _UseBar(
            label: widget.selected ? l10n.studioTplUsing : l10n.studioTplUse,
            onPressed: widget.onUse,
          ),
        ],
      ),
    );
  }
}

class _Papers extends StatelessWidget {
  const _Papers({required this.paper, required this.onPaper});

  final BillPaper paper;
  final ValueChanged<BillPaper> onPaper;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = [
      l10n.studioPaperA4,
      l10n.studioPaperLetter,
      l10n.studioPaper58,
      l10n.studioPaper80,
    ];
    return SizedBox(
      height: AppSizes.buttonHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
        itemCount: BillPaper.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final selected = BillPaper.values[index] == paper;
          return FilterChip(
            label: Text(labels[index]),
            selected: selected,
            onSelected: (_) => onPaper(BillPaper.values[index]),
          );
        },
      ),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({
    required this.template,
    required this.paper,
    required this.page,
    required this.pageCount,
  });

  final BillTemplate template;
  final BillPaper paper;
  final int page;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: context.studio.cardShadows,
          border: Border.all(color: context.studio.cardBorder),
        ),
        child: BillPage(
          template: template,
          paper: paper,
          page: page,
          pageCount: pageCount,
        ),
      ),
    );
  }
}

class _UseBar extends StatelessWidget {
  const _UseBar({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    return ColoredBox(
      color: palette.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: SizedBox(
            width: double.infinity,
            height: AppSizes.buttonHeight,
            child: FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: palette.accent,
                foregroundColor: palette.onAccent,
              ),
              child: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}
