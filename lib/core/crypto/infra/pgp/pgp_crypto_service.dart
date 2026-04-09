import 'package:openpgp/openpgp.dart';
import 'package:veil/core/crypto/domain/crypto_key_pair.dart';

import '../../domain/encrypted_data.dart';
import '../../crypto_service.dart';

class PgpCryptoService implements CryptoService {
  @override
  Future<CryptoKeyPair> generateKeys() async {
    final keyPair = await OpenPGP.generate(
      options: Options()
        ..name = 'Veil User'
        ..email = 'veil@local',
    );

    return CryptoKeyPair(
      publicKey: keyPair.publicKey,
      privateKey: keyPair.privateKey,
    );
  }

  @override
  Future<String> decrypt(EncryptedData data, String privateKey) async {
    return await OpenPGP.decrypt(data.payload, privateKey, "");
  }

  @override
  Future<EncryptedData> encrypt(String plainText, String publicKey) async {
    final encrypted = await OpenPGP.encrypt(plainText, publicKey);
    return EncryptedData(encrypted);
  }

  @override
  Future<EncryptedData> encryptSymmetric(String plainText, passphrase) async {
    final symmetricEncrypted = await OpenPGP.encryptSymmetric(
      plainText,
      passphrase,
    );

    return EncryptedData(symmetricEncrypted);
  }

  @override
  Future<String> decryptSymmetric(EncryptedData data, String passphrase) async {
    return await OpenPGP.decryptSymmetric(data.payload, passphrase);
  }
}
