import 'package:flutter/material.dart';

class AppColors {
  // Base
  static const Color background = Color(0xFF0D0D0D);       // Near black
  static const Color surface = Color(0xFF161616);          // Card surface
  static const Color surfaceElevated = Color(0xFF1E1E1E);  // Elevated cards
  static const Color border = Color(0xFF2A2A2A);           // Subtle borders

  // Primary accent — modernized green
  static const Color primary = Color(0xFF22C55E);          // Vivid green
  static const Color primaryDim = Color(0xFF16A34A);       // Deeper green
  static const Color primaryGlow = Color(0xFF4ADE80);      // Light glow green
  static const Color primaryMuted = Color(0xFF052E16);     // Dark green bg tint

  // Text
  static const Color textPrimary = Color(0xFFF5F5F5);      // Near white
  static const Color textSecondary = Color(0xFF8A8A8A);    // Muted
  static const Color textTertiary = Color(0xFF4A4A4A);     // Very muted

  // Status
  static const Color danger = Color(0xFFEF4444);           // Red
  static const Color dangerMuted = Color(0xFF2D0A0A);
  static const Color warning = Color(0xFFF59E0B);          // Amber
  static const Color warningMuted = Color(0xFF2D1A00);
  static const Color success = Color(0xFF22C55E);
  static const Color successMuted = Color(0xFF052E16);

  // Weather widget
  static const Color weatherBlue = Color(0xFF38BDF8);
  static const Color weatherBlueMuted = Color(0xFF0C1A2E);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryGlow,
        surface: AppColors.surface,
        error: AppColors.danger,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}
