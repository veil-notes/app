import 'domain/crypto_key_pair.dart';
import 'domain/encrypted_data.dart';

abstract class CryptoService {
  Future<CryptoKeyPair> generateKeys();
  Future<EncryptedData> encrypt(String plainText, String publicKey);
  Future<EncryptedData> encryptSymmetric(String plainText, String passphrase);
  Future<String> decrypt(EncryptedData data, String privateKey);
  Future<String> decryptSymmetric(EncryptedData data, String passphrase);
}
