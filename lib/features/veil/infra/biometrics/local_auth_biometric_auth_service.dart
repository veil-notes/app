import 'package:local_auth/local_auth.dart';

import '../../domain/biometrics/biometric_auth_exception.dart';
import '../../domain/biometrics/biometric_auth_service.dart';

class LocalAuthBiometricAuthService implements BiometricAuthService {
  final LocalAuthentication _localAuthentication;
  final void Function()? _onAuthStarted;
  final void Function()? _onAuthFinished;

  LocalAuthBiometricAuthService(
    this._localAuthentication, {
    void Function()? onAuthStarted,
    void Function()? onAuthFinished,
  }) : _onAuthStarted = onAuthStarted,
       _onAuthFinished = onAuthFinished;

  @override
  Future<bool> isAvailable() async {
    final canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    final isDeviceSupported = await _localAuthentication.isDeviceSupported();

    return canCheckBiometrics && isDeviceSupported;
  }

  @override
  Future<bool> authenticate() async {
    _onAuthStarted?.call();

    try {
      return await _localAuthentication.authenticate(
        localizedReason: 'Authenticate to unlock your vault',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException catch (error) {
      switch (error.code) {
        case LocalAuthExceptionCode.userCanceled:
        case LocalAuthExceptionCode.systemCanceled:
        case LocalAuthExceptionCode.timeout:
          throw const BiometricCanceledException();

        case LocalAuthExceptionCode.noBiometricHardware:
        case LocalAuthExceptionCode.noBiometricsEnrolled:
        case LocalAuthExceptionCode.noCredentialsSet:
        case LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable:
        case LocalAuthExceptionCode.uiUnavailable:
          throw const BiometricUnavailableException();

        case LocalAuthExceptionCode.temporaryLockout:
        case LocalAuthExceptionCode.biometricLockout:
          throw const BiometricLockedOutException();

        case LocalAuthExceptionCode.userRequestedFallback:
          throw const BiometricCanceledException();

        default:
          throw const BiometricFailedException();
      }
    } finally {
      _onAuthFinished?.call();
    }
  }
}
