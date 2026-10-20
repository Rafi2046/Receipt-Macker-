import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';

void main() {
  test('round-trips through the stored key', () {
    final d = CalendarDate(2026, 10, 20);
    expect(d.key, 20261020);
    expect(CalendarDate.fromKey(20261020), d);
  });

  test('adds days across months and years', () {
    expect(CalendarDate(2026, 12, 25).addDays(7), CalendarDate(2027, 1, 1));
    expect(CalendarDate(2028, 2, 28).addDays(1), CalendarDate(2028, 2, 29));
    expect(CalendarDate(2026, 3, 1).addDays(-1), CalendarDate(2026, 2, 28));
  });

  test('daysUntil and ordering', () {
    final a = CalendarDate(2026, 10, 20);
    final b = CalendarDate(2026, 11, 19);
    expect(a.daysUntil(b), 30);
    expect(b.daysUntil(a), -30);
    expect(a.isBefore(b), isTrue);
    expect(b.isAfter(a), isTrue);
    expect([b, a]..sort(), [a, b]);
  });

  test('fromLocal takes the local calendar day', () {
    expect(
      CalendarDate.fromLocal(DateTime(2026, 10, 20, 23, 59)),
      CalendarDate(2026, 10, 20),
    );
  });

  test('daysUntil is not affected by daylight saving', () {
    // UTC midnights inside, so a 23- or 25-hour local day never rounds wrong.
    expect(CalendarDate(2026, 3, 1).daysUntil(CalendarDate(2026, 4, 1)), 31);
  });
}
