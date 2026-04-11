import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veil/app/app_theme.dart';
import 'package:veil/features/veil/presentation/screens/splash_screen.dart';

import '../test_localized_app.dart';

void main() {
  testWidgets('SplashScreen shows loading indicator and text', (tester) async {
    await tester.pumpWidget(
      buildLocalizedApp(theme: AppTheme.darkTheme, home: const SplashScreen()),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading...'), findsOneWidget);
  });
}
