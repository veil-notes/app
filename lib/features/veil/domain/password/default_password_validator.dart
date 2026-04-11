import 'password_validation_result.dart';
import 'password_validator.dart';

class DefaultPasswordValidator implements PasswordValidator {
  @override
  PasswordValidationResult validate(String password) {
    final normalized = password.trim();

    if (normalized.isEmpty) {
      return const PasswordValidationResult.invalid(
        PasswordValidationError.required,
      );
    }

    if (normalized.length < 8) {
      return const PasswordValidationResult.invalid(
        PasswordValidationError.minLength,
      );
    }

    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(normalized);
    if (!hasLetter) {
      return const PasswordValidationResult.invalid(
        PasswordValidationError.missingLetter,
      );
    }

    final hasNumber = RegExp(r'\d').hasMatch(normalized);
    if (!hasNumber) {
      return const PasswordValidationResult.invalid(
        PasswordValidationError.missingNumber,
      );
    }

    return const PasswordValidationResult.valid();
  }
}
