import 'dart:convert';

import 'stamp_placement.dart';

/// Circular rubber-stamp SVG for invoice status (Paid / Unpaid / …).
abstract final class StatusStampSvg {
  static const HtmlEscape _escape = HtmlEscape();

  /// Full overlay markup + placement class when [label] is non-empty.
  static String overlay({
    required String label,
    required StampPlacement placement,
  }) {
    final text = label.trim();
    if (text.isEmpty) return '';
    return '<div class="qb-status-stamp qb-stamp-${placement.id}" '
        'aria-hidden="true">${svg(text)}</div>';
  }

  /// Circular seal tinted with `currentColor` (set to brand accent in CSS).
  static String svg(String label) {
    final t = _escape.convert(label.trim().toUpperCase());
    // Long labels (e.g. Partially paid / Bangla) need a smaller center size.
    final centerSize = label.trim().length > 10 ? 22 : (label.trim().length > 6 ? 28 : 36);
    final arcSize = label.trim().length > 10 ? 9 : 11;
    return '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200" width="100%" height="100%">
  <defs>
    <filter id="qb-stamp-distress" x="-5%" y="-5%" width="110%" height="110%">
      <feTurbulence type="fractalNoise" baseFrequency="0.9" numOctaves="2" result="n"/>
      <feDisplacementMap in="SourceGraphic" in2="n" scale="1.4"/>
    </filter>
    <path id="qb-stamp-top" d="M 36,100 A 64,64 0 0 1 164,100" fill="none"/>
    <path id="qb-stamp-bot" d="M 164,100 A 64,64 0 0 1 36,100" fill="none"/>
  </defs>
  <g fill="none" stroke="currentColor" filter="url(#qb-stamp-distress)">
    <circle cx="100" cy="100" r="92" stroke-width="3"/>
    <circle cx="100" cy="100" r="84" stroke-width="1.5"/>
    <circle cx="100" cy="100" r="78" stroke-width="6" stroke-dasharray="8 5"/>
  </g>
  <g fill="currentColor" filter="url(#qb-stamp-distress)"
     font-family="'QB Sans','QB Bengali',sans-serif" font-weight="700"
     letter-spacing="1.5">
    <text font-size="$arcSize" text-anchor="middle">
      <textPath href="#qb-stamp-top" xlink:href="#qb-stamp-top" startOffset="50%">$t</textPath>
    </text>
    <text font-size="$arcSize" text-anchor="middle">
      <textPath href="#qb-stamp-bot" xlink:href="#qb-stamp-bot" startOffset="50%">$t</textPath>
    </text>
    <text x="100" y="112" font-size="$centerSize" text-anchor="middle">$t</text>
  </g>
</svg>''';
  }

  /// Placement + shared look for the circular stamp overlay.
  static String css() => '''
.qb-status-stamp { position: absolute; z-index: 50; pointer-events: none;
  width: 42mm; height: 42mm; color: var(--brand-accent); opacity: 0.82;
  transform: rotate(-18deg); }
.qb-stamp-center { top: 42%; left: 50%; margin-left: -21mm; margin-top: -21mm; }
.qb-stamp-topRight { top: 18mm; right: 8mm; left: auto; }
.qb-stamp-bottomRight { bottom: 28mm; top: auto; right: 8mm; left: auto; }
body { position: relative; }
''';
}
