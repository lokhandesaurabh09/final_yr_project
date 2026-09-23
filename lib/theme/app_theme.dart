import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFF1B4332);
  static const Color accentGreen = Color(0xFF40916C);
  static const Color mintBackground = Color(0xFFD8F3DC);
  static const Color baseBackground = Color(0xFFFAFAF8);
  static const Color diseaseRed = Color(0xFFB7410E);
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textLight = Color(0xFF6B7280);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color healthyGreen = Color(0xFF16A34A);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Nunito',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        primary: AppColors.primaryGreen,
        secondary: AppColors.accentGreen,
        surface: AppColors.baseBackground,
      ),
      scaffoldBackgroundColor: AppColors.baseBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardSurface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
