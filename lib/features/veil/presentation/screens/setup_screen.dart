import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_error_mapper.dart';
import '../../../../i18n/translations.g.dart';
import '../../providers/veil_provider.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  static const _errorMapper = AppErrorMapper();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(hintText: t.veil.setup.passwordHint),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _submit, child: Text(t.veil.setup.cta)),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final controller = ref.read(veilControllerProvider.notifier);
    final password = _passwordController.text;

    try {
      await controller.create(password);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMapper.map(context.t, error))),
      );
    }
  }
}
