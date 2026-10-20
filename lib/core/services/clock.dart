import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils/calendar_date.dart';

part 'clock.g.dart';

/// The current time. Overridden in tests so dates and "overdue" are fixed.
@Riverpod(keepAlive: true)
DateTime Function() clock(Ref ref) => DateTime.now;

/// Today's calendar day in the phone's time zone.
extension ClockToday on DateTime Function() {
  CalendarDate today() => CalendarDate.fromLocal(this());
}
