import 'package:flutter_test/flutter_test.dart';
import 'package:veil/app/app_error_mapper.dart';
import 'package:veil/features/veil/domain/biometrics/biometric_auth_exception.dart';
import 'package:veil/features/veil/domain/password/password_validation_result.dart';
import 'package:veil/features/veil/domain/veil_exception.dart';
import 'package:veil/i18n/translations.g.dart';

void main() {
  const mapper = AppErrorMapper();
  final translations = Translations();

  group('AppErrorMapper', () {
    test('maps password validation errors', () {
      const error = VeilException.passwordValidation(
        PasswordValidationError.required,
      );

      final message = mapper.map(translations, error);

      expect(message, 'Password is required.');
    });

    test('maps invalid password errors', () {
      const error = VeilException(VeilExceptionCode.invalidPassword);

      final message = mapper.map(translations, error);

      expect(message, 'Invalid password.');
    });

    test('maps biometric errors', () {
      final message = mapper.map(
        translations,
        const BiometricUnavailableException(),
      );

      expect(message, 'Biometric authentication is not available.');
    });

    test('uses a generic fallback for unknown errors', () {
      final message = mapper.map(translations, Exception('boom'));

      expect(message, 'An unexpected error occurred.');
    });
  });
}
