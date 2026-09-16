import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:veil/core/app_lifecycle_lock_guard.dart';

void main() {
  test(
    'stays active while an operation is pending and releases afterwards',
    () async {
      final guard = DefaultAppLifecycleLockGuard();
      final completer = Completer<String>();

      final operation = guard.run(() => completer.future);

      expect(guard.isActive, isTrue);

      completer.complete('done');
      await expectLater(operation, completion('done'));

      expect(guard.isActive, isFalse);
    },
  );

  test('releases after an operation throws', () async {
    final guard = DefaultAppLifecycleLockGuard();

    await expectLater(
      guard.run<String>(() async => throw StateError('failed')),
      throwsStateError,
    );

    expect(guard.isActive, isFalse);
  });

  test('keeps the guard active for nested operations', () async {
    final guard = DefaultAppLifecycleLockGuard();

    await guard.run(() async {
      expect(guard.isActive, isTrue);

      await guard.run(() async {
        expect(guard.isActive, isTrue);
      });

      expect(guard.isActive, isTrue);
    });

    expect(guard.isActive, isFalse);
  });
}
