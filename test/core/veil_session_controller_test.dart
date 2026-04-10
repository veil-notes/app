import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veil/features/veil/application/veil_session_controller.dart';

void main() {
  group('VeilSessionController', () {
    test('fires timeout after start', () {
      fakeAsync((async) {
        var timeoutCount = 0;
        final controller = VeilSessionController(
          timeout: const Duration(seconds: 5),
          onTimeout: () => timeoutCount++,
        );

        controller.start();
        async.elapse(const Duration(seconds: 4));
        expect(timeoutCount, 0);

        async.elapse(const Duration(seconds: 1));
        expect(timeoutCount, 1);
      });
    });

    test('refresh restarts the timer', () {
      fakeAsync((async) {
        var timeoutCount = 0;
        final controller = VeilSessionController(
          timeout: const Duration(seconds: 5),
          onTimeout: () => timeoutCount++,
        );

        controller.start();
        async.elapse(const Duration(seconds: 4));
        controller.refresh();
        async.elapse(const Duration(seconds: 4));

        expect(timeoutCount, 0);

        async.elapse(const Duration(seconds: 1));
        expect(timeoutCount, 1);
      });
    });

    test('updateTimeout applies to the running timer', () {
      fakeAsync((async) {
        var timeoutCount = 0;
        final controller = VeilSessionController(
          timeout: const Duration(seconds: 5),
          onTimeout: () => timeoutCount++,
        );

        controller.start();
        async.elapse(const Duration(seconds: 2));
        controller.updateTimeout(const Duration(seconds: 1));
        async.elapse(const Duration(milliseconds: 999));

        expect(timeoutCount, 0);

        async.elapse(const Duration(milliseconds: 1));
        expect(timeoutCount, 1);
      });
    });

    test('stop cancels the timer', () {
      fakeAsync((async) {
        var timeoutCount = 0;
        final controller = VeilSessionController(
          timeout: const Duration(seconds: 5),
          onTimeout: () => timeoutCount++,
        );

        controller.start();
        controller.stop();
        async.elapse(const Duration(seconds: 10));

        expect(timeoutCount, 0);
      });
    });
  });
}
