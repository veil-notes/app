abstract class VaultKeyProvider {
  Future<String> getPublicKey();
  Future<String> getUnlockedPrivateKey();
}
