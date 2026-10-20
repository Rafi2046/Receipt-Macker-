import '../utils/app_logger.dart';
import 'failure.dart';

/// Success or failure of a repository call. Exceptions never reach Views.
sealed class Result<T> {
  const Result();

  /// Runs [body] and turns any thrown error into a [Failure].
  static Future<Result<T>> guard<T>(
    Future<T> Function() body, {
    Failure Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    try {
      return Ok(await body());
    } on Object catch (error, stackTrace) {
      AppLogger.error('Result.guard caught', error, stackTrace);
      return Err(
        onError?.call(error, stackTrace) ??
            UnexpectedFailure(cause: error, stackTrace: stackTrace),
      );
    }
  }

  bool get isOk => this is Ok<T>;

  T? get valueOrNull => switch (this) {
    Ok(:final value) => value,
    Err() => null,
  };
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}
