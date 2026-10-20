import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/errors/failure.dart';
import 'package:receipt_maker/core/errors/result.dart';

void main() {
  test('guard wraps a value in Ok', () async {
    final result = await Result.guard(() async => 42);

    expect(result.isOk, isTrue);
    expect(result.valueOrNull, 42);
  });

  test('guard turns a throw into UnexpectedFailure by default', () async {
    final result = await Result.guard<int>(
      () async => throw StateError('boom'),
    );

    expect(result, isA<Err<int>>());
    expect((result as Err<int>).failure, isA<UnexpectedFailure>());
  });

  test('guard uses the onError mapper', () async {
    final result = await Result.guard<int>(
      () async => throw StateError('db'),
      onError: (e, s) => DatabaseFailure(cause: e, stackTrace: s),
    );

    expect((result as Err<int>).failure, isA<DatabaseFailure>());
  });
}
