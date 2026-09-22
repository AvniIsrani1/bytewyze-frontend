import 'package:flutter/material.dart';
import 'package:local_fork/core/theme/app_colors.dart';

class AppTheme {
  static ColorScheme light() {
    return ColorScheme.fromSeed(
      seedColor: const Color(0xFF243E36),
      primary: const Color(0xFF243E36),
      secondary: const Color(0xFF7CA982),
      tertiary: const Color(0xFF6495ED),
      surface: const Color(0xFFFFFFFF),
      error: const Color(0xFFB3261E),
    );
  }

  static const AppColors lightAppColors = AppColors(success: Color(0xFF2E7D32));

  static ThemeData _overallTheme(ColorScheme colorScheme, AppColors appColors) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: <ThemeExtension<dynamic>>[appColors],
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: TextTheme(
        titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 16),
        bodySmall: TextStyle(fontSize: 12),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    );
  }

  static ThemeData lightTheme() => _overallTheme(light(), lightAppColors);
}
