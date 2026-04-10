import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_platform_interface/local_auth_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:veil/features/veil/domain/biometrics/biometric_auth_exception.dart';
import 'package:veil/features/veil/infra/biometrics/local_auth_biometric_auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalAuthPlatform previousPlatform;
  late _FakeLocalAuthPlatform fakePlatform;
  late LocalAuthBiometricAuthService service;
  late int authStartedCount;
  late int authFinishedCount;

  setUp(() {
    previousPlatform = LocalAuthPlatform.instance;
    fakePlatform = _FakeLocalAuthPlatform();
    LocalAuthPlatform.instance = fakePlatform;
    authStartedCount = 0;
    authFinishedCount = 0;
    service = LocalAuthBiometricAuthService(
      LocalAuthentication(),
      onAuthStarted: () => authStartedCount++,
      onAuthFinished: () => authFinishedCount++,
    );
  });

  tearDown(() {
    LocalAuthPlatform.instance = previousPlatform;
  });

  test('isAvailable requires biometrics and supported device', () async {
    fakePlatform.canCheckBiometrics = true;
    fakePlatform.deviceSupported = true;

    expect(await service.isAvailable(), isTrue);

    fakePlatform.deviceSupported = false;
    expect(await service.isAvailable(), isFalse);
  });

  test('authenticate returns platform result and always calls callbacks', () async {
    fakePlatform.authenticateResult = true;

    expect(await service.authenticate(), isTrue);
    expect(authStartedCount, 1);
    expect(authFinishedCount, 1);
    expect(fakePlatform.lastLocalizedReason, 'Authenticate to unlock Veil');
  });

  test('authenticate maps cancel-related exceptions', () async {
    for (final code in [
      LocalAuthExceptionCode.userCanceled,
      LocalAuthExceptionCode.systemCanceled,
      LocalAuthExceptionCode.timeout,
      LocalAuthExceptionCode.userRequestedFallback,
    ]) {
      fakePlatform.exception = LocalAuthException(code: code);

      await expectLater(service.authenticate, throwsA(isA<BiometricCanceledException>()));
    }
  });

  test('authenticate maps unavailable-related exceptions', () async {
    for (final code in [
      LocalAuthExceptionCode.noBiometricHardware,
      LocalAuthExceptionCode.noBiometricsEnrolled,
      LocalAuthExceptionCode.noCredentialsSet,
      LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable,
      LocalAuthExceptionCode.uiUnavailable,
    ]) {
      fakePlatform.exception = LocalAuthException(code: code);

      await expectLater(
        service.authenticate,
        throwsA(isA<BiometricUnavailableException>()),
      );
    }
  });

  test('authenticate maps lockout and unknown failures', () async {
    fakePlatform.exception = const LocalAuthException(
      code: LocalAuthExceptionCode.temporaryLockout,
    );
    await expectLater(
      service.authenticate,
      throwsA(isA<BiometricLockedOutException>()),
    );

    fakePlatform.exception = const LocalAuthException(
      code: LocalAuthExceptionCode.unknownError,
    );
    await expectLater(
      service.authenticate,
      throwsA(isA<BiometricFailedException>()),
    );
  });
}

class _FakeLocalAuthPlatform extends LocalAuthPlatform
    with MockPlatformInterfaceMixin {
  bool canCheckBiometrics = false;
  bool deviceSupported = false;
  bool authenticateResult = false;
  LocalAuthException? exception;
  String? lastLocalizedReason;

  @override
  Future<bool> authenticate({
    required String localizedReason,
    required Iterable<AuthMessages> authMessages,
    AuthenticationOptions options = const AuthenticationOptions(),
  }) async {
    lastLocalizedReason = localizedReason;

    if (exception != null) {
      throw exception!;
    }

    return authenticateResult;
  }

  @override
  Future<bool> deviceSupportsBiometrics() async => canCheckBiometrics;

  @override
  Future<bool> isDeviceSupported() async => deviceSupported;

  @override
  Future<List<BiometricType>> getEnrolledBiometrics() async => [];

  @override
  Future<bool> stopAuthentication() async => true;
}
