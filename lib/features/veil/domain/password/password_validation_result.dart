enum PasswordValidationError {
  required,
  minLength,
  missingUppercase,
  missingLowercase,
  missingNumber,
  missingSpecialChar,
}

class PasswordValidationResult {
  final bool isValid;
  final PasswordValidationError? error;

  const PasswordValidationResult.valid() : isValid = true, error = null;

  const PasswordValidationResult.invalid(this.error) : isValid = false;
}
