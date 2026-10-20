/// Why a field value is not accepted. Views map these to localized messages.
enum ValidationError {
  required,
  tooLong,
  invalidEmail,
  invalidPhone,
  invalidUrl,
}
