import 'password/password_validation_result.dart';

enum VeilExceptionCode {
  passwordValidation,
  invalidPassword,
  vaultNotConfigured,
  vaultAlreadyConfigured,
  encryptedPrivateKeyNotFound,
  publicKeyNotFound,
  vaultLocked,
}

class VeilException implements Exception {
  final VeilExceptionCode code;
  final PasswordValidationError? validationError;

  const VeilException(this.code, {this.validationError});

  const VeilException.passwordValidation(PasswordValidationError error)
    : this(VeilExceptionCode.passwordValidation, validationError: error);

  @override
  String toString() {
    return 'VeilException(code: $code, validationError: $validationError)';
  }
}
