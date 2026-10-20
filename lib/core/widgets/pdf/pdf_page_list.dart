import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_document_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// PDF pages (PNG images) as white sheets on the screen background,
/// pinch to zoom. The PDF itself is always white paper, in either theme.
class PdfPageList extends StatelessWidget {
  const PdfPageList({required this.pages, super.key});

  final List<Uint8List> pages;

  static const double _maxZoom = 4;

  @override
  Widget build(BuildContext context) {
    final shadow = context.appColors.border;
    return InteractiveViewer(
      maxScale: _maxZoom,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        itemCount: pages.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
        itemBuilder: (_, i) => DecoratedBox(
          decoration: BoxDecoration(
            // PDF margins are transparent; pages are always white paper.
            color: AppDocumentColors.paper,
            boxShadow: [
              BoxShadow(color: shadow, blurRadius: AppSizes.pageShadowBlur),
            ],
          ),
          child: Image.memory(
            pages[i],
            fit: BoxFit.fitWidth,
            gaplessPlayback: true,
            semanticLabel: '${i + 1}',
          ),
        ),
      ),
    );
  }
}
