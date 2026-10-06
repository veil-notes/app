import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../secure_storage_service.dart';

const veilBiometricAndroidOptions = AndroidOptions.biometric(
  enforceBiometrics: true,
  resetOnError: false,
  biometricType: AndroidBiometricType.strongBiometricOnly,
  storageNamespace: 'veil_biometric',
  biometricPromptNegativeButton: 'Cancel',
);

class FlutterSecureStorageService implements SecureStorageService {
  final FlutterSecureStorage _storage;
  final void Function()? _onOperationStarted;
  final void Function()? _onOperationFinished;

  FlutterSecureStorageService(
    this._storage, {
    void Function()? onOperationStarted,
    void Function()? onOperationFinished,
  }) : _onOperationStarted = onOperationStarted,
       _onOperationFinished = onOperationFinished;

  @override
  Future<void> write(String key, String value) async {
    _onOperationStarted?.call();
    try {
      await _storage.write(key: key, value: value);
    } finally {
      _onOperationFinished?.call();
    }
  }

  @override
  Future<String?> read(String key) async {
    _onOperationStarted?.call();
    try {
      return await _storage.read(key: key);
    } finally {
      _onOperationFinished?.call();
    }
  }

  @override
  Future<void> delete(String key) {
    return _storage.delete(key: key);
  }
}
