import 'package:flutter/material.dart';

/// Ink for a paper design. These stay on the page, in light and dark app themes.
class BillColors {
  const BillColors({
    required this.ink,
    required this.muted,
    required this.paper,
    required this.brand,
    required this.soft,
    required this.line,
    required this.onBrand,
  });

  final Color ink;
  final Color muted;
  final Color paper;
  final Color brand;
  final Color soft;
  final Color line;
  final Color onBrand;

  static const bottle = BillColors(
    ink: Color(0xFF14181C),
    muted: Color(0xFF56606B),
    paper: Color(0xFFFFFFFF),
    brand: Color(0xFF006A4E),
    soft: Color(0xFFE6F2EE),
    line: Color(0xFFD9DEE3),
    onBrand: Color(0xFFFFFFFF),
  );

  static const inkOnly = BillColors(
    ink: Color(0xFF1A1C1E),
    muted: Color(0xFF5C656E),
    paper: Color(0xFFFFFCF8),
    brand: Color(0xFF1A1C1E),
    soft: Color(0xFFF3F0EA),
    line: Color(0xFFE4DFD6),
    onBrand: Color(0xFFFFFCF8),
  );

  static const sea = BillColors(
    ink: Color(0xFF13242B),
    muted: Color(0xFF4E6670),
    paper: Color(0xFFF7FBFC),
    brand: Color(0xFF0E5C6B),
    soft: Color(0xFFE3F2F5),
    line: Color(0xFFD3E2E6),
    onBrand: Color(0xFFF7FBFC),
  );

  static const clay = BillColors(
    ink: Color(0xFF2A211C),
    muted: Color(0xFF6E5E54),
    paper: Color(0xFFFFF8F3),
    brand: Color(0xFF8A4B2F),
    soft: Color(0xFFF8EBE3),
    line: Color(0xFFEADDD4),
    onBrand: Color(0xFFFFF8F3),
  );

  static const plum = BillColors(
    ink: Color(0xFF241826),
    muted: Color(0xFF6A5870),
    paper: Color(0xFFFCF8FC),
    brand: Color(0xFF6B3A78),
    soft: Color(0xFFF4E8F6),
    line: Color(0xFFE6D8EA),
    onBrand: Color(0xFFFCF8FC),
  );

  static const slate = BillColors(
    ink: Color(0xFF1C2430),
    muted: Color(0xFF5A6573),
    paper: Color(0xFFF8F9FB),
    brand: Color(0xFF2C3E50),
    soft: Color(0xFFE8EDF2),
    line: Color(0xFFD8DEE6),
    onBrand: Color(0xFFF8F9FB),
  );
}
