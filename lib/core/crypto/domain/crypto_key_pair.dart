class CryptoKeyPair {
  String publicKey;
  String privateKey;

  CryptoKeyPair({required this.publicKey, required this.privateKey});

  Map<String, dynamic> toJson() {
    return {'publicKey': publicKey, 'privateKey': privateKey};
  }

  factory CryptoKeyPair.fromJson(Map<String, dynamic> json) {
    return CryptoKeyPair(
      publicKey: json['publicKey'] as String,
      privateKey: json['privateKey'] as String,
    );
  }
}
