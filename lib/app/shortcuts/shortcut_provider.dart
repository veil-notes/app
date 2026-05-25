import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_shortcut_action.dart';
import 'shortcut_intent_service.dart';

class PendingShortcutActionNotifier extends Notifier<AppShortcutAction?> {
  @override
  AppShortcutAction? build() => null;

  void set(AppShortcutAction action) => state = action;

  AppShortcutAction? consume() {
    final current = state;
    state = null;
    return current;
  }
}

final shortcutIntentServiceProvider = Provider<ShortcutIntentService>((ref) {
  final service = MethodChannelShortcutIntentService();
  ref.onDispose(service.dispose);
  return service;
});

final pendingShortcutActionProvider =
    NotifierProvider<PendingShortcutActionNotifier, AppShortcutAction?>(
      PendingShortcutActionNotifier.new,
    );