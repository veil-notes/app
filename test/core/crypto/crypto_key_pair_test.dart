import 'package:flutter_test/flutter_test.dart';
import 'package:veil/core/crypto/domain/crypto_key_pair.dart';

void main() {
  test('serializes and deserializes a crypto key pair', () {
    final pair = CryptoKeyPair(publicKey: 'pub', privateKey: 'priv');

    final json = pair.toJson();
    final restored = CryptoKeyPair.fromJson(json);

    expect(json, {
      'publicKey': 'pub',
      'privateKey': 'priv',
    });
    expect(restored.publicKey, 'pub');
    expect(restored.privateKey, 'priv');
  });
}
