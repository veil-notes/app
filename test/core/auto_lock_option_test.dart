import 'package:flutter_test/flutter_test.dart';
import 'package:veil/features/veil/domain/session/auto_lock_option.dart';

void main() {
  group('AutoLockOption', () {
    test('exposes the expected built-in options', () {
      expect(AutoLockOption.options, hasLength(4));
      expect(AutoLockOption.options, contains(AutoLockOption.oneMinute));
      expect(AutoLockOption.options, contains(AutoLockOption.fiveMinutes));
      expect(AutoLockOption.options, contains(AutoLockOption.fifteenMinutes));
      expect(AutoLockOption.options, contains(AutoLockOption.thirtyMinutes));
    });

    test('finds options by id', () {
      expect(AutoLockOption.fromId('1m'), same(AutoLockOption.oneMinute));
      expect(AutoLockOption.fromId('15m'), same(AutoLockOption.fifteenMinutes));
    });

    test('falls back to five minutes for unknown ids', () {
      expect(
        AutoLockOption.fromId('unknown'),
        same(AutoLockOption.fiveMinutes),
      );
      expect(AutoLockOption.fromId(null), same(AutoLockOption.fiveMinutes));
    });
  });
}
