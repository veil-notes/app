import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:veil/core/crypto/crypto_service.dart';
import 'package:veil/core/crypto/domain/crypto_key_pair.dart';
import 'package:veil/core/crypto/domain/derived_key.dart';
import 'package:veil/core/crypto/domain/encrypted_data.dart';
import 'package:veil/core/crypto/domain/kdf_params.dart';
import 'package:veil/core/crypto/key_derivation_service.dart';
import 'package:veil/core/storage/secure_storage_service.dart';
import 'package:veil/features/veil/domain/biometrics/biometric_auth_exception.dart';
import 'package:veil/features/veil/domain/biometrics/biometric_auth_service.dart';
import 'package:veil/features/veil/domain/password/password_validation_result.dart';
import 'package:veil/features/veil/domain/password/password_validator.dart';
import 'package:veil/features/veil/domain/session/auto_lock_option.dart';
import 'package:veil/features/veil/domain/veil_exception.dart';
import 'package:veil/features/veil/infra/veil_state_service.dart';

void main() {
  group('VeilStateService', () {
    test('isConfigured requires all persisted fields', () async {
      final storage = _FakeSecureStorageService();
      final service = _buildService(storage: storage);

      expect(await service.isConfigured(), isFalse);

      storage.values['veil.kdf_params'] = '{}';
      storage.values['veil.public_key'] = 'public';
      storage.values['veil.private_key_encrypted'] = 'encrypted';

      expect(await service.isConfigured(), isTrue);
    });

    test(
      'create validates password, persists keys and unlocks memory',
      () async {
        final storage = _FakeSecureStorageService();
        final crypto = _FakeCryptoService();
        final service = _buildService(
          storage: storage,
          crypto: crypto,
          random: _FixedRandom(),
        );

        await service.create('abc12345');

        expect(storage.values['veil.kdf_params'], isNotNull);
        expect(storage.values['veil.public_key'], 'public-key');
        expect(storage.values['veil.private_key_encrypted'], 'sym:private-key');
        expect(await service.getUnlockedPrivateKey(), 'private-key');

        final params = KdfParams.fromJson(
          jsonDecode(storage.values['veil.kdf_params']!)
              as Map<String, dynamic>,
        );
        expect(params.iterations, 3);
        expect(params.memoryPowerOf2, 16);
        expect(crypto.lastEncryptSymmetricPlainText, 'private-key');
      },
    );

    test('create fails when password validation fails', () async {
      final service = _buildService(
        validator: _FixedPasswordValidator(
          const PasswordValidationResult.invalid(
            PasswordValidationError.minLength,
          ),
        ),
      );

      await expectLater(
        () => service.create('short'),
        throwsA(isA<VeilException>()),
      );
    });

    test('unlock returns false when configuration is incomplete', () async {
      final service = _buildService();

      expect(await service.unlock('abc12345'), isFalse);
    });

    test(
      'unlock derives passphrase, decrypts private key and caches it',
      () async {
        final storage = _FakeSecureStorageService(
          values: {
            'veil.kdf_params': jsonEncode(_kdfParams.toJson()),
            'veil.private_key_encrypted': 'sym:private-key',
          },
        );
        final keyDerivation = _FakeKeyDerivationService();
        final crypto = _FakeCryptoService();
        final service = _buildService(
          storage: storage,
          keyDerivation: keyDerivation,
          crypto: crypto,
        );

        final unlocked = await service.unlock('abc12345');

        expect(unlocked, isTrue);
        expect(keyDerivation.lastPassword, 'abc12345');
        expect(crypto.lastDecryptSymmetricPayload, 'sym:private-key');
        expect(await service.getUnlockedPrivateKey(), 'private-key');
      },
    );

    test('unlock clears memory and returns false when decrypt fails', () async {
      final storage = _FakeSecureStorageService(
        values: {
          'veil.kdf_params': jsonEncode(_kdfParams.toJson()),
          'veil.private_key_encrypted': 'sym:private-key',
        },
      );
      final service = _buildService(
        storage: storage,
        crypto: _FakeCryptoService(shouldThrowOnDecryptSymmetric: true),
      );

      final unlocked = await service.unlock('abc12345');

      expect(unlocked, isFalse);
      await expectLater(service.getUnlockedPrivateKey, throwsException);
    });

    test(
      'canUseBiometricUnlock requires availability, enabled flag and passphrase',
      () async {
        final storage = _FakeSecureStorageService(
          values: {
            'veil.biometric_enabled': 'true',
            'veil.biometric_passphrase': 'passphrase',
          },
        );
        final biometrics = _FakeBiometricAuthService(isAvailableResult: true);
        final service = _buildService(storage: storage, biometrics: biometrics);

        expect(await service.canUseBiometricUnlock(), isTrue);

        biometrics.isAvailableResult = false;
        expect(await service.canUseBiometricUnlock(), isFalse);
      },
    );

    test(
      'enableBiometricUnlock stores passphrase after auth and password check',
      () async {
        final storage = _FakeSecureStorageService(
          values: {
            'veil.kdf_params': jsonEncode(_kdfParams.toJson()),
            'veil.private_key_encrypted': 'sym:private-key',
          },
        );
        final biometrics = _FakeBiometricAuthService(
          isAvailableResult: true,
          authenticateResult: true,
        );
        final crypto = _FakeCryptoService();
        final service = _buildService(
          storage: storage,
          biometrics: biometrics,
          crypto: crypto,
        );

        await service.enableBiometricUnlock('abc12345');

        expect(storage.values['veil.biometric_enabled'], 'true');
        expect(storage.values['veil.biometric_passphrase'], isNotEmpty);
        expect(crypto.lastDecryptSymmetricPayload, 'sym:private-key');
      },
    );

    test('enableBiometricUnlock throws when vault is not configured', () async {
      final service = _buildService(
        storage: _FakeSecureStorageService(),
        biometrics: _FakeBiometricAuthService(
          isAvailableResult: true,
          authenticateResult: true,
        ),
      );

      await expectLater(
        () => service.enableBiometricUnlock('abc12345'),
        throwsException,
      );
    });

    test(
      'enableBiometricUnlock throws when encrypted private key is missing',
      () async {
        final storage = _FakeSecureStorageService(
          values: {'veil.kdf_params': jsonEncode(_kdfParams.toJson())},
        );
        final service = _buildService(
          storage: storage,
          biometrics: _FakeBiometricAuthService(
            isAvailableResult: true,
            authenticateResult: true,
          ),
        );

        await expectLater(
          () => service.enableBiometricUnlock('abc12345'),
          throwsException,
        );
      },
    );

    test(
      'enableBiometricUnlock throws when biometrics are unavailable',
      () async {
        final storage = _FakeSecureStorageService(
          values: {
            'veil.kdf_params': jsonEncode(_kdfParams.toJson()),
            'veil.private_key_encrypted': 'sym:private-key',
          },
        );
        final service = _buildService(
          storage: storage,
          biometrics: _FakeBiometricAuthService(isAvailableResult: false),
        );

        await expectLater(
          () => service.enableBiometricUnlock('abc12345'),
          throwsException,
        );
      },
    );

    test(
      'enableBiometricUnlock throws biometric failed when auth returns false',
      () async {
        final storage = _FakeSecureStorageService(
          values: {
            'veil.kdf_params': jsonEncode(_kdfParams.toJson()),
            'veil.private_key_encrypted': 'sym:private-key',
          },
        );
        final service = _buildService(
          storage: storage,
          biometrics: _FakeBiometricAuthService(
            isAvailableResult: true,
            authenticateResult: false,
          ),
        );

        await expectLater(
          () => service.enableBiometricUnlock('abc12345'),
          throwsA(isA<BiometricFailedException>()),
        );
      },
    );

    test(
      'enableBiometricUnlock throws when password cannot decrypt key',
      () async {
        final storage = _FakeSecureStorageService(
          values: {
            'veil.kdf_params': jsonEncode(_kdfParams.toJson()),
            'veil.private_key_encrypted': 'sym:private-key',
          },
        );
        final service = _buildService(
          storage: storage,
          biometrics: _FakeBiometricAuthService(
            isAvailableResult: true,
            authenticateResult: true,
          ),
          crypto: _FakeCryptoService(shouldThrowOnDecryptSymmetric: true),
        );

        await expectLater(
          () => service.enableBiometricUnlock('abc12345'),
          throwsException,
        );
      },
    );

    test('disableBiometricUnlock clears biometric storage', () async {
      final storage = _FakeSecureStorageService(
        values: {
          'veil.biometric_enabled': 'true',
          'veil.biometric_passphrase': 'passphrase',
        },
      );
      final service = _buildService(storage: storage);

      await service.disableBiometricUnlock();

      expect(storage.values['veil.biometric_enabled'], 'false');
      expect(storage.values['veil.biometric_passphrase'], '');
    });

    test(
      'unlockWithBiometrics succeeds when auth and decrypt succeed',
      () async {
        final storage = _FakeSecureStorageService(
          values: {
            'veil.biometric_enabled': 'true',
            'veil.biometric_passphrase': 'passphrase',
            'veil.private_key_encrypted': 'sym:private-key',
          },
        );
        final service = _buildService(
          storage: storage,
          biometrics: _FakeBiometricAuthService(
            isAvailableResult: true,
            authenticateResult: true,
          ),
        );

        final unlocked = await service.unlockWithBiometrics();

        expect(unlocked, isTrue);
        expect(await service.getUnlockedPrivateKey(), 'private-key');
      },
    );

    test(
      'unlockWithBiometrics returns false when auth fails or decrypt errors',
      () async {
        final storage = _FakeSecureStorageService(
          values: {
            'veil.biometric_enabled': 'true',
            'veil.biometric_passphrase': 'passphrase',
            'veil.private_key_encrypted': 'sym:private-key',
          },
        );
        final authFailService = _buildService(
          storage: storage,
          biometrics: _FakeBiometricAuthService(
            isAvailableResult: true,
            authenticateResult: false,
          ),
        );
        final decryptFailService = _buildService(
          storage: storage,
          biometrics: _FakeBiometricAuthService(
            isAvailableResult: true,
            authenticateResult: true,
          ),
          crypto: _FakeCryptoService(shouldThrowOnDecryptSymmetric: true),
        );

        expect(await authFailService.unlockWithBiometrics(), isFalse);
        expect(await decryptFailService.unlockWithBiometrics(), isFalse);
      },
    );

    test('get and set auto-lock option roundtrip through storage', () async {
      final storage = _FakeSecureStorageService();
      final service = _buildService(storage: storage);

      expect(await service.getAutoLockOption(), AutoLockOption.fiveMinutes);

      await service.setAutoLockOption(AutoLockOption.fifteenMinutes);

      expect(storage.values['veil.auto_lock_option'], '15m');
      expect(await service.getAutoLockOption(), AutoLockOption.fifteenMinutes);
    });

    test(
      'getPublicKey and getUnlockedPrivateKey throw when unavailable',
      () async {
        final service = _buildService();

        await expectLater(() => service.getPublicKey(), throwsException);
        await expectLater(
          () => service.getUnlockedPrivateKey(),
          throwsException,
        );
      },
    );

    test('getPublicKey throws when stored key is empty', () async {
      final service = _buildService(
        storage: _FakeSecureStorageService(values: {'veil.public_key': ''}),
      );

      await expectLater(() => service.getPublicKey(), throwsException);
    });

    test('lock clears private key from memory', () async {
      final storage = _FakeSecureStorageService(
        values: {
          'veil.kdf_params': jsonEncode(_kdfParams.toJson()),
          'veil.private_key_encrypted': 'sym:private-key',
        },
      );
      final service = _buildService(storage: storage);

      await service.unlock('abc12345');
      service.lock();

      await expectLater(service.getUnlockedPrivateKey, throwsException);
    });
  });
}

final _kdfParams = KdfParams(
  salt: 'salt',
  iterations: 3,
  memoryPowerOf2: 16,
  parallelism: 1,
  length: 32,
);

VeilStateService _buildService({
  _FixedPasswordValidator? validator,
  _FakeKeyDerivationService? keyDerivation,
  _FakeSecureStorageService? storage,
  _FakeCryptoService? crypto,
  _FakeBiometricAuthService? biometrics,
  Random? random,
}) {
  return VeilStateService(
    keyDerivationService: keyDerivation ?? _FakeKeyDerivationService(),
    secureStorageService: storage ?? _FakeSecureStorageService(),
    cryptoService: crypto ?? _FakeCryptoService(),
    biometricAuthService: biometrics ?? _FakeBiometricAuthService(),
    passwordValidator:
        validator ??
        _FixedPasswordValidator(const PasswordValidationResult.valid()),
    random: random,
  );
}

class _FixedPasswordValidator implements PasswordValidator {
  final PasswordValidationResult result;

  _FixedPasswordValidator(this.result);

  @override
  PasswordValidationResult validate(String password) => result;
}

class _FakeKeyDerivationService implements KeyDerivationService {
  String? lastPassword;
  KdfParams? lastParams;

  @override
  Future<DerivedKey> derive({
    required String password,
    required KdfParams params,
  }) async {
    lastPassword = password;
    lastParams = params;
    return const DerivedKey([1, 2, 3, 4]);
  }
}

class _FakeSecureStorageService implements SecureStorageService {
  final Map<String, String> values;

  _FakeSecureStorageService({Map<String, String>? values})
    : values = values ?? {};

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }

  @override
  Future<String?> read(String key) async => values[key];
}

class _FakeCryptoService implements CryptoService {
  final bool shouldThrowOnDecryptSymmetric;

  String? lastEncryptSymmetricPlainText;
  String? lastDecryptSymmetricPayload;

  _FakeCryptoService({this.shouldThrowOnDecryptSymmetric = false});

  @override
  Future<CryptoKeyPair> generateKeys() async =>
      CryptoKeyPair(publicKey: 'public-key', privateKey: 'private-key');

  @override
  Future<EncryptedData> encrypt(String plainText, String publicKey) {
    throw UnimplementedError();
  }

  @override
  Future<EncryptedData> encryptSymmetric(
    String plainText,
    String passphrase,
  ) async {
    lastEncryptSymmetricPlainText = plainText;
    return EncryptedData('sym:$plainText');
  }

  @override
  Future<String> decrypt(EncryptedData data, String privateKey) {
    throw UnimplementedError();
  }

  @override
  Future<String> decryptSymmetric(EncryptedData data, String passphrase) async {
    lastDecryptSymmetricPayload = data.payload;

    if (shouldThrowOnDecryptSymmetric) {
      throw Exception('decrypt failed');
    }

    return data.payload.replaceFirst('sym:', '');
  }
}

class _FakeBiometricAuthService implements BiometricAuthService {
  bool isAvailableResult;
  bool authenticateResult;

  _FakeBiometricAuthService({
    this.isAvailableResult = false,
    this.authenticateResult = false,
  });

  @override
  Future<bool> isAvailable() async => isAvailableResult;

  @override
  Future<bool> authenticate() async => authenticateResult;
}

class _FixedRandom implements Random {
  int _next = 0;

  @override
  bool nextBool() => true;

  @override
  double nextDouble() => 0.5;

  @override
  int nextInt(int max) {
    final value = _next % max;
    _next++;
    return value;
  }
}
