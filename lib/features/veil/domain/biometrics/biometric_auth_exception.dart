sealed class BiometricAuthException implements Exception {
  final String message;

  const BiometricAuthException(this.message);

  @override
  String toString() => message;
}

class BiometricCanceledException extends BiometricAuthException {
  const BiometricCanceledException()
    : super('Biometric authentication was canceled.');
}

class BiometricUnavailableException extends BiometricAuthException {
  const BiometricUnavailableException()
    : super('Biometric authentication is not available.');
}

class BiometricLockedOutException extends BiometricAuthException {
  const BiometricLockedOutException()
    : super('Biometric authentication is temporarily locked.');
}

class BiometricFailedException extends BiometricAuthException {
  const BiometricFailedException() : super('Biometric authentication failed.');
}
