/// Why a backup file was refused, so the screen can say it in the user's
/// language.
enum BackupProblem {
  /// Not a QuickBill backup, damaged, or missing parts.
  invalid,

  /// Made by a newer app version than this one.
  newerVersion,

  /// Larger than a backup can sensibly be.
  tooLarge,
}

/// Thrown when a backup file fails pre-restore validation. [message] and
/// [details] are for logs and tests; the UI shows text for [problem].
class BackupValidationException implements Exception {
  const BackupValidationException(
    this.message, {
    this.details,
    this.problem = BackupProblem.invalid,
  });

  final String message;
  final String? details;
  final BackupProblem problem;

  @override
  String toString() => details == null
      ? 'BackupValidationException: $message'
      : '$message: $details';
}
