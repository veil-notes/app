class PasswordValidationResult {
  final bool isValid;
  final String? message;

  const PasswordValidationResult.valid()
      : isValid = true,
        message = null;

  const PasswordValidationResult.invalid(this.message)
      : isValid = false;
}