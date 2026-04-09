import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Center(child: CircularProgressIndicator()),
            const SizedBox(height: 24),
            Text("Loading..."),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
