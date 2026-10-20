/// A day on the calendar (issue date, due date), with no time or time zone,
/// so it never shifts by a day when the phone's time zone changes.
/// Stored as an integer `yyyymmdd`.
class CalendarDate implements Comparable<CalendarDate> {
  CalendarDate(int year, int month, int day)
    : this._(DateTime.utc(year, month, day));

  /// The local calendar day of [value] (e.g. from a date picker or now).
  factory CalendarDate.fromLocal(DateTime value) {
    final local = value.toLocal();
    return CalendarDate(local.year, local.month, local.day);
  }

  /// From the stored `yyyymmdd` form.
  factory CalendarDate.fromKey(int key) =>
      CalendarDate(key ~/ _yearFactor, key ~/ _monthFactor % 100, key % 100);

  const CalendarDate._(this._utcMidnight);

  static const int _yearFactor = 10000;
  static const int _monthFactor = 100;

  /// Normalized (day overflow rolls into the next month).
  final DateTime _utcMidnight;

  int get year => _utcMidnight.year;
  int get month => _utcMidnight.month;
  int get day => _utcMidnight.day;

  /// `yyyymmdd`, sortable.
  int get key => year * _yearFactor + month * _monthFactor + day;

  /// Midnight at the start of this day in local time, for date pickers
  /// and formatting.
  DateTime toLocalDateTime() => DateTime(year, month, day);

  CalendarDate addDays(int days) => CalendarDate(year, month, day + days);

  /// Whole days from this date to [other] (negative when [other] is earlier).
  int daysUntil(CalendarDate other) =>
      other._utcMidnight.difference(_utcMidnight).inDays;

  bool isBefore(CalendarDate other) => key < other.key;

  bool isAfter(CalendarDate other) => key > other.key;

  @override
  int compareTo(CalendarDate other) => key.compareTo(other.key);

  @override
  bool operator ==(Object other) => other is CalendarDate && other.key == key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() =>
      '$year-${'$month'.padLeft(2, '0')}-${'$day'.padLeft(2, '0')}';
}
