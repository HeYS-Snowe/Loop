import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color backgroundDeep = Color(0xFF0A0E1A);
  static const Color background = Color(0xFF0F1423);
  static const Color surface = Color(0xFF161B2E);
  static const Color surfaceLight = Color(0xFF1E2440);
  static const Color card = Color(0xFF1A2038);

  static const Color primary = Color(0xFF00E5A0);
  static const Color primaryLight = Color(0xFF33EDBA);
  static const Color primaryDark = Color(0xFF00B87D);
  static const Color primaryMuted = Color(0xFF0D3D2E);

  static const Color accent = Color(0xFF00BCD4);
  static const Color accentLight = Color(0xFF4DD0E1);

  static const Color warmAccent = Color(0xFFFF6B4A);
  static const Color warmAccentLight = Color(0xFFFF8A65);

  static const Color gold = Color(0xFFFFD54F);
  static const Color goldMuted = Color(0xFF3D3520);

  static const Color success = Color(0xFF00E676);
  static const Color successLight = Color(0xFF69F0AE);
  static const Color successMuted = Color(0xFF0D3D2A);

  static const Color warning = Color(0xFFFFB74D);
  static const Color warningMuted = Color(0xFF3D2E1A);

  static const Color error = Color(0xFFFF5252);
  static const Color errorLight = Color(0xFFFF8A80);
  static const Color errorMuted = Color(0xFF3D1A1A);

  static const Color textPrimary = Color(0xFFF0F2F5);
  static const Color textSecondary = Color(0xFF8B95A8);
  static const Color textTertiary = Color(0xFF4A5568);
  static const Color textHint = Color(0xFF2D3748);

  static const Color divider = Color(0xFF1E2744);
  static const Color border = Color(0xFF252D4A);

  static const Color glassBackground = Color(0x1A203880);
  static const Color glassBorder = Color(0x30FFFFFF);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment(-1.0, -1.0),
    end: Alignment(1.0, 1.0),
    colors: [Color(0xFF00E5A0), Color(0xFF00BCD4)],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment(-1.0, 0.0),
    end: Alignment(1.0, 0.0),
    colors: [Color(0xFFFF6B4A), Color(0xFFFFD54F)],
  );

  static const LinearGradient progressGradient = LinearGradient(
    colors: [Color(0xFF00E5A0), Color(0xFF00BCD4)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F1423),
      Color(0xFF162033),
      Color(0xFF0F1423),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const RadialGradient glowPrimary = RadialGradient(
    colors: [Color(0x4000E5A0), Color(0x00000000)],
    radius: 0.6,
  );

  static const RadialGradient glowWarm = RadialGradient(
    colors: [Color(0x40FF6B4A), Color(0x00000000)],
    radius: 0.6,
  );

  static const LinearGradient cardEdgeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment(0.3, 0.3),
    colors: [
      Color(0x20FFFFFF),
      Color(0x00FFFFFF),
    ],
  );

  static const LinearGradient cornerAccentGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment(0.5, 0.0),
    colors: [
      Color(0x1800E5A0),
      Color(0x00FFFFFF),
    ],
  );

  static const LinearGradient multiColorGradient = LinearGradient(
    begin: Alignment(-0.5, -1.0),
    end: Alignment(1.0, 0.5),
    colors: [
      Color(0x1500E5A0),
      Color(0x1000BCD4),
      Color(0x0AFF6B4A),
    ],
  );
}
