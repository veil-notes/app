import 'dart:async';

import 'package:flutter/services.dart';

import 'app_shortcut_action.dart';

abstract class ShortcutIntentService {
  Stream<AppShortcutAction> get actions;
  Future<AppShortcutAction?> initialize();
  void dispose();
}

class MethodChannelShortcutIntentService implements ShortcutIntentService {
  static const _channel = MethodChannel('app.veil.veil/shortcuts');
  static const _consumeInitialMethod = 'consumeInitialShortcut';
  static const _onShortcutMethod = 'onShortcut';
  static const _argAction = 'action';

  final StreamController<AppShortcutAction> _controller =
      StreamController<AppShortcutAction>.broadcast();

  @override
  Stream<AppShortcutAction> get actions => _controller.stream;

  @override
  Future<AppShortcutAction?> initialize() async {
    _channel.setMethodCallHandler(_handleMethodCall);
    final raw = await _channel.invokeMethod<String>(_consumeInitialMethod);
    return AppShortcutActionParsing.fromRaw(raw);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method != _onShortcutMethod) {
      return;
    }

    final args = call.arguments;
    if (args is! Map) {
      return;
    }

    final raw = args[_argAction] as String?;
    final parsed = AppShortcutActionParsing.fromRaw(raw);
    if (parsed != null) {
      _controller.add(parsed);
    }
  }

  @override
  void dispose() {
    _channel.setMethodCallHandler(null);
    _controller.close();
  }
}