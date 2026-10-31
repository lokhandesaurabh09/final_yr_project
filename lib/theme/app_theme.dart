import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 
class AppColors {
  // Background & Surface Colors
  static const Color background = Color(0xFFF8FAF7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF0F5EE);
  static const Color border = Color(0xFFE2E8E0);
 
  // Primary Palette - Forest Green & Emerald
  static const Color primary = Color(0xFF245C3A); // Forest Green
  static const Color primaryDark = Color(0xFF173D2A); // Dark Forest
  static const Color primaryLight = Color(0xFF347A4D); // Emerald
  static const Color primaryMuted = Color(0xFFE9F4E8); // Sage
  static const Color primaryExtraMuted = Color(0xFFF5FAF4); // Light Sage
 
  // Neutral Text Colors
  static const Color textPrimary = Color(0xFF1A231E); // Dark Charcoal
  static const Color textSecondary = Color(0xFF5A6B61); // Medium Gray
  static const Color textTertiary = Color(0xFF8B978F); // Light Gray
  static const Color textDisabled = Color(0xFFB8C2BB); // Disabled Gray
 
  // Status Colors
  static const Color success = Color(0xFF1A7F3E); // Emerald Success
  static const Color successMuted = Color(0xFFE9F4E8);
 
  static const Color warning = Color(0xFF8A5700); // Amber Warning (text-safe)
  static const Color warningMuted = Color(0xFFFFF3D9);
 
  static const Color danger = Color(0xFFB42318); // Red Danger
  static const Color dangerMuted = Color(0xFFFCEAE8);
 
  static const Color info = Color(0xFF236A7E); // Teal Info
  static const Color infoMuted = Color(0xFFE9F3F6);
 
  // Accent Colors
  static const Color accent = Color(0xFF5D8C5A); // Moss Green
  static const Color accentMuted = Color(0xFFECF3EB);
 
  // ---- Added for redesign widgets / backward compatibility ----
  static const Color primaryGlow = Color(0xFF52B788); // Fresh Green
  static const Color primaryDim = primaryDark;
  static const Color amber = Color(0xFFE9A23B); // icons/fills only, not text
  static const Color weatherBlue = Color(0xFF236A7E);
  static const Color weatherBlueMuted = Color(0xFFE9F3F6);
 
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF347A4D), Color(0xFF173D2A)],
  );
}
 
class AppSpacing {
  static const double xSmall = 4;
  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double xLarge = 24;
  static const double xxLarge = 32;
}
 
class AppRadii {
  static const double small = 8;
  static const double control = 12;
  static const double card = 16;
  static const double large = 22;
}
 
class AppShadows {
  static List<BoxShadow> get card => [
        BoxShadow(
          color: AppColors.primaryDark.withValues(alpha: 0.07),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];
}
 
class AppTypography {
  // Display - For brand moments (splash screen, hero sections)
  static const TextStyle display = TextStyle(
    fontSize: 32,
    height: 1.1,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
 
  // Headline - Main page titles
  static const TextStyle headline = TextStyle(
    fontSize: 28,
    height: 1.15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.25,
  );
 
  // Title - Section headers, card titles
  static const TextStyle title = TextStyle(
    fontSize: 24,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
 
  // Section Title - Subsection headers
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    height: 1.25,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
 
  // Body - Main content text
  static const TextStyle body = TextStyle(
    fontSize: 17,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
 
  // Body Secondary - Supporting text
  static const TextStyle bodySecondary = TextStyle(
    fontSize: 15,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
 
  // Caption - Small labels, metadata
  static const TextStyle caption = TextStyle(
    fontSize: 13,
    height: 1.4,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
  );
 
  // Label - Button labels, form labels
  static const TextStyle label = TextStyle(
    fontSize: 15,
    height: 1.4,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
 
  // Mono - Technical data, codes
  static const TextStyle mono = TextStyle(
    fontSize: 14,
    height: 1.4,
    fontFamily: 'monospace',
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}
 
class AppTheme {
  static const SystemUiOverlayStyle systemUiOverlay = SystemUiOverlayStyle(
    statusBarColor: AppColors.background,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
 
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'sans-serif',
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryMuted,
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.primaryDark,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.surfaceElevated,
        onSecondaryContainer: AppColors.textPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.danger,
        onError: Colors.white,
        outline: AppColors.border,
        outlineVariant: AppColors.border,
      ),
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'sans-serif',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: AppTypography.headline,
        titleLarge: AppTypography.title,
        titleMedium: AppTypography.sectionTitle,
        bodyLarge: AppTypography.body,
        bodyMedium: AppTypography.bodySecondary,
        bodySmall: AppTypography.caption,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 1,
        shadowColor: AppColors.primaryDark.withValues(alpha: 0.06),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        disabledColor: AppColors.surfaceElevated,
        selectedColor: AppColors.primary,
        secondarySelectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        showCheckmark: false,
        labelStyle: AppTypography.caption.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: AppTypography.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.xSmall,
        ),
        side: const BorderSide(color: AppColors.border),
        shape: const StadiumBorder(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.control),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border),
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.control),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(48, 48),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: CircleBorder(),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.border,
        ),
      ),
      dividerColor: AppColors.border,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
    );
  }
}
 