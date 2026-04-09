import 'password_validation_result.dart';

abstract class PasswordValidator {
  PasswordValidationResult validate(String password);
}