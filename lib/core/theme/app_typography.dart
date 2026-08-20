import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // Headings & Important Text -> Sora
  static TextStyle get pageTitle => GoogleFonts.sora(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
        letterSpacing: -0.5,
      );

  static TextStyle get welcomeMessage => GoogleFonts.sora(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
        letterSpacing: -0.3,
      );

  static TextStyle get summaryNumber => GoogleFonts.sora(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: AppColors.black,
        letterSpacing: -0.5,
      );

  static TextStyle get sectionTitle => GoogleFonts.sora(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
        letterSpacing: -0.3,
      );

  static TextStyle get cardTitle => GoogleFonts.sora(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );

  static TextStyle get button => GoogleFonts.sora(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
        letterSpacing: 0.2,
      );

  // Body & UI Text -> DM Sans
  static TextStyle get body => GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.darkGray,
      );

  static TextStyle get bodySecondary => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.mediumGray,
      );

  static TextStyle get label => GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.mediumGray,
      );

  static TextStyle get navigation => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.mediumGray,
      );
}
