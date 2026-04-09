import '../../veil_service.dart';
import 'locked_state.dart';
import 'veil_state.dart';

class UnlockedState implements VeilState {
  final VeilService service;

  UnlockedState(this.service);

  @override
  Future<VeilState> bootstrap() async => this;

  @override
  Future<VeilState> create(String password) async {
    throw Exception('Veil already configured');
  }

  @override
  Future<VeilState> unlockWithPassword(String password) async => this;

  @override
  Future<VeilState> unlockWithBiometrics() async => this;

  @override
  VeilState onTimeout() {
    service.lock();
    return LockedState(service);
  }

  @override
  bool get isAccessible => true;
}
