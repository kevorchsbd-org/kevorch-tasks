import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.white,
      primaryColor: AppColors.primaryRed,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryRed,
        surface: AppColors.white,
        onSurface: AppColors.black,
        error: AppColors.primaryRed,
      ),
      applyElevationOverlayColor: false,
      dividerTheme: const DividerThemeData(
        color: AppColors.borderGray,
        thickness: 1,
        space: 1,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(70, 34),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.white,
          textStyle: GoogleFonts.sora(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(70, 34),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: const BorderSide(color: AppColors.borderGray, width: 1.5),
          foregroundColor: AppColors.black,
          textStyle: GoogleFonts.sora(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(56, 30),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          foregroundColor: AppColors.primaryRed,
          textStyle: GoogleFonts.sora(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.black),
      ),
    );
  }
}
