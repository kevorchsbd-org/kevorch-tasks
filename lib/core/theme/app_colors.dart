import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette (Neutral-First Premium SaaS: #635BFF)
  static const Color primary = Color(0xFF635BFF);
  static const Color primaryDark = Color(0xFF5148D8);
  static const Color primaryLight = Color(0xFFEEECFF);

  // Legacy Aliases to Primary
  static const Color primaryRed = primary;
  static const Color primaryRedDark = primaryDark;
  static const Color primaryRedLight = primaryLight;

  // Modern Neutral System
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFF8FAFC);
  static const Color surfaceGlass = Color(0xADFFFFFF);

  static const Color textPrimary = Color(0xFF101828);
  static const Color textSecondary = Color(0xFF475467);
  static const Color textMuted = Color(0xFF98A2B3);

  static const Color border = Color(0xFFE4E7EC);
  static const Color borderGray = border;

  // Grays / Neutrals (Compatible)
  static const Color black = textPrimary;
  static const Color pureBlack = Color(0xFF000000);
  static const Color darkGray = Color(0xFF344054);
  static const Color mediumGray = textSecondary;
  static const Color lightGray = textMuted;
  static const Color surfaceGray = Color(0xFFF8FAFC);
  static const Color white = surface;

  // Semantic Colors
  static const Color success = Color(0xFF12B76A);
  static const Color successLight = Color(0xFFECFDF3);
  static const Color successGreen = success;

  static const Color warning = Color(0xFFF79009);
  static const Color warningLight = Color(0xFFFFFAEB);

  static const Color danger = Color(0xFFF04438);
  static const Color dangerLight = Color(0xFFFEF3F2);

  static const Color info = Color(0xFF2E90FA);
  static const Color infoLight = Color(0xFFEFF8FF);

  static const Color cardShadow = Color(0x0C101828);
  static const Color subtleShadow = Color(0x08000000);
}
