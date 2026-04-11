enum PasswordValidationError {
  required,
  minLength,
  missingLetter,
  missingNumber,
}

class PasswordValidationResult {
  final bool isValid;
  final PasswordValidationError? error;

  const PasswordValidationResult.valid() : isValid = true, error = null;

  const PasswordValidationResult.invalid(this.error) : isValid = false;
}
