import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

enum GradientStyle {
  diagonalFull,
  diagonalHalf,
  multiColor,
  cornerAccent,
  radialGlow,
  edgeShine,
  bottomFade,
  meshGradient,
}

class GradientDecoration extends StatelessWidget {
  final GradientStyle style;
  final Color? color;
  final Color? color2;
  final double opacity;

  const GradientDecoration({
    super.key,
    required this.style,
    this.color,
    this.color2,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: CustomPaint(
            painter: _GradientPainter(
              style: style,
              color: color,
              color2: color2,
              opacity: opacity,
            ),
          ),
        );
      },
    );
  }
}

class _GradientPainter extends CustomPainter {
  final GradientStyle style;
  final Color? color;
  final Color? color2;
  final double opacity;

  _GradientPainter({
    required this.style,
    this.color,
    this.color2,
    this.opacity = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final effectiveColor = (color ?? AppColors.primary).withValues(alpha: opacity);
    final effectiveColor2 = (color2 ?? AppColors.accent).withValues(alpha: opacity);

    switch (style) {
      case GradientStyle.diagonalFull:
        _paintDiagonalFull(canvas, size, effectiveColor, effectiveColor2);
        break;
      case GradientStyle.diagonalHalf:
        _paintDiagonalHalf(canvas, size, effectiveColor, effectiveColor2);
        break;
      case GradientStyle.multiColor:
        _paintMultiColor(canvas, size);
        break;
      case GradientStyle.cornerAccent:
        _paintCornerAccent(canvas, size, effectiveColor);
        break;
      case GradientStyle.radialGlow:
        _paintRadialGlow(canvas, size, effectiveColor);
        break;
      case GradientStyle.edgeShine:
        _paintEdgeShine(canvas, size, effectiveColor);
        break;
      case GradientStyle.bottomFade:
        _paintBottomFade(canvas, size, effectiveColor);
        break;
      case GradientStyle.meshGradient:
        _paintMeshGradient(canvas, size);
        break;
    }
  }

  void _paintDiagonalFull(Canvas canvas, Size size, Color c1, Color c2) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(-1, -1),
        end: const Alignment(1, 1),
        colors: [
          c1.withValues(alpha: 0.15),
          c2.withValues(alpha: 0.08),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _paintDiagonalHalf(Canvas canvas, Size size, Color c1, Color c2) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.6, 0)
      ..lineTo(0, size.height * 0.6)
      ..close();
    final rect = Rect.fromLTWH(0, 0, size.width * 0.6, size.height * 0.6);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(-1, -1),
        end: const Alignment(1, 1),
        colors: [
          c1.withValues(alpha: 0.12),
          c2.withValues(alpha: 0.04),
        ],
      ).createShader(rect);
    canvas.drawPath(path, paint);
  }

  void _paintMultiColor(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(-0.5, -1.0),
        end: const Alignment(1.0, 0.5),
        colors: [
          AppColors.primary.withValues(alpha: 0.1),
          AppColors.accent.withValues(alpha: 0.06),
          AppColors.warmAccent.withValues(alpha: 0.04),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _paintCornerAccent(Canvas canvas, Size size, Color color) {
    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.35)
      ..quadraticBezierTo(
        size.width * 0.65, size.height * 0.15,
        size.width * 0.7, 0,
      )
      ..close();
    final rect = Rect.fromLTWH(
      size.width * 0.65, 0,
      size.width * 0.35, size.height * 0.35,
    );
    final paint = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(1, -1),
        end: const Alignment(0.5, 0.5),
        colors: [
          color.withValues(alpha: 0.12),
          color.withValues(alpha: 0.02),
        ],
      ).createShader(rect);
    canvas.drawPath(path, paint);
  }

  void _paintRadialGlow(Canvas canvas, Size size, Color color) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.8, 0.2),
        radius: 0.5,
        colors: [
          color.withValues(alpha: 0.15),
          color.withValues(alpha: 0.05),
          color.withValues(alpha: 0),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _paintEdgeShine(Canvas canvas, Size size, Color color) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.3, 0)
      ..lineTo(0, size.height * 0.3)
      ..close();
    final rect = Rect.fromLTWH(0, 0, size.width * 0.3, size.height * 0.3);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(-1, -1),
        end: const Alignment(0.5, 0.5),
        colors: [
          color.withValues(alpha: 0.2),
          color.withValues(alpha: 0),
        ],
      ).createShader(rect);
    canvas.drawPath(path, paint);
  }

  void _paintBottomFade(Canvas canvas, Size size, Color color) {
    final rect = Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(0, -1),
        end: const Alignment(0, 1),
        colors: [
          color.withValues(alpha: 0),
          color.withValues(alpha: 0.08),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _paintMeshGradient(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint1 = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.2, 0.3),
        radius: 0.4,
        colors: [
          AppColors.primary.withValues(alpha: 0.06),
          AppColors.primary.withValues(alpha: 0),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint1);

    final paint2 = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.8, 0.7),
        radius: 0.35,
        colors: [
          AppColors.warmAccent.withValues(alpha: 0.04),
          AppColors.warmAccent.withValues(alpha: 0),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint2);

    final paint3 = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.5, 0.1),
        radius: 0.3,
        colors: [
          AppColors.accent.withValues(alpha: 0.05),
          AppColors.accent.withValues(alpha: 0),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint3);
  }

  @override
  bool shouldRepaint(covariant _GradientPainter oldDelegate) => false;
}

class GradientContainer extends StatelessWidget {
  final GradientStyle style;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? color;
  final Color? color2;
  final Color? borderColor;

  const GradientContainer({
    super.key,
    required this.child,
    this.style = GradientStyle.diagonalHalf,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 20,
    this.color,
    this.color2,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: AppColors.surface.withValues(alpha: 0.6),
        border: Border.all(
          color: borderColor ?? AppColors.glassBorder.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            GradientDecoration(
              style: style,
              color: color,
              color2: color2,
            ),
            Padding(
              padding: padding,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
