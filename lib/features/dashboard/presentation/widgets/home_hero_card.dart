import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../home_snapshot.dart';

/// Flagship financial showcase card:
/// Layered dark obsidian surface with subtle radial glow and accent rim,
/// prominent Outstanding balance with status pill, thin collection progress bar,
/// and side-by-side frosted glass sub-tiles for Invoiced vs Received.
class HomeHeroCard extends StatelessWidget {
  const HomeHeroCard({required this.snapshot, super.key});

  final HomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final money = format.currency(
      snapshot.outstandingMinor,
      snapshot.currencyCode,
    );

    // Collection progress ratio: received / invoiced this month
    final double collectionProgress = snapshot.invoicedMinor > 0
        ? (snapshot.receivedMinor / snapshot.invoicedMinor).clamp(0.0, 1.0)
        : (snapshot.outstandingMinor == 0 ? 1.0 : 0.0);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const RadialGradient(
          center: Alignment(-0.8, -0.9),
          radius: 1.4,
          colors: [Color(0xFF1E2838), Color(0xFF111722), Color(0xFF0A0E15)],
          stops: [0.0, 0.55, 1.0],
        ),
        border: Border.all(color: const Color(0xFF28354A)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Color(0x0F2563EB),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section: Outstanding Header & Status Pill
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.statOutstanding,
                          style: context.textStyles.labelMedium?.copyWith(
                            color: const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            money,
                            style: context.textStyles.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _StatusPill(snapshot: snapshot, format: format),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Thin collection progress bar
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: collectionProgress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF10B981)],
                      ),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: const [
                        BoxShadow(color: Color(0x6610B981), blurRadius: 4),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Bottom Section: This Month Invoiced vs Received Frosted Glass Sub-tiles
              Row(
                children: [
                  Expanded(
                    child: _FrostedSubTile(
                      label: l10n.homeStatInvoiced,
                      value: format.currency(
                        snapshot.invoicedMinor,
                        snapshot.currencyCode,
                      ),
                      accentColor: const Color(0xFF60A5FA),
                      icon: Icons.north_east_rounded,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _FrostedSubTile(
                      label: l10n.statReceived,
                      value: format.currency(
                        snapshot.receivedMinor,
                        snapshot.currencyCode,
                      ),
                      accentColor: const Color(0xFF34D399),
                      icon: Icons.south_west_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.snapshot, required this.format});

  final HomeSnapshot snapshot;
  final AppFormatters format;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (snapshot.overdueCount > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0x33FF5738),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0x66FF5738)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 13,
              color: Color(0xFFFF7053),
            ),
            const SizedBox(width: 4),
            Text(
              '${format.integer(snapshot.overdueCount)} ${l10n.statusOverdue.toLowerCase()}',
              style: const TextStyle(
                color: Color(0xFFFF9580),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    final isSettled = snapshot.outstandingMinor == 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0x2410B981),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x5510B981)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            size: 13,
            color: Color(0xFF34D399),
          ),
          const SizedBox(width: 4),
          Text(
            isSettled ? 'All settled' : 'Up to date',
            style: const TextStyle(
              color: Color(0xFF6EE7B7),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FrostedSubTile extends StatelessWidget {
  const _FrostedSubTile({
    required this.label,
    required this.value,
    required this.accentColor,
    required this.icon,
  });

  final String label;
  final String value;
  final Color accentColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: accentColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
