import 'package:flutter/material.dart';

import '../../services/pdf/pdf_template.dart';

/// Clean miniature visual layout representation of an invoice template.
class MiniLayoutThumbnail extends StatelessWidget {
  const MiniLayoutThumbnail({
    required this.template,
    required this.accentColor,
    this.width = 48,
    this.height = 60,
    super.key,
  });

  final PdfTemplate template;
  final Color accentColor;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFD9DEE3), width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(3),
      child: switch (template) {
        PdfTemplate.classic => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 14, height: 3, color: const Color(0xFF56606B)),
                Container(width: 16, height: 3, color: accentColor),
              ],
            ),
            const SizedBox(height: 3),
            Container(height: 1, color: accentColor),
            const SizedBox(height: 4),
            Container(height: 3, color: accentColor),
            const SizedBox(height: 2),
            Container(height: 1.5, color: const Color(0xFFE2E8F0)),
            const SizedBox(height: 2),
            Container(height: 1.5, color: const Color(0xFFE2E8F0)),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Container(width: 20, height: 4, color: accentColor),
            ),
          ],
        ),
        PdfTemplate.minimal => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 12,
                  height: 2.5,
                  color: const Color(0xFF14181C),
                ),
                Container(
                  width: 12,
                  height: 2.5,
                  color: const Color(0xFF14181C),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Container(height: 0.8, color: const Color(0xFF14181C)),
            const SizedBox(height: 4),
            Container(height: 1.5, color: const Color(0xFF94A3B8)),
            const SizedBox(height: 2),
            Container(height: 1.5, color: const Color(0xFFCBD5E1)),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 18,
                height: 2.5,
                color: const Color(0xFF14181C),
              ),
            ),
          ],
        ),
        PdfTemplate.modern => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 2.5, color: accentColor),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 14, height: 4, color: const Color(0xFF14181C)),
                Container(
                  width: 12,
                  height: 2.5,
                  color: const Color(0xFF94A3B8),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 8,
                    color: accentColor.withValues(alpha: 0.15),
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Container(
                    height: 8,
                    color: accentColor.withValues(alpha: 0.15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Container(height: 2, color: const Color(0xFFF1F5F9)),
            const SizedBox(height: 1.5),
            Container(height: 2, color: Colors.white),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Container(width: 18, height: 2, color: accentColor),
            ),
          ],
        ),
        PdfTemplate.executive => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 12,
              color: accentColor,
              padding: const EdgeInsets.all(1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 12, height: 2, color: Colors.white),
                  Container(
                    width: 10,
                    height: 2,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ),
            Container(height: 1.2, color: const Color(0xFF2563EB)),
            const SizedBox(height: 3),
            Container(height: 2, color: const Color(0xFFE2E8F0)),
            const SizedBox(height: 2),
            Container(height: 2, color: const Color(0xFFE2E8F0)),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Container(width: 20, height: 4, color: accentColor),
            ),
          ],
        ),
        PdfTemplate.studio => Row(
          children: [
            Container(width: 3.5, color: accentColor),
            const SizedBox(width: 3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 10,
                    height: 2.5,
                    color: accentColor.withValues(alpha: 0.25),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 22,
                    height: 4,
                    color: const Color(0xFF14181C),
                  ),
                  const SizedBox(height: 4),
                  Container(height: 2, color: const Color(0xFFE2E8F0)),
                  const SizedBox(height: 2),
                  Container(height: 2, color: const Color(0xFFE2E8F0)),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 16,
                      height: 2.5,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        PdfTemplate.editorial => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 1, color: accentColor),
            const SizedBox(height: 1),
            Container(height: 0.5, color: accentColor),
            const SizedBox(height: 3),
            Center(
              child: Container(
                width: 18,
                height: 3,
                color: const Color(0xFF14181C),
              ),
            ),
            const SizedBox(height: 3),
            Container(height: 0.5, color: const Color(0xFFCBD5E1)),
            const SizedBox(height: 3),
            Container(height: 1.5, color: const Color(0xFFE2E8F0)),
            const SizedBox(height: 2),
            Container(height: 1.5, color: const Color(0xFFE2E8F0)),
            const Spacer(),
            Container(height: 0.5, color: accentColor),
            const SizedBox(height: 1),
            Container(height: 1, color: accentColor),
          ],
        ),
        PdfTemplate.compact => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 16, height: 2.5, color: accentColor),
                Container(
                  width: 14,
                  height: 2.5,
                  color: const Color(0xFF14181C),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Container(height: 1, color: accentColor),
            const SizedBox(height: 1.5),
            Container(height: 1.5, color: accentColor),
            for (var i = 0; i < 4; i++) ...[
              const SizedBox(height: 1),
              Container(
                height: 1.5,
                color: i.isEven ? const Color(0xFFF1F5F9) : Colors.white,
              ),
            ],
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Container(width: 18, height: 3, color: accentColor),
            ),
          ],
        ),
        PdfTemplate.ledger => Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF94A3B8), width: 0.8),
          ),
          padding: const EdgeInsets.all(1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 8,
                      color: Colors.white,
                      child: Center(
                        child: Container(
                          width: 8,
                          height: 2,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 0.8,
                    height: 8,
                    color: const Color(0xFF94A3B8),
                  ),
                  Expanded(
                    child: Container(
                      height: 8,
                      color: const Color(0xFFF1F5F9),
                      child: Center(
                        child: Container(
                          width: 8,
                          height: 2,
                          color: const Color(0xFF14181C),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(height: 0.8, color: const Color(0xFF94A3B8)),
              const SizedBox(height: 2),
              Container(height: 1.5, color: const Color(0xFFCBD5E1)),
              const SizedBox(height: 1.5),
              Container(height: 1.5, color: const Color(0xFFCBD5E1)),
              const Spacer(),
              Container(
                height: 4,
                color: accentColor.withValues(alpha: 0.2),
                child: Center(
                  child: Container(width: 14, height: 2, color: accentColor),
                ),
              ),
            ],
          ),
        ),
      },
    );
  }
}
