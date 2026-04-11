class AutoLockOption {
  final String id;
  final Duration duration;

  const AutoLockOption({required this.id, required this.duration});

  static const oneMinute = AutoLockOption(
    id: '1m',
    duration: Duration(minutes: 1),
  );

  static const fiveMinutes = AutoLockOption(
    id: '5m',
    duration: Duration(minutes: 5),
  );

  static const fifteenMinutes = AutoLockOption(
    id: '15m',
    duration: Duration(minutes: 15),
  );

  static const thirtyMinutes = AutoLockOption(
    id: '30m',
    duration: Duration(minutes: 30),
  );

  static const options = [
    oneMinute,
    fiveMinutes,
    fifteenMinutes,
    thirtyMinutes,
  ];

  static AutoLockOption fromId(String? id) {
    return options.firstWhere(
      (option) => option.id == id,
      orElse: () => fiveMinutes,
    );
  }
}
