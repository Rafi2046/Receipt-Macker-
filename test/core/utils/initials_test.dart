import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/initials.dart';

void main() {
  test('Latin names', () {
    expect(Initials.of('Rahim Uddin'), 'RU');
    expect(Initials.of('  rahim   uddin  khan '), 'RU');
    expect(Initials.of('Madonna'), 'M');
    expect(Initials.of(''), '');
  });

  test('Bangla names keep whole letters', () {
    expect(Initials.of('রহিম উদ্দিন'), 'রউ');
    expect(Initials.of('ক্ষমা রায়'), 'ক্ষরা');
    expect(Initials.of('শ্রাবন্তী'), 'শ্রা');
  });
}
