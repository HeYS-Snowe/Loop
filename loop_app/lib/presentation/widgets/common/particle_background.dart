import 'dart:math';
import 'package:flutter/material.dart';
import 'package:loop/core/theme/colors.dart';

class ParticleBackground extends StatefulWidget {
  final int particleCount;
  final Color particleColor;
  final bool enableGlow;

  const ParticleBackground({
    super.key,
    this.particleCount = 20,
    this.particleColor = AppColors.primary,
    this.enableGlow = false,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    final random = Random(42);
    _particles = List.generate(widget.particleCount, (index) {
      return _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 1.0 + random.nextDouble() * 2.0,
        speed: 0.2 + random.nextDouble() * 0.6,
        opacity: 0.08 + random.nextDouble() * 0.07,
        phase: random.nextDouble() * 2 * pi,
        driftX: (random.nextDouble() - 0.5) * 0.3,
      );
    });
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
        return CustomPaint(
          painter: _ParticlePainter(
            particles: _particles,
            progress: _controller.value,
            color: widget.particleColor,
            enableGlow: widget.enableGlow,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;
  final double phase;
  final double driftX;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.phase,
    required this.driftX,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;
  final bool enableGlow;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
    this.enableGlow = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final t = progress * 30 * p.speed;
      final breathe = sin(t * 0.5 + p.phase) * 0.5 + 0.5;
      final currentOpacity = p.opacity * (0.6 + breathe * 0.4);

      double px = (p.x + sin(t * 0.3 + p.phase) * p.driftX * 0.1) % 1.0;
      double py = (p.y - t * p.speed * 0.005) % 1.0;
      if (py < 0) py += 1.0;
      if (px < 0) px += 1.0;

      final dx = px * size.width;
      final dy = py * size.height;

      paint.color = color.withOpacity(currentOpacity);

      if (enableGlow) {
        paint.maskFilter =
            const MaskFilter.blur(BlurStyle.normal, 3);
      }

      canvas.drawCircle(Offset(dx, dy), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
