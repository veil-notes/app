import 'package:flutter/material.dart';

class AppTheme {
  static final ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: const Color(0xFF40b435),
    onPrimary: const Color(0xFF0d0b28),
    secondary: const Color(0xFF03DAC6),
    onSecondary: const Color(0xFF000000),
    error: const Color(0xFFCF6679),
    onError: const Color(0xFF600000),
    surface: const Color(0xFF0d0b28),
    onSurface: const Color(0xFFcecfd6),
  );

  static final ThemeData darkTheme = ThemeData.dark(useMaterial3: true)
      .copyWith(
        primaryColor: _darkColorScheme.primary,
        colorScheme: _darkColorScheme,
        scaffoldBackgroundColor: _darkColorScheme.surface,
        cardColor: _darkColorScheme.surface,
        buttonTheme: ButtonThemeData(
          buttonColor: _darkColorScheme.primary,
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _darkColorScheme.primary,
            foregroundColor: _darkColorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: _darkColorScheme.surface,
          foregroundColor: _darkColorScheme.onSurface,
          iconTheme: IconThemeData(color: _darkColorScheme.onSurface),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
          titleLarge: TextStyle(color: Color(0xFFFFFFFF)),
        ),
        iconTheme: IconThemeData(color: _darkColorScheme.primary),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1a1838),
          hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
          labelStyle: TextStyle(color: _darkColorScheme.onSurface),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _darkColorScheme.primary),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _darkColorScheme.onError),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          disabledBorder: InputBorder.none,
        ),
      );
}
