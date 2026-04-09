import 'domain/session/auto_lock_option.dart';

abstract class VeilService {
  Future<bool> isConfigured();

  Future<void> create(String password);

  Future<bool> unlock(String password);
  Future<bool> unlockWithBiometrics();

  Future<bool> isBiometricEnabled();
  Future<bool> canUseBiometricUnlock();
  Future<void> enableBiometricUnlock(String password);
  Future<void> disableBiometricUnlock();

  Future<AutoLockOption> getAutoLockOption();
  Future<void> setAutoLockOption(AutoLockOption option);

  void lock();
}
