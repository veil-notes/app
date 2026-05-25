import 'package:flutter_test/flutter_test.dart';
import 'package:veil/features/veil/domain/password/default_password_validator.dart';
import 'package:veil/features/veil/domain/password/password_validation_result.dart';

void main() {
  final validator = DefaultPasswordValidator();

  group('DefaultPasswordValidator', () {
    test('rejects blank passwords', () {
      final result = validator.validate('   ');

      expect(result.isValid, isFalse);
      expect(result.error, PasswordValidationError.required);
    });

    test('rejects passwords shorter than 10 characters', () {
      final result = validator.validate('Abc123!');

      expect(result.isValid, isFalse);
      expect(result.error, PasswordValidationError.minLength);
    });

    test('rejects passwords without uppercase letters', () {
      final result = validator.validate('abcd1234!!');

      expect(result.isValid, isFalse);
      expect(result.error, PasswordValidationError.missingUppercase);
    });

    test('rejects passwords without lowercase letters', () {
      final result = validator.validate('ABCD1234!!');

      expect(result.isValid, isFalse);
      expect(result.error, PasswordValidationError.missingLowercase);
    });

    test('rejects passwords without numbers', () {
      final result = validator.validate('AbcdEfgh!!');

      expect(result.isValid, isFalse);
      expect(result.error, PasswordValidationError.missingNumber);
    });

    test('rejects passwords without special characters', () {
      final result = validator.validate('Abcd123456');

      expect(result.isValid, isFalse);
      expect(result.error, PasswordValidationError.missingSpecialChar);
    });

    test('accepts trimmed strong passwords', () {
      final result = validator.validate('  Abcd1234!!  ');

      expect(result.isValid, isTrue);
      expect(result.error, isNull);
    });
  });
}