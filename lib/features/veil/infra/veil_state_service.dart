import 'dart:convert';
import 'dart:math';

import 'package:veil/core/crypto/domain/encrypted_data.dart';

import '../../../core/crypto/crypto_service.dart';
import '../../../core/crypto/domain/kdf_params.dart';
import '../../../core/crypto/key_derivation_service.dart';
import '../../../core/storage/secure_storage_service.dart';

import '../domain/biometrics/biometric_auth_exception.dart';
import '../domain/biometrics/biometric_auth_service.dart';
import '../domain/password/password_validator.dart';
import '../domain/session/auto_lock_option.dart';
import '../domain/veil_exception.dart';
import '../domain/vault_key_provider.dart';
import '../application/veil_service.dart';

class VeilStateService implements VeilService, VaultKeyProvider {
  static const _saltLength = 16;
  static const _kdfParamsStorageKey = 'veil.kdf_params';
  static const _publicKeyStorageKey = 'veil.public_key';
  static const _encryptedPrivateKeyStorageKey = 'veil.private_key_encrypted';
  static const _biometricEnabledStorageKey = 'veil.biometric_enabled';
  static const _biometricPassphraseStorageKey = 'veil.biometric_passphrase';
  static const _autoLockOptionStorageKey = 'veil.auto_lock_option';
  static const _passwordChangeTransactionStorageKey =
      'veil.password_change_transaction';

  final PasswordValidator _passwordValidator;
  final KeyDerivationService _keyDerivationService;
  final SecureStorageService _secureStorageService;
  final CryptoService _cryptoService;
  final BiometricAuthService _biometricAuthService;

  final Random _random;

  String? _privateKeyInMemory;

  VeilStateService({
    required KeyDerivationService keyDerivationService,
    required SecureStorageService secureStorageService,
    required CryptoService cryptoService,
    required BiometricAuthService biometricAuthService,

    required PasswordValidator passwordValidator,
    Random? random,
  }) : _keyDerivationService = keyDerivationService,
       _secureStorageService = secureStorageService,
       _cryptoService = cryptoService,
       _biometricAuthService = biometricAuthService,
       _passwordValidator = passwordValidator,
       _random = random ?? Random.secure();

  @override
  Future<bool> isConfigured() async {
    await _recoverPendingPasswordChange();

    final kdfParams = await _secureStorageService.read(_kdfParamsStorageKey);
    final publicKey = await _secureStorageService.read(_publicKeyStorageKey);
    final encryptedPrivateKey = await _secureStorageService.read(
      _encryptedPrivateKeyStorageKey,
    );

    return kdfParams != null &&
        publicKey != null &&
        encryptedPrivateKey != null;
  }

  @override
  Future<void> create(String password) async {
    if (await isConfigured()) {
      return;
    }

    final validation = _passwordValidator.validate(password);

    if (!validation.isValid) {
      throw VeilException.passwordValidation(validation.error!);
    }

    final params = _buildKdfParams();
    final derivedKey = await _keyDerivationService.derive(
      password: password,
      params: params,
    );
    final passphrase = _toPassphrase(derivedKey.bytes);
    final keyPair = await _cryptoService.generateKeys();
    final encryptedPrivateKey = await _cryptoService.encryptSymmetric(
      keyPair.privateKey,
      passphrase,
    );

    await _secureStorageService.write(
      _kdfParamsStorageKey,
      jsonEncode(params.toJson()),
    );

    await _secureStorageService.write(_publicKeyStorageKey, keyPair.publicKey);

    await _secureStorageService.write(
      _encryptedPrivateKeyStorageKey,
      encryptedPrivateKey.payload,
    );

    _privateKeyInMemory = keyPair.privateKey;
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await _recoverPendingPasswordChange();

    final validation = _passwordValidator.validate(newPassword);
    if (!validation.isValid) {
      throw VeilException.passwordValidation(validation.error!);
    }

    final oldParams = await _readKdfParams();
    if (oldParams == null) {
      throw const VeilException(VeilExceptionCode.vaultNotConfigured);
    }

    final oldEncryptedPrivateKey = await _secureStorageService.read(
      _encryptedPrivateKeyStorageKey,
    );
    if (oldEncryptedPrivateKey == null || oldEncryptedPrivateKey.isEmpty) {
      throw const VeilException(VeilExceptionCode.encryptedPrivateKeyNotFound);
    }

    final oldBiometricEnabled = await isBiometricEnabled();
    final oldBiometricPassphrase = await _secureStorageService.read(
      _biometricPassphraseStorageKey,
    );

    final currentDerivedKey = await _keyDerivationService.derive(
      password: currentPassword,
      params: oldParams,
    );

    final privateKey = await _decryptPrivateKey(
      oldEncryptedPrivateKey,
      _toPassphrase(currentDerivedKey.bytes),
    );

    final newParams = _buildKdfParams();
    final newDerivedKey = await _keyDerivationService.derive(
      password: newPassword,
      params: newParams,
    );
    final newPassphrase = _toPassphrase(newDerivedKey.bytes);
    final newEncryptedPrivateKey = await _cryptoService.encryptSymmetric(
      privateKey,
      newPassphrase,
    );

    final snapshot = _PasswordChangeSnapshot(
      kdfParams: jsonEncode(oldParams.toJson()),
      encryptedPrivateKey: oldEncryptedPrivateKey,
      biometricEnabled: oldBiometricEnabled ? 'true' : 'false',
      biometricPassphrase: oldBiometricPassphrase ?? '',
    );

    try {
      await _secureStorageService.write(
        _passwordChangeTransactionStorageKey,
        jsonEncode(snapshot.toJson()),
      );
      await _secureStorageService.write(
        _kdfParamsStorageKey,
        jsonEncode(newParams.toJson()),
      );
      await _secureStorageService.write(
        _encryptedPrivateKeyStorageKey,
        newEncryptedPrivateKey.payload,
      );
      await _secureStorageService.write(
        _biometricEnabledStorageKey,
        oldBiometricEnabled ? 'true' : 'false',
      );
      await _secureStorageService.write(
        _biometricPassphraseStorageKey,
        oldBiometricEnabled ? newPassphrase : '',
      );
      await _clearPasswordChangeTransaction();
    } catch (_) {
      try {
        await _restorePasswordChangeSnapshot(snapshot);
      } catch (_) {
        lock();
        throw const VeilException(VeilExceptionCode.passwordChangeFailed);
      }

      throw const VeilException(VeilExceptionCode.passwordChangeFailed);
    }

    _privateKeyInMemory = privateKey;
  }

  @override
  void lock() {
    _privateKeyInMemory = null;
  }

  @override
  Future<bool> unlock(String password) async {
    await _recoverPendingPasswordChange();

    final params = await _readKdfParams();
    final encryptedPrivateKey = await _secureStorageService.read(
      _encryptedPrivateKeyStorageKey,
    );

    if (params == null || encryptedPrivateKey == null) {
      return false;
    }

    try {
      final derivedKey = await _keyDerivationService.derive(
        password: password,
        params: params,
      );
      final privateKey = await _cryptoService.decryptSymmetric(
        EncryptedData(encryptedPrivateKey),
        _toPassphrase(derivedKey.bytes),
      );

      _privateKeyInMemory = privateKey;
      return true;
    } catch (_) {
      _privateKeyInMemory = null;
      return false;
    }
  }

  @override
  Future<bool> canUseBiometricUnlock() async {
    await _recoverPendingPasswordChange();

    final isAvailable = await _biometricAuthService.isAvailable();
    if (!isAvailable) {
      return false;
    }

    final isEnabled = await isBiometricEnabled();
    final storedPassphrase = await _secureStorageService.read(
      _biometricPassphraseStorageKey,
    );

    return isEnabled && storedPassphrase != null && storedPassphrase.isNotEmpty;
  }

  @override
  Future<bool> isBiometricEnabled() async {
    await _recoverPendingPasswordChange();

    final raw = await _secureStorageService.read(_biometricEnabledStorageKey);
    return raw == 'true';
  }

  @override
  Future<void> enableBiometricUnlock(String password) async {
    await _recoverPendingPasswordChange();

    final params = await _readKdfParams();
    if (params == null) {
      throw const VeilException(VeilExceptionCode.vaultNotConfigured);
    }

    final encryptedPrivateKey = await _secureStorageService.read(
      _encryptedPrivateKeyStorageKey,
    );
    if (encryptedPrivateKey == null || encryptedPrivateKey.isEmpty) {
      throw const VeilException(VeilExceptionCode.encryptedPrivateKeyNotFound);
    }

    final biometricAvailable = await _biometricAuthService.isAvailable();
    if (!biometricAvailable) {
      throw const BiometricUnavailableException();
    }

    final authenticated = await _biometricAuthService.authenticate();
    if (!authenticated) {
      throw const BiometricFailedException();
    }

    final derivedKey = await _keyDerivationService.derive(
      password: password,
      params: params,
    );

    final passphrase = _toPassphrase(derivedKey.bytes);

    try {
      await _cryptoService.decryptSymmetric(
        EncryptedData(encryptedPrivateKey),
        passphrase,
      );
    } catch (_) {
      throw const VeilException(VeilExceptionCode.invalidPassword);
    }

    await _secureStorageService.write(_biometricEnabledStorageKey, 'true');
    await _secureStorageService.write(
      _biometricPassphraseStorageKey,
      passphrase,
    );
  }

  @override
  Future<void> disableBiometricUnlock() async {
    await _recoverPendingPasswordChange();

    await _secureStorageService.write(_biometricEnabledStorageKey, 'false');
    await _secureStorageService.write(_biometricPassphraseStorageKey, '');
  }

  @override
  Future<bool> unlockWithBiometrics() async {
    await _recoverPendingPasswordChange();

    final canUseBiometrics = await canUseBiometricUnlock();
    if (!canUseBiometrics) {
      return false;
    }

    final authenticated = await _biometricAuthService.authenticate();
    if (!authenticated) {
      return false;
    }

    final encryptedPrivateKey = await _secureStorageService.read(
      _encryptedPrivateKeyStorageKey,
    );
    final passphrase = await _secureStorageService.read(
      _biometricPassphraseStorageKey,
    );

    if (encryptedPrivateKey == null ||
        passphrase == null ||
        passphrase.isEmpty) {
      return false;
    }

    try {
      final privateKey = await _cryptoService.decryptSymmetric(
        EncryptedData(encryptedPrivateKey),
        passphrase,
      );

      _privateKeyInMemory = privateKey;
      return true;
    } catch (_) {
      _privateKeyInMemory = null;
      return false;
    }
  }

  @override
  Future<AutoLockOption> getAutoLockOption() async {
    final raw = await _secureStorageService.read(_autoLockOptionStorageKey);
    return AutoLockOption.fromId(raw);
  }

  @override
  Future<void> setAutoLockOption(AutoLockOption option) async {
    await _secureStorageService.write(_autoLockOptionStorageKey, option.id);
  }

  @override
  Future<String> getPublicKey() async {
    await _recoverPendingPasswordChange();

    final publicKey = await _secureStorageService.read(_publicKeyStorageKey);

    if (publicKey == null || publicKey.isEmpty) {
      throw const VeilException(VeilExceptionCode.publicKeyNotFound);
    }

    return publicKey;
  }

  @override
  Future<String> getUnlockedPrivateKey() async {
    final privateKey = _privateKeyInMemory;

    if (privateKey == null || privateKey.isEmpty) {
      throw const VeilException(VeilExceptionCode.vaultLocked);
    }

    return privateKey;
  }

  KdfParams _buildKdfParams() {
    return KdfParams(
      salt: _generateSalt(),
      iterations: 3,
      memoryPowerOf2: 16,
      parallelism: 1,
      length: 32,
    );
  }

  String _generateSalt() {
    final bytes = List<int>.generate(_saltLength, (_) => _random.nextInt(256));
    return base64UrlEncode(bytes);
  }

  String _toPassphrase(List<int> bytes) {
    return base64UrlEncode(bytes);
  }

  Future<KdfParams?> _readKdfParams() async {
    final raw = await _secureStorageService.read(_kdfParamsStorageKey);
    if (raw == null) {
      return null;
    }

    final json = jsonDecode(raw);
    if (json is! Map<String, dynamic>) {
      return null;
    }

    return KdfParams.fromJson(json);
  }

  Future<String> _decryptPrivateKey(
    String encryptedPrivateKey,
    String passphrase,
  ) async {
    try {
      return await _cryptoService.decryptSymmetric(
        EncryptedData(encryptedPrivateKey),
        passphrase,
      );
    } catch (_) {
      throw const VeilException(VeilExceptionCode.invalidPassword);
    }
  }

  Future<void> _recoverPendingPasswordChange() async {
    final rawTransaction = await _secureStorageService.read(
      _passwordChangeTransactionStorageKey,
    );

    if (rawTransaction == null || rawTransaction.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(rawTransaction);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid password change transaction');
      }

      final snapshot = _PasswordChangeSnapshot.fromJson(decoded);
      await _restorePasswordChangeSnapshot(snapshot);
    } catch (_) {
      throw const VeilException(VeilExceptionCode.passwordChangeFailed);
    }
  }

  Future<void> _restorePasswordChangeSnapshot(
    _PasswordChangeSnapshot snapshot,
  ) async {
    await _secureStorageService.write(
      _kdfParamsStorageKey,
      snapshot.kdfParams,
    );
    await _secureStorageService.write(
      _encryptedPrivateKeyStorageKey,
      snapshot.encryptedPrivateKey,
    );
    await _secureStorageService.write(
      _biometricEnabledStorageKey,
      snapshot.biometricEnabled,
    );
    await _secureStorageService.write(
      _biometricPassphraseStorageKey,
      snapshot.biometricPassphrase,
    );
    await _clearPasswordChangeTransaction();
  }

  Future<void> _clearPasswordChangeTransaction() async {
    await _secureStorageService.write(
      _passwordChangeTransactionStorageKey,
      '',
    );
  }
}

class _PasswordChangeSnapshot {
  final String kdfParams;
  final String encryptedPrivateKey;
  final String biometricEnabled;
  final String biometricPassphrase;

  const _PasswordChangeSnapshot({
    required this.kdfParams,
    required this.encryptedPrivateKey,
    required this.biometricEnabled,
    required this.biometricPassphrase,
  });

  Map<String, String> toJson() {
    return {
      'kdfParams': kdfParams,
      'encryptedPrivateKey': encryptedPrivateKey,
      'biometricEnabled': biometricEnabled,
      'biometricPassphrase': biometricPassphrase,
    };
  }

  factory _PasswordChangeSnapshot.fromJson(Map<String, dynamic> json) {
    final kdfParams = json['kdfParams'];
    final encryptedPrivateKey = json['encryptedPrivateKey'];
    final biometricEnabled = json['biometricEnabled'];
    final biometricPassphrase = json['biometricPassphrase'];

    if (kdfParams is! String ||
        encryptedPrivateKey is! String ||
        biometricEnabled is! String ||
        biometricPassphrase is! String) {
      throw const FormatException('Invalid password change transaction');
    }

    return _PasswordChangeSnapshot(
      kdfParams: kdfParams,
      encryptedPrivateKey: encryptedPrivateKey,
      biometricEnabled: biometricEnabled,
      biometricPassphrase: biometricPassphrase,
    );
  }
}
