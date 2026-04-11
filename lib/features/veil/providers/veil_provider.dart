import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/crypto/crypto_service.dart';
import '../../../core/crypto/infra/kdf/argon2_kdf_derivation_service.dart';
import '../../../core/crypto/infra/pgp/pgp_crypto_service.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../core/storage/infra/flutter_secure_storage_service.dart';
import '../application/veil_controller.dart';
import '../application/veil_session_controller.dart';
import '../domain/password/default_password_validator.dart';
import '../domain/session/auto_lock_option.dart';
import '../domain/states/veil_state.dart';
import '../domain/vault_key_provider.dart';
import '../infra/biometrics/local_auth_biometric_auth_service.dart';
import '../infra/veil_state_service.dart';
import '../application/veil_service.dart';

class BiometricPromptInProgressNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void start() => state = true;

  void finish() => state = false;
}

final cryptoServiceProvider = Provider<CryptoService>((ref) {
  return PgpCryptoService();
});

final vaultKeyProviderProvider = Provider<VaultKeyProvider>((ref) {
  return ref.read(veilServiceProvider) as VaultKeyProvider;
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return FlutterSecureStorageService(const FlutterSecureStorage());
});

final veilServiceProvider = Provider<VeilService>((ref) {
  final secureStorage = ref.read(secureStorageServiceProvider);
  final cryptoService = ref.read(cryptoServiceProvider);

  final biometricAuthService = LocalAuthBiometricAuthService(
    LocalAuthentication(),
    onAuthStarted: () {
      ref.read(biometricPromptInProgressProvider.notifier).start();
    },
    onAuthFinished: () {
      ref.read(biometricPromptInProgressProvider.notifier).finish();
    },
  );

  return VeilStateService(
    keyDerivationService: Argon2KdfDerivationService(),
    secureStorageService: secureStorage,
    cryptoService: cryptoService,
    passwordValidator: DefaultPasswordValidator(),
    biometricAuthService: biometricAuthService,
  );
});

final isBiometricEnabledProvider = FutureProvider<bool>((ref) async {
  final veilService = ref.read(veilServiceProvider);
  return veilService.isBiometricEnabled();
});

final canUseBiometricUnlockProvider = FutureProvider<bool>((ref) async {
  final veilService = ref.read(veilServiceProvider);
  return veilService.canUseBiometricUnlock();
});

final veilControllerProvider = NotifierProvider<VeilController, VeilState>(
  VeilController.new,
);

final autoLockOptionProvider = FutureProvider<AutoLockOption>((ref) async {
  final veilService = ref.read(veilServiceProvider);
  return veilService.getAutoLockOption();
});

final veilSessionControllerProvider = Provider<VeilSessionController>((ref) {
  final controller = VeilSessionController(
    timeout: const Duration(minutes: 5),
    onTimeout: () {
      ref.read(veilControllerProvider.notifier).lock();
    },
  );

  ref.onDispose(controller.stop);

  return controller;
});

final biometricPromptInProgressProvider =
    NotifierProvider<BiometricPromptInProgressNotifier, bool>(
      BiometricPromptInProgressNotifier.new,
    );
