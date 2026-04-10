import '../../application/veil_service.dart';
import 'unlocked_state.dart';
import 'veil_state.dart';

class UninitializedState implements VeilState {
  final VeilService service;

  UninitializedState(this.service);

  @override
  Future<VeilState> bootstrap() async => this;

  @override
  Future<VeilState> create(String password) async {
    await service.create(password);
    return UnlockedState(service);
  }

  @override
  Future<VeilState> unlockWithBiometrics() async {
    throw Exception('Veil not configured yet');
  }

  @override
  Future<VeilState> unlockWithPassword(String password) async {
    throw Exception('Veil not configured yet');
  }

  @override
  VeilState onTimeout() => this;

  @override
  bool get isAccessible => false;
}
