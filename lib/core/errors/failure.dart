/// Why an operation failed. Views map these to localized messages.
sealed class Failure {
  const Failure({this.cause, this.stackTrace});

  final Object? cause;
  final StackTrace? stackTrace;
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure({super.cause, super.stackTrace});
}

final class StorageFailure extends Failure {
  const StorageFailure({super.cause, super.stackTrace});
}

final class ValidationFailure extends Failure {
  const ValidationFailure(this.field, {super.cause});

  final String field;
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure({super.cause});
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.cause, super.stackTrace});
}
