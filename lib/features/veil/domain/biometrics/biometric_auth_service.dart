abstract class BiometricAuthService {
  Future<bool> isAvailable();
  Future<bool> authenticate();
}
