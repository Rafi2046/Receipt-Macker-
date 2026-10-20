import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_document_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../providers.dart';

/// A stored logo or signature on a white "paper" swatch, as it will print.
class ProfileImagePreview extends ConsumerWidget {
  const ProfileImagePreview({
    required this.relativePath,
    required this.semanticLabel,
    this.height = AppSizes.imagePreviewHeight,
    super.key,
  });

  final String relativePath;
  final String semanticLabel;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = ref.watch(profileImagePathProvider(relativePath)).value;
    return Container(
      height: height,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppDocumentColors.paper,
        borderRadius: AppRadius.card,
        border: Border.all(color: context.appColors.border),
      ),
      child: path == null
          ? const SizedBox.shrink()
          : Image.file(
              File(path),
              fit: BoxFit.contain,
              semanticLabel: semanticLabel,
              errorBuilder: (_, _, _) =>
                  Icon(AppIcons.error, color: context.appColors.danger),
            ),
    );
  }
}
