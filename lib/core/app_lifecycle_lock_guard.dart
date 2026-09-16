abstract class AppLifecycleLockGuard {
  bool get isActive;

  Future<T> run<T>(Future<T> Function() operation);
}

class DefaultAppLifecycleLockGuard implements AppLifecycleLockGuard {
  int _activeOperations = 0;

  @override
  bool get isActive => _activeOperations > 0;

  @override
  Future<T> run<T>(Future<T> Function() operation) async {
    _activeOperations++;

    try {
      return await operation();
    } finally {
      _activeOperations--;
    }
  }
}
