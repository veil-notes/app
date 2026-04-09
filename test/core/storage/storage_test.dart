import 'package:flutter_test/flutter_test.dart';
import 'package:veil/core/storage/infra/flutter_secure_storage_service.dart';
import 'package:veil/core/storage/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
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
