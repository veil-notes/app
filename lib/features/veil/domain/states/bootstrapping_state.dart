import '../../application/veil_service.dart';
import '../biometrics/biometric_auth_exception.dart';
import '../veil_exception.dart';
import 'locked_state.dart';
import 'uninitialized_state.dart';
import 'unlocked_state.dart';
import 'veil_state.dart';

class BootstrappingState implements VeilState {
  final VeilService _service;

  BootstrappingState(this._service);

  @override
  Future<VeilState> bootstrap() async {
    final isConfigured = await _service.isConfigured();
    if (!isConfigured) {
      return UninitializedState(_service);
    }

    return LockedState(_service);
  }

  @override
  Future<VeilState> create(String password) async {
    throw const VeilException(VeilExceptionCode.vaultAlreadyConfigured);
  }

  @override
  Future<VeilState> unlockWithPassword(String password) async {
    final success = await _service.unlock(password);
    if (!success) {
      throw const VeilException(VeilExceptionCode.invalidPassword);
    }

    return UnlockedState(_service);
  }

  @override
  Future<VeilState> unlockWithBiometrics() async {
    try {
      final success = await _service.unlockWithBiometrics();
      if (!success) {
        throw const BiometricFailedException();
      }

      return UnlockedState(_service);
    } on BiometricCanceledException {
      return this;
    }
  }

  @override
  VeilState onTimeout() => this;

  @override
  bool get isAccessible => false;
}
