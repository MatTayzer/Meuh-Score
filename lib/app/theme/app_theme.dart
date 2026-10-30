import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static const background = Color(0xFF121316);
  static const text = Color(0xFFE8E8EA);
  static const textMuted = Color(0xFF9A9AA0);
  static const accent = Color.fromARGB(255, 187, 0, 0);
  static const skyjo = Color.fromARGB(255, 0, 185, 209);
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(primary: AppColors.accent),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      ), // titres des pages
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: AppColors.text),
      bodySmall: TextStyle(fontSize: 13, color: AppColors.textMuted),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ), // texte des boutons
    ),
  );
}
