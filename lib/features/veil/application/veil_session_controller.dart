import 'dart:async';

class VeilSessionController {
  Duration _timeout;
  final void Function() onTimeout;

  Timer? _timer;

  VeilSessionController({
    required Duration timeout,
    required this.onTimeout,
  }) : _timeout = timeout;

  void updateTimeout(Duration timeout) {
    _timeout = timeout;

    if (_timer != null) {
      _restartTimer();
    }
  }

  void start() {
    _restartTimer();
  }

  void refresh() {
    _restartTimer();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _restartTimer() {
    _timer?.cancel();
    _timer = Timer(_timeout, onTimeout);
  }
}
