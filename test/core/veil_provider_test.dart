import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_async/fake_async.dart';
import 'package:local_auth_platform_interface/local_auth_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:veil/core/crypto/crypto_service.dart';
import 'package:veil/core/crypto/domain/crypto_key_pair.dart';
import 'package:veil/core/crypto/domain/encrypted_data.dart';
import 'package:veil/features/veil/application/veil_controller.dart';
import 'package:veil/features/veil/application/veil_service.dart';
import 'package:veil/features/veil/domain/session/auto_lock_option.dart';
import 'package:veil/features/veil/domain/states/locked_state.dart';
import 'package:veil/features/veil/domain/states/veil_state.dart';
import 'package:veil/features/veil/domain/vault_key_provider.dart';
import 'package:veil/features/veil/providers/veil_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalAuthPlatform previousLocalAuthPlatform;
  late _FakeLocalAuthPlatform fakeLocalAuthPlatform;

  setUp(() {
    previousLocalAuthPlatform = LocalAuthPlatform.instance;
    fakeLocalAuthPlatform = _FakeLocalAuthPlatform();
    LocalAuthPlatform.instance = fakeLocalAuthPlatform;
  });

  tearDown(() {
    LocalAuthPlatform.instance = previousLocalAuthPlatform;
  });

  test('BiometricPromptInProgressNotifier toggles prompt state', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(biometricPromptInProgressProvider), isFalse);

    container.read(biometricPromptInProgressProvider.notifier).start();
    expect(container.read(biometricPromptInProgressProvider), isTrue);

    container.read(biometricPromptInProgressProvider.notifier).finish();
    expect(container.read(biometricPromptInProgressProvider), isFalse);
  });

  test('core providers expose the expected implementations', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(cryptoServiceProvider), isA<CryptoService>());
    expect(container.read(veilServiceProvider), isA<VeilService>());
  });

  test(
    'vaultKeyProviderProvider exposes the veil service as vault key provider',
    () {
      final service = _FakeVeilService();
      final container = ProviderContainer(
        overrides: [veilServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);

      final provider = container.read(vaultKeyProviderProvider);

      expect(provider, same(service));
    },
  );

  test(
    'future providers read biometric and auto-lock values from the service',
    () async {
      final service = _FakeVeilService(
        biometricEnabled: true,
        canUseBiometrics: true,
        autoLockOption: AutoLockOption.fifteenMinutes,
      );
      final container = ProviderContainer(
        overrides: [veilServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);

      expect(await container.read(isBiometricEnabledProvider.future), isTrue);
      expect(
        await container.read(canUseBiometricUnlockProvider.future),
        isTrue,
      );
      expect(
        await container.read(autoLockOptionProvider.future),
        AutoLockOption.fifteenMinutes,
      );
    },
  );

  test('veilSessionControllerProvider locks the veil on timeout', () {
    fakeAsync((async) {
      final controller = _FakeVeilController(_FakeVeilService());
      final container = ProviderContainer(
        overrides: [veilControllerProvider.overrideWith(() => controller)],
      );
      addTearDown(container.dispose);

      final sessionController = container.read(veilSessionControllerProvider);
      sessionController.updateTimeout(const Duration(seconds: 5));
      sessionController.start();
      async.elapse(const Duration(seconds: 5));

      expect(controller.lockCalls, 1);
    });
  });

  test(
    'veilServiceProvider toggles the biometric prompt notifier during auth',
    () async {
      FlutterSecureStorage.setMockInitialValues({
        'veil.biometric_enabled': 'true',
        'veil.biometric_passphrase': 'stored-passphrase',
        'veil.private_key_encrypted': 'encrypted-private-key',
      });

      fakeLocalAuthPlatform.canCheckBiometrics = true;
      fakeLocalAuthPlatform.deviceSupported = true;

      late ProviderContainer container;
      fakeLocalAuthPlatform.onAuthenticate = () async {
        expect(container.read(biometricPromptInProgressProvider), isTrue);
      };

      container = ProviderContainer(
        overrides: [
          cryptoServiceProvider.overrideWithValue(_FakeCryptoService()),
        ],
      );
      addTearDown(container.dispose);

      final service = container.read(veilServiceProvider);
      final unlocked = await service.unlockWithBiometrics();
      final vaultKeyProvider = container.read(vaultKeyProviderProvider);

      expect(unlocked, isTrue);
      expect(container.read(biometricPromptInProgressProvider), isFalse);
      expect(await vaultKeyProvider.getUnlockedPrivateKey(), 'private-key');
    },
  );
}

class _FakeVeilController extends VeilController {
  final _FakeVeilService service;
  int lockCalls = 0;

  _FakeVeilController(this.service);

  @override
  VeilState build() => LockedState(service);

  @override
  void lock() {
    lockCalls++;
  }
}

class _FakeVeilService implements VeilService, VaultKeyProvider {
  final bool biometricEnabled;
  final bool canUseBiometrics;
  final AutoLockOption autoLockOption;

  _FakeVeilService({
    this.biometricEnabled = false,
    this.canUseBiometrics = false,
    this.autoLockOption = AutoLockOption.fiveMinutes,
  });

  @override
  Future<bool> canUseBiometricUnlock() async => canUseBiometrics;

  @override
  Future<void> create(String password) async {}

  @override
  Future<void> disableBiometricUnlock() async {}

  @override
  Future<void> enableBiometricUnlock(String password) async {}

  @override
  Future<AutoLockOption> getAutoLockOption() async => autoLockOption;

  @override
  Future<String> getPublicKey() async => 'public-key';

  @override
  Future<String> getUnlockedPrivateKey() async => 'private-key';

  @override
  Future<bool> isBiometricEnabled() async => biometricEnabled;

  @override
  Future<bool> isConfigured() async => true;

  @override
  void lock() {}

  @override
  Future<void> setAutoLockOption(AutoLockOption option) async {}

  @override
  Future<bool> unlock(String password) async => true;

  @override
  Future<bool> unlockWithBiometrics() async => true;
}

class _FakeCryptoService implements CryptoService {
  @override
  Future<CryptoKeyPair> generateKeys() {
    throw UnimplementedError();
  }

  @override
  Future<String> decrypt(EncryptedData data, String privateKey) {
    throw UnimplementedError();
  }

  @override
  Future<String> decryptSymmetric(EncryptedData data, String passphrase) async {
    return 'private-key';
  }

  @override
  Future<EncryptedData> encrypt(String plainText, String publicKey) {
    throw UnimplementedError();
  }

  @override
  Future<EncryptedData> encryptSymmetric(String plainText, String passphrase) {
    throw UnimplementedError();
  }
}

class _FakeLocalAuthPlatform extends LocalAuthPlatform
    with MockPlatformInterfaceMixin {
  bool canCheckBiometrics = false;
  bool deviceSupported = false;
  Future<void> Function()? onAuthenticate;

  @override
  Future<bool> authenticate({
    required String localizedReason,
    required Iterable<AuthMessages> authMessages,
    AuthenticationOptions options = const AuthenticationOptions(),
  }) async {
    if (onAuthenticate != null) {
      await onAuthenticate!();
    }

    return true;
  }

  @override
  Future<bool> deviceSupportsBiometrics() async => canCheckBiometrics;

  @override
  Future<List<BiometricType>> getEnrolledBiometrics() async => [];

  @override
  Future<bool> isDeviceSupported() async => deviceSupported;

  @override
  Future<bool> stopAuthentication() async => true;
}
