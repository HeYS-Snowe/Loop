import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class Particle {
  double x;
  double y;
  double size;
  double speedX;
  double speedY;
  double opacity;
  Color color;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
    required this.color,
  });
}

class ParticleBackground extends StatefulWidget {
  final int particleCount;
  final Color? baseColor;
  final Widget? child;

  const ParticleBackground({
    super.key,
    this.particleCount = 30,
    this.baseColor,
    this.child,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> _particles = [];
  final Random _random = Random(42);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    _particles = List.generate(widget.particleCount, (_) => _createParticle());
  }

  Particle _createParticle() {
    final colors = [
      AppColors.primary.withValues(alpha: 0.15),
      AppColors.accent.withValues(alpha: 0.1),
      AppColors.warmAccent.withValues(alpha: 0.08),
      AppColors.gold.withValues(alpha: 0.06),
      widget.baseColor?.withValues(alpha: 0.12) ?? AppColors.primary.withValues(alpha: 0.1),
    ];
    return Particle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * 2.5 + 0.5,
      speedX: (_random.nextDouble() - 0.5) * 0.0003,
      speedY: (_random.nextDouble() - 0.5) * 0.0003,
      opacity: _random.nextDouble() * 0.5 + 0.1,
      color: colors[_random.nextInt(colors.length)],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (final particle in _particles) {
          particle.x += particle.speedX;
          particle.y += particle.speedY;

          if (particle.x < -0.05) particle.x = 1.05;
          if (particle.x > 1.05) particle.x = -0.05;
          if (particle.y < -0.05) particle.y = 1.05;
          if (particle.y > 1.05) particle.y = -0.05;
        }

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _ParticlePainter(_particles),
              ),
            ),
            if (widget.child != null) widget.child!,
          ],
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;

      final center = Offset(
        particle.x * size.width,
        particle.y * size.height,
      );

      canvas.drawCircle(center, particle.size, paint);

      if (!kIsWeb) {
        final glowPaint = Paint()
          ..color = particle.color.withValues(alpha: particle.opacity * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

        canvas.drawCircle(center, particle.size * 3, glowPaint);
      } else {
        final glowPaint = Paint()
          ..color = particle.color.withValues(alpha: particle.opacity * 0.15)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(center, particle.size * 4, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
