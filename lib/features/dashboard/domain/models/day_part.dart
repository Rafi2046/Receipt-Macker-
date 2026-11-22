/// Part of the day, for the Home greeting.
enum DayPart {
  morning,
  afternoon,
  evening;

  /// Morning before noon, afternoon until 5 pm, then evening.
  static DayPart at(DateTime time) => switch (time.hour) {
    < 12 => DayPart.morning,
    < 17 => DayPart.afternoon,
    _ => DayPart.evening,
  };
}
