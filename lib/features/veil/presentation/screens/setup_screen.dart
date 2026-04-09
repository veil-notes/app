import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veil/features/veil/presentation/providers/veil_provider.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Type a password to start...',
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _submit,
              child: const Text('Let\'s start!'),
            ),
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
      if (!mounted) return;

      final message = error is Exception
          ? error.toString().replaceFirst('Exception: ', '')
          : 'Unexpected error';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
