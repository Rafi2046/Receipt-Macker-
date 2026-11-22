import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/features/dashboard/domain/models/day_part.dart';

void main() {
  test('splits the day at noon and 5 pm', () {
    DayPart at(int hour) => DayPart.at(DateTime(2026, 11, 22, hour, 30));
    expect(at(0), DayPart.morning);
    expect(at(11), DayPart.morning);
    expect(at(12), DayPart.afternoon);
    expect(at(16), DayPart.afternoon);
    expect(at(17), DayPart.evening);
    expect(at(23), DayPart.evening);
  });
}
