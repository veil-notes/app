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

    test('rejects passwords shorter than 8 characters', () {
      final result = validator.validate('abc123');

      expect(result.isValid, isFalse);
      expect(result.error, PasswordValidationError.minLength);
    });

    test('rejects passwords without letters', () {
      final result = validator.validate('12345678');

      expect(result.isValid, isFalse);
      expect(result.error, PasswordValidationError.missingLetter);
    });

    test('rejects passwords without numbers', () {
      final result = validator.validate('abcdefgh');

      expect(result.isValid, isFalse);
      expect(result.error, PasswordValidationError.missingNumber);
    });

    test('accepts trimmed passwords with letters and numbers', () {
      final result = validator.validate('  abc12345  ');

      expect(result.isValid, isTrue);
      expect(result.error, isNull);
    });
  });
}
