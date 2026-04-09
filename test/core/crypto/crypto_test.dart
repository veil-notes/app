import 'package:flutter_test/flutter_test.dart';
import 'package:veil/core/crypto/crypto_service.dart';
import 'package:veil/core/crypto/infra/pgp/pgp_crypto_service.dart';

void main() {
  test('should encrypt text', () async {
    final CryptoService cryptoService = PgpCryptoService();
    final keyPair = await cryptoService.generateKeys();
    const plainText = 'some markdown **note**';

    var actualEncryptedData = await cryptoService.encrypt(
      plainText,
      keyPair.publicKey,
    );

    expect(
      actualEncryptedData.payload,
      startsWith('-----BEGIN PGP MESSAGE-----'),
    );
  });

  test('should decrypt text', () async {
    final CryptoService cryptoService = PgpCryptoService();
    final keyPair = await cryptoService.generateKeys();
    const plainText = 'some markdown **note**';

    var encryptedData = await cryptoService.encrypt(
      plainText,
      keyPair.publicKey,
    );
    var actual = await cryptoService.decrypt(encryptedData, keyPair.privateKey);

    expect(actual, equals(plainText));
  });
}
