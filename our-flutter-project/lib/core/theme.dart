import 'package:flutter/material.dart';

// Design System: "The Gentle Guardian" — Soft Precision
// Colors from Tailwind config in UI HTML files

class AppColors {
  // Primary — Navy blue trust
  static const primary = Color(0xFF003E74);
  static const primaryContainer = Color(0xFF1A5694);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryFixed = Color(0xFFD4E3FF);
  static const primaryFixedDim = Color(0xFFA4C9FF);

  // Secondary — Atmosphere
  static const secondary = Color(0xFF526069);
  static const secondaryContainer = Color(0xFFD3E2ED);
  static const secondaryFixed = Color(0xFFD6E5EF);
  static const onSecondaryContainer = Color(0xFF56656E);

  // Tertiary — Warm gold vitality
  static const tertiary = Color(0xFF5C3400);
  static const tertiaryContainer = Color(0xFF7D4800);
  static const tertiaryFixed = Color(0xFFFFDCBE);
  static const tertiaryFixedDim = Color(0xFFFFB870);

  // Surfaces
  static const surface = Color(0xFFF9F9FF);
  static const surfaceDim = Color(0xFFD9DADF);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF3F3F9);
  static const surfaceContainer = Color(0xFFEDEDF3);
  static const surfaceContainerHigh = Color(0xFFE7E8EE);
  static const surfaceVariant = Color(0xFFE1E2E8);

  // On-colors
  static const onSurface = Color(0xFF191C20);
  static const onSurfaceVariant = Color(0xFF424750);
  static const onBackground = Color(0xFF191C20);

  // Utility
  static const outline = Color(0xFF727781);
  static const outlineVariant = Color(0xFFC2C6D2);
  static const error = Color(0xFFBA1A1A);
  static const errorContainer = Color(0xFFFFDAD6);

  // Semantic
  static const success = Color(0xFF2E7D32);
  static const warning = Color(0xFFFF9800);

  // Legacy aliases — maps old names to new design system
  static const textPrimary = onSurface;
  static const textSecondary = onSurfaceVariant;
  static const background = surface;
  static const checkedIn = success;
  static const pending = outlineVariant;
  static const overdue = warning;
  static const accent = success;
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.primary,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.surface,
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.onSurface,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surfaceContainerLowest,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9999),
            ),
            elevation: 0,
            textStyle: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9999),
            ),
            side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.surfaceContainerLowest,
          indicatorColor: AppColors.primaryFixed,
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
          side: BorderSide.none,
        ),
      );
}
