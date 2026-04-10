import 'package:flutter_test/flutter_test.dart';
import 'package:veil/features/veil/domain/biometrics/biometric_auth_exception.dart';

void main() {
  test('biometric auth exceptions stringify to their message', () {
    const exceptions = [
      BiometricCanceledException(),
      BiometricUnavailableException(),
      BiometricLockedOutException(),
      BiometricFailedException(),
    ];

    for (final exception in exceptions) {
      expect(exception.toString(), exception.message);
    }
  });
}
