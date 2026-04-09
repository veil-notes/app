class AutoLockOption {
  final String id;
  final String label;
  final Duration duration;

  const AutoLockOption({
    required this.id,
    required this.label,
    required this.duration,
  });

  static const oneMinute = AutoLockOption(
    id: '1m',
    label: '1 minute',
    duration: Duration(minutes: 1),
  );

  static const fiveMinutes = AutoLockOption(
    id: '5m',
    label: '5 minutes',
    duration: Duration(minutes: 5),
  );

  static const fifteenMinutes = AutoLockOption(
    id: '15m',
    label: '15 minutes',
    duration: Duration(minutes: 15),
  );

  static const thirtyMinutes = AutoLockOption(
    id: '30m',
    label: '30 minutes',
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
