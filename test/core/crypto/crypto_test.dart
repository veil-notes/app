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

  test('should encrypt and decrypt text symmetrically', () async {
    final CryptoService cryptoService = PgpCryptoService();
    const plainText = 'private symmetric note';
    const passphrase = 'test-passphrase';

    final encrypted = await cryptoService.encryptSymmetric(
      plainText,
      passphrase,
    );
    final decrypted = await cryptoService.decryptSymmetric(
      encrypted,
      passphrase,
    );

    expect(
      encrypted.payload,
      startsWith('-----BEGIN PGP MESSAGE-----'),
    );
    expect(decrypted, plainText);
  });

  test('should encrypt symmetric text into EncryptedData', () async {
    final CryptoService cryptoService = PgpCryptoService();

    final encrypted = await cryptoService.encryptSymmetric(
      'another private note',
      'another-passphrase',
    );

    expect(encrypted.payload, startsWith('-----BEGIN PGP MESSAGE-----'));
  });

  test('should decrypt previously encrypted symmetric text', () async {
    final CryptoService cryptoService = PgpCryptoService();

    final encrypted = await cryptoService.encryptSymmetric(
      'symmetric roundtrip',
      'super-secret',
    );

    final decrypted = await cryptoService.decryptSymmetric(
      encrypted,
      'super-secret',
    );

    expect(decrypted, 'symmetric roundtrip');
  });
}
