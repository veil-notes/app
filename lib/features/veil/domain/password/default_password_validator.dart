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

    if (normalized.length < 10) {
      return const PasswordValidationResult.invalid(
        PasswordValidationError.minLength,
      );
    }

    final hasUppercase = RegExp(r'[A-Z]').hasMatch(normalized);
    if (!hasUppercase) {
      return const PasswordValidationResult.invalid(
        PasswordValidationError.missingUppercase,
      );
    }

    final hasLowercase = RegExp(r'[a-z]').hasMatch(normalized);
    if (!hasLowercase) {
      return const PasswordValidationResult.invalid(
        PasswordValidationError.missingLowercase,
      );
    }

    final hasNumber = RegExp(r'\d').hasMatch(normalized);
    if (!hasNumber) {
      return const PasswordValidationResult.invalid(
        PasswordValidationError.missingNumber,
      );
    }

    final hasSpecialChar = RegExp(
      r'[!@#$%^&*(),.?":{}|<>\[\]\\\/_\-+=~`]',
    ).hasMatch(normalized);
    if (!hasSpecialChar) {
      return const PasswordValidationResult.invalid(
        PasswordValidationError.missingSpecialChar,
      );
    }

    return const PasswordValidationResult.valid();
  }
}
