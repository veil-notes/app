import 'package:flutter_test/flutter_test.dart';
import 'package:veil/core/crypto/domain/kdf_params.dart';
import 'package:veil/core/crypto/infra/kdf/argon2_kdf_derivation_service.dart';
import 'package:veil/core/crypto/key_derivation_service.dart';

void main() {
  test('should derive same key for same password', () async {
    final KeyDerivationService keyDerivationService =
        Argon2KdfDerivationService();

    final kdfParams = KdfParams(
      salt: 'random_salt',
      iterations: 3,
      memoryPowerOf2: 16, // 64MB
      parallelism: 2,
      length: 32,
    );

    var key1 = await keyDerivationService.derive(
      password: 'test123',
      params: kdfParams,
    );

    var key2 = await keyDerivationService.derive(
      password: 'test123',
      params: kdfParams,
    );

    expect(key1.bytes, key2.bytes);
  });

  test('should generate different key for differntes inputs', () async {
    final KeyDerivationService keyDerivationService =
        Argon2KdfDerivationService();

    final kdfParams = KdfParams(
      salt: 'random_salt',
      iterations: 3,
      memoryPowerOf2: 16, // 64MB
      parallelism: 2,
      length: 32,
    );

    var key1 = await keyDerivationService.derive(
      password: 'test123',
      params: kdfParams,
    );

    var key2 = await keyDerivationService.derive(
      password: 'test321',
      params: kdfParams,
    );

    expect(key1.bytes, isNot(key2.bytes));
  });
}
