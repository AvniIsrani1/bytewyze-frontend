import 'package:flutter/material.dart';

class AppTheme {
  static ColorScheme light() {
    return ColorScheme.fromSeed(
      seedColor: const Color(0xFF243E36),
      primary: const Color(0xFF243E36),
      secondary: const Color(0xFF7Ca982),
      tertiary: const Color(0xFF6495ED),
      surface: const Color(0xFFFFFFFF),
    );
  }

  static ThemeData _overallTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: TextTheme(
        titleLarge: TextStyle(fontSize: 30),
        bodyMedium: TextStyle(fontSize: 16),
        bodySmall: TextStyle(fontSize: 12),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        )
      )
    );
  }

  static ThemeData lightTheme() => _overallTheme(light());
}
