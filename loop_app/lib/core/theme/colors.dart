import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0A0E16);
  static const Color backgroundDeep = Color(0xFF060911);
  static const Color surface = Color(0xFF121A28);
  static const Color surfaceLight = Color(0xFF1A2435);
  static const Color surfaceElevated = Color(0xFF253147);

  static const Color primary = Color(0xFF00E8B8);
  static const Color primaryLight = Color(0xFF3DF0CC);
  static const Color primaryDark = Color(0xFF00C49C);
  static const Color primaryMuted = Color(0x1A00E8B8);
  static const Color primarySubtle = Color(0x0D00E8B8);

  static const Color accent = Color(0xFFFFAE1A);
  static const Color accentLight = Color(0xFFFFC44D);
  static const Color accentDark = Color(0xFFE09500);
  static const Color accentMuted = Color(0x1AFFAE1A);

  static const Color coral = Color(0xFFFF6B5A);
  static const Color coralLight = Color(0xFFFF8D80);

  static const Color textPrimary = Color(0xFFEFF3F8);
  static const Color textSecondary = Color(0xFF8494A7);
  static const Color textTertiary = Color(0xFF5A6A7E);
  static const Color textHint = Color(0xFF3E4E62);
  static const Color textOnPrimary = Color(0xFF061018);
  static const Color textOnAccent = Color(0xFF1A0E00);

  static const Color success = Color(0xFF3DD68C);
  static const Color successLight = Color(0xFF6DE0A8);
  static const Color successMuted = Color(0x1A3DD68C);

  static const Color warning = Color(0xFFFBBF24);
  static const Color warningLight = Color(0xFFFCD34D);
  static const Color warningMuted = Color(0x1AFBBF24);

  static const Color error = Color(0xFFFB6F7A);
  static const Color errorLight = Color(0xFFFC9CA3);
  static const Color errorMuted = Color(0x1AFB6F7A);

  static const Color info = Color(0xFF4BB8F0);
  static const Color infoLight = Color(0xFF7CCDF5);
  static const Color infoMuted = Color(0x1A4BB8F0);

  static const Color border = Color(0xFF1C2838);
  static const Color borderLight = Color(0xFF2A3A4E);
  static const Color divider = Color(0x991C2838);
  static const Color dividerLight = Color(0x4D1C2838);

  static const Color glassFill = Color(0x0FFFFFFF);
  static const Color glassBorder = Color(0x1AFFFFFF);
  static const Color glassHighlight = Color(0x2EFFFFFF);
  static const Color shadowDefault = Color(0x40000000);
  static const Color shadowLight = Color(0x1F000000);

  static const List<Color> cardColors = [
    Color(0xFF00E8B8),
    Color(0xFFFFAE1A),
    Color(0xFFFF6B5A),
    Color(0xFF4BB8F0),
    Color(0xFF3DD68C),
    Color(0xFFFF8C42),
    Color(0xFFE879F9),
    Color(0xFF22D3EE),
    Color(0xFFF472B6),
    Color(0xFFA3E635),
  ];

  static const LinearGradient progressGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF00E8B8), Color(0xFF3DD68C)],
  );

  static const LinearGradient progressGradientWarm = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFFFAE1A), Color(0xFFFF6B5A)],
  );

  static const LinearGradient progressGradientCool = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF00E8B8), Color(0xFF4BB8F0)],
  );
}
