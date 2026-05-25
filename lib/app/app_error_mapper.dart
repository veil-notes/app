import '../features/veil/domain/biometrics/biometric_auth_exception.dart';
import '../features/veil/domain/password/password_validation_result.dart';
import '../features/veil/domain/veil_exception.dart';
import '../i18n/translations.g.dart';

class AppErrorMapper {
  const AppErrorMapper();

  String map(Translations t, Object error) {
    switch (error) {
      case VeilException():
        return _mapVeilError(t, error);
      case BiometricUnavailableException():
        return t.veil.errors.biometricUnavailable;
      case BiometricLockedOutException():
        return t.veil.errors.biometricLockedOut;
      case BiometricFailedException():
        return t.veil.errors.biometricFailed;
      default:
        return t.common.errors.unexpected;
    }
  }

  String _mapVeilError(Translations t, VeilException error) {
    switch (error.code) {
      case VeilExceptionCode.passwordValidation:
        return _mapPasswordValidation(t, error.validationError);
      case VeilExceptionCode.invalidPassword:
        return t.veil.errors.invalidPassword;
      case VeilExceptionCode.vaultNotConfigured:
        return t.veil.errors.vaultNotConfigured;
      case VeilExceptionCode.encryptedPrivateKeyNotFound:
        return t.veil.errors.encryptedPrivateKeyNotFound;
      case VeilExceptionCode.publicKeyNotFound:
        return t.veil.errors.publicKeyNotFound;
      case VeilExceptionCode.vaultLocked:
        return t.veil.errors.vaultLocked;
      case VeilExceptionCode.vaultAlreadyConfigured:
        return t.common.errors.unexpected;
    }
  }

  String _mapPasswordValidation(
    Translations t,
    PasswordValidationError? error,
  ) {
    switch (error) {
      case PasswordValidationError.required:
        return t.veil.errors.passwordRequired;
      case PasswordValidationError.minLength:
        return t.veil.errors.passwordMinLength;
      case PasswordValidationError.missingUppercase:
        return t.veil.errors.passwordMissingUppercase;
      case PasswordValidationError.missingLowercase:
        return t.veil.errors.passwordMissingLowercase;
      case PasswordValidationError.missingNumber:
        return t.veil.errors.passwordMissingNumber;
      case PasswordValidationError.missingSpecialChar:
        return t.veil.errors.passwordMissingSpecialChar;
      case null:
        return t.common.errors.unexpected;
    }
  }
}