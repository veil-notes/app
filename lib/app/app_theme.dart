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

  static final ThemeData _baseDarkTheme = ThemeData.dark(useMaterial3: true);

  static final TextTheme _interTextTheme = _baseDarkTheme.textTheme
      .apply(
        fontFamily: 'Inter',
        bodyColor: const Color(0xFFE0E0E0),
        displayColor: const Color(0xFFFFFFFF),
      )
      .copyWith(
        bodyLarge: _baseDarkTheme.textTheme.bodyLarge?.copyWith(
          fontFamily: 'Inter',
          color: const Color(0xFFE0E0E0),
        ),
        titleLarge: _baseDarkTheme.textTheme.titleLarge?.copyWith(
          fontFamily: 'Inter',
          color: const Color(0xFFFFFFFF),
        ),
      );

  static final ThemeData darkTheme = _baseDarkTheme.copyWith(
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _darkColorScheme.surface,
      foregroundColor: _darkColorScheme.onSurface,
      iconTheme: IconThemeData(color: _darkColorScheme.onSurface),
      titleTextStyle: _interTextTheme.titleLarge,
      toolbarTextStyle: _interTextTheme.bodyLarge,
    ),
    textTheme: _interTextTheme,
    primaryTextTheme: _interTextTheme,
    iconTheme: IconThemeData(color: _darkColorScheme.primary),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1a1838),
      hintStyle: const TextStyle(fontFamily: 'Inter', color: Color(0xFFBDBDBD)),
      labelStyle: TextStyle(
        fontFamily: 'Inter',
        color: _darkColorScheme.onSurface,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _darkColorScheme.primary),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _darkColorScheme.onError),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      disabledBorder: InputBorder.none,
    ),
  );
}
