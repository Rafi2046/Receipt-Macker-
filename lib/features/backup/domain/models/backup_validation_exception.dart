/// Thrown when a backup file fails pre-restore validation.
class BackupValidationException implements Exception {
  const BackupValidationException(this.message, {this.details});

  final String message;
  final String? details;

  @override
  String toString() => details == null
      ? 'BackupValidationException: $message'
      : '$message: $details';
}
