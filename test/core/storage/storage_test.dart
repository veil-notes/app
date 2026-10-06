import 'package:flutter_test/flutter_test.dart';
import 'package:veil/core/storage/infra/flutter_secure_storage_service.dart';
import 'package:veil/core/storage/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  test('biometric Android storage enforces strong user authentication', () {
    final options = veilBiometricAndroidOptions.toMap();
    expect(options['enforceBiometrics'], 'true');
    expect(options['biometricType'], 'strongBiometricOnly');
    expect(options['storageNamespace'], 'veil_biometric');
    expect(options['resetOnError'], 'false');
  });

  setUpAll(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('should store a value and read it', () async {
    final storage = FlutterSecureStorage();
    final SecureStorageService storageService = FlutterSecureStorageService(
      storage,
    );

    await storageService.write('myKey', 'myValue');

    var actual = await storageService.read('myKey');

    expect(actual, equals('myValue'));
  });
}
