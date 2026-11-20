import 'package:flutter/material.dart';

import '../../services/pdf/brand_swatch.dart';
import 'invoice_preview_shared.dart';

/// The tones a premium preview paints with, matching the PDF's CSS colors.
class PreviewTones {
  const PreviewTones._(this.accent, this.soft, this.deep, this.pair);

  factory PreviewTones.of(Color accent) {
    final rgb = accent.toARGB32() & 0xFFFFFF;
    final hex = '#${rgb.toRadixString(16).padLeft(6, '0')}';
    return PreviewTones._(
      accent,
      Color.alphaBlend(accent.withValues(alpha: 0.1), InvoicePreviewInk.paper),
      _parse(BrandSwatch.deepFor(hex)),
      _parse(BrandSwatch.pairFor(hex)),
    );
  }

  final Color accent;
  final Color soft;
  final Color deep;
  final Color pair;

  static const Color onDark = InvoicePreviewInk.paper;
  static const Color onyx = Color(0xFF0B0F19);

  Gradient get gradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, deep],
  );

  static Color _parse(String hex) =>
      Color(0xFF000000 | (int.tryParse(hex.substring(1), radix: 16) ?? 0));
}

/// Bill-to and dates, the items, the totals and the signature: the part
/// every premium preview shares under its own header.
class PreviewBody extends StatelessWidget {
  const PreviewBody({
    required this.accent,
    this.tableColor,
    this.headerOnAccent = true,
    this.filledGrand = true,
    this.showParties = true,
    this.padding = const EdgeInsets.fromLTRB(8, 6, 8, 8),
    super.key,
  });

  final Color accent;

  /// Table head and total color when it differs from [accent].
  final Color? tableColor;
  final bool headerOnAccent;
  final bool filledGrand;
  final bool showParties;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final table = tableColor ?? accent;
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showParties) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: PreviewBillTo(accent: accent)),
                const PreviewMeta(),
              ],
            ),
            const SizedBox(height: 6),
          ],
          PreviewItemsTable(accent: table, headerOnAccent: headerOnAccent),
          const SizedBox(height: 6),
          PreviewTotals(accent: table, filledGrand: filledGrand),
          const Spacer(),
          const PreviewSignature(),
        ],
      ),
    );
  }
}

/// Cuts the lower edge of a header: a slant, a wave or a ribbon tail.
class PreviewEdgeClipper extends CustomClipper<Path> {
  const PreviewEdgeClipper.slant() : _kind = 0;
  const PreviewEdgeClipper.wave() : _kind = 1;
  const PreviewEdgeClipper.tail() : _kind = 2;

  final int _kind;

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()..lineTo(w, 0);
    switch (_kind) {
      case 0:
        path
          ..lineTo(w, h - 9)
          ..lineTo(0, h);
      case 1:
        path
          ..lineTo(w, h - 7)
          ..cubicTo(w * 0.6, h - 16, w * 0.3, h + 4, 0, h - 4);
      default:
        path
          ..lineTo(w - 8, h / 2)
          ..lineTo(w, h)
          ..lineTo(0, h);
    }
    return path..close();
  }

  @override
  bool shouldReclip(PreviewEdgeClipper oldClipper) => oldClipper._kind != _kind;
}
