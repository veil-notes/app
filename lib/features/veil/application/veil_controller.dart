import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/states/bootstrapping_state.dart';
import '../presentation/providers/veil_provider.dart';
import '../veil_service.dart';

import '../domain/states/veil_state.dart';

class VeilController extends Notifier<VeilState> {
  late final VeilService _service;

  @override
  VeilState build() {
    _service = ref.read(veilServiceProvider);
    final initialState = BootstrappingState(_service);

    _startBootstrap(initialState);

    return initialState;
  }

  Future<void> _startBootstrap(VeilState currentState) async {
    final nextState = await currentState.bootstrap();
    state = nextState;
  }

  Future<void> create(String password) async {
    state = await state.create(password);
  }

  Future<void> unlock(String password) async {
    state = await state.unlockWithPassword(password);
  }

  Future<void> unlockWithBiometrics() async {
    state = await state.unlockWithBiometrics();
  }

  void lock() {
    state = state.onTimeout();
  }
}
