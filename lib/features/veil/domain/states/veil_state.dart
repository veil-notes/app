abstract class VeilState {
  Future<VeilState> bootstrap();
  Future<VeilState> create(String password);
  Future<VeilState> unlockWithPassword(String password);
  Future<VeilState> unlockWithBiometrics();
  VeilState onTimeout();
  bool get isAccessible;
}
