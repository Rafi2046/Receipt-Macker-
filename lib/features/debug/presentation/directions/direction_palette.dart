import 'package:flutter/material.dart';

/// One proposed look. Widgets read these fields and never pick their own colors.
enum DirectionKind { ledger, current, atelier }

@immutable
class DirectionPalette {
  const DirectionPalette({
    required this.background,
    required this.surface,
    required this.ink,
    required this.muted,
    required this.line,
    required this.accent,
    required this.onAccent,
    required this.gold,
    required this.paid,
    required this.partial,
    required this.overdue,
    required this.draft,
    required this.sent,
    required this.radius,
    required this.softShadow,
    required this.filledHero,
  });

  final Color background, surface, ink, muted, line;
  final Color accent, onAccent, gold;
  final Color paid, partial, overdue, draft, sent;
  final double radius;
  final bool softShadow;
  final bool filledHero;

  Color wash(Color color) => color.withValues(alpha: 0.14);

  static DirectionPalette of(DirectionKind kind, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return switch (kind) {
      DirectionKind.ledger => dark ? _ledgerDark : _ledgerLight,
      DirectionKind.current => dark ? _currentDark : _currentLight,
      DirectionKind.atelier => dark ? _atelierDark : _atelierLight,
    };
  }

  static const DirectionPalette _ledgerLight = DirectionPalette(
    background: Color(0xFFF6F4EF),
    surface: Color(0xFFFFFCF8),
    ink: Color(0xFF1C1915),
    muted: Color(0xFF6F6A62),
    line: Color(0xFFE4DFD6),
    accent: Color(0xFF0C3B2E),
    onAccent: Color(0xFFFFFCF8),
    gold: Color(0xFFB0893E),
    paid: Color(0xFF1B6B45),
    partial: Color(0xFF8A5A12),
    overdue: Color(0xFF9F2D2D),
    draft: Color(0xFF6F6A62),
    sent: Color(0xFF1E4D7B),
    radius: 10,
    softShadow: false,
    filledHero: false,
  );

  static const DirectionPalette _ledgerDark = DirectionPalette(
    background: Color(0xFF12110E),
    surface: Color(0xFF1C1A16),
    ink: Color(0xFFF4F0E6),
    muted: Color(0xFFA39E93),
    line: Color(0xFF2E2B26),
    accent: Color(0xFF8FCBB2),
    onAccent: Color(0xFF08241C),
    gold: Color(0xFFE2C27A),
    paid: Color(0xFF7DCEA0),
    partial: Color(0xFFE0B15A),
    overdue: Color(0xFFF0A0A0),
    draft: Color(0xFFA39E93),
    sent: Color(0xFF8EB4E0),
    radius: 10,
    softShadow: false,
    filledHero: false,
  );

  static const DirectionPalette _currentLight = DirectionPalette(
    background: Color(0xFFF3F5F7),
    surface: Color(0xFFFFFFFF),
    ink: Color(0xFF101418),
    muted: Color(0xFF5C6770),
    line: Color(0xFFE3E8ED),
    accent: Color(0xFF006A4E),
    onAccent: Color(0xFFFFFFFF),
    gold: Color(0xFFE0A100),
    paid: Color(0xFF157A45),
    partial: Color(0xFFB45309),
    overdue: Color(0xFFB42318),
    draft: Color(0xFF5C6770),
    sent: Color(0xFF1D4ED8),
    radius: 20,
    softShadow: true,
    filledHero: true,
  );

  static const DirectionPalette _currentDark = DirectionPalette(
    background: Color(0xFF0E1114),
    surface: Color(0xFF1A1F24),
    ink: Color(0xFFF2F5F7),
    muted: Color(0xFF9AA3AB),
    line: Color(0xFF2A3138),
    accent: Color(0xFF3DDC97),
    onAccent: Color(0xFF06281C),
    gold: Color(0xFFF5C542),
    paid: Color(0xFF3DDC97),
    partial: Color(0xFFF5C542),
    overdue: Color(0xFFFF8A80),
    draft: Color(0xFF9AA3AB),
    sent: Color(0xFF8EB4FF),
    radius: 20,
    softShadow: false,
    filledHero: true,
  );

  static const DirectionPalette _atelierLight = DirectionPalette(
    background: Color(0xFFEFEDE7),
    surface: Color(0xFFFBF9F4),
    ink: Color(0xFF24302A),
    muted: Color(0xFF667069),
    line: Color(0xFFE3DDD2),
    accent: Color(0xFF2F6D52),
    onAccent: Color(0xFFFBF9F4),
    gold: Color(0xFFA7842F),
    paid: Color(0xFF2F6D52),
    partial: Color(0xFF8A6232),
    overdue: Color(0xFF8E3B3B),
    draft: Color(0xFF667069),
    sent: Color(0xFF3D5A73),
    radius: 16,
    softShadow: false,
    filledHero: false,
  );

  static const DirectionPalette _atelierDark = DirectionPalette(
    background: Color(0xFF161815),
    surface: Color(0xFF22261F),
    ink: Color(0xFFECE8DF),
    muted: Color(0xFFA8A99A),
    line: Color(0xFF32382F),
    accent: Color(0xFF8FCBAA),
    onAccent: Color(0xFF14241C),
    gold: Color(0xFFE2C27A),
    paid: Color(0xFF8FCBAA),
    partial: Color(0xFFE2C27A),
    overdue: Color(0xFFF0B4B4),
    draft: Color(0xFFA8A99A),
    sent: Color(0xFFB7C7D6),
    radius: 16,
    softShadow: false,
    filledHero: false,
  );
}
