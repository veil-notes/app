import '../../veil_service.dart';
import '../biometrics/biometric_auth_exception.dart';
import 'unlocked_state.dart';
import 'veil_state.dart';

class LockedState implements VeilState {
  final VeilService service;

  LockedState(this.service);

  @override
  Future<VeilState> bootstrap() async => this;

  @override
  Future<VeilState> create(String password) async {
    throw Exception('Veil already configured');
  }

  @override
  Future<VeilState> unlockWithPassword(String password) async {
    final success = await service.unlock(password);
    if (!success) {
      throw Exception('Invalid password');
    }

    return UnlockedState(service);
  }

  @override
  Future<VeilState> unlockWithBiometrics() async {
    try {
      final success = await service.unlockWithBiometrics();
      if (!success) {
        throw const BiometricFailedException();
      }

      return UnlockedState(service);
    } on BiometricCanceledException {
      return this;
    } on BiometricUnavailableException {
      throw Exception('Biometric authentication is not available.');
    } on BiometricLockedOutException {
      throw Exception('Biometric authentication is temporarily locked.');
    } on BiometricFailedException {
      throw Exception('Biometric authentication failed.');
    }
  }

  @override
  VeilState onTimeout() => this;

  @override
  bool get isAccessible => false;
}
