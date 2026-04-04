import 'package:flutter/material.dart';
import 'package:loop/core/theme/colors.dart';

enum GradientStyle {
  primary,
  accent,
  success,
  error,
  primaryToAccent,
  warm,
  cool,
  aurora,
  sunset,
  forest,
  ocean,
}

class GradientDecoration {
  GradientDecoration._();

  static BoxDecoration get primary => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00E8B8), Color(0xFF00A5D4)],
        ),
      );

  static BoxDecoration get accent => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFAE1A), Color(0xFFFF6B5A)],
        ),
      );

  static BoxDecoration get success => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3DD68C), Color(0xFF00E8B8)],
        ),
      );

  static BoxDecoration get error => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFB6F7A), Color(0xFFFF6B5A)],
        ),
      );

  static BoxDecoration get primaryToAccent => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00E8B8), Color(0xFFFFAE1A)],
        ),
      );

  static BoxDecoration get warm => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF6B5A), Color(0xFFFFAE1A), Color(0xFFFFD866)],
          stops: [0.0, 0.5, 1.0],
        ),
      );

  static BoxDecoration get cool => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00E8B8), Color(0xFF4BB8F0)],
        ),
      );

  static BoxDecoration get aurora => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF00E8B8), Color(0xFF4BB8F0), Color(0xFF22D3EE)],
          stops: [0.0, 0.5, 1.0],
        ),
      );

  static BoxDecoration get sunset => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFFF6B5A), Color(0xFFFFAE1A), Color(0xFFFFD866)],
          stops: [0.0, 0.5, 1.0],
        ),
      );

  static BoxDecoration get forest => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF3DD68C), Color(0xFF00E8B8), Color(0xFF22D3EE)],
          stops: [0.0, 0.5, 1.0],
        ),
      );

  static BoxDecoration get ocean => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF00A5D4),
            Color(0xFF00E8B8),
            Color(0xFF4BB8F0),
            Color(0xFF22D3EE),
          ],
          stops: [0.0, 0.33, 0.66, 1.0],
        ),
      );

  static BoxDecoration fromStyle(GradientStyle style) {
    switch (style) {
      case GradientStyle.primary:
        return primary;
      case GradientStyle.accent:
        return accent;
      case GradientStyle.success:
        return success;
      case GradientStyle.error:
        return error;
      case GradientStyle.primaryToAccent:
        return primaryToAccent;
      case GradientStyle.warm:
        return warm;
      case GradientStyle.cool:
        return cool;
      case GradientStyle.aurora:
        return aurora;
      case GradientStyle.sunset:
        return sunset;
      case GradientStyle.forest:
        return forest;
      case GradientStyle.ocean:
        return ocean;
    }
  }
}

class GradientContainer extends StatelessWidget {
  final GradientStyle style;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;

  const GradientContainer({
    super.key,
    required this.style,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = GradientDecoration.fromStyle(style).copyWith(
      borderRadius: BorderRadius.circular(borderRadius),
    );

    return Container(
      margin: margin,
      padding: padding,
      decoration: decoration,
      child: child,
    );
  }
}

class CornerGlow extends StatelessWidget {
  final Alignment alignment;
  final Color color;
  final double radius;

  const CornerGlow({
    super.key,
    this.alignment = Alignment.topLeft,
    this.color = AppColors.primary,
    this.radius = 0.6,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: alignment,
          radius: radius,
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.0),
          ],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}
