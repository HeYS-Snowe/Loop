import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class AnimatedPageWrapper extends StatelessWidget {
  final Widget child;
  final int index;
  final bool enableSlide;

  const AnimatedPageWrapper({
    super.key,
    required this.child,
    this.index = 0,
    this.enableSlide = true,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + index * 80),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: enableSlide
                ? Offset(0, (1.0 - value) * 20)
                : Offset.zero,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class StaggeredList extends StatelessWidget {
  final List<Widget> children;
  final Duration delay;
  final double slideOffset;

  const StaggeredList({
    super.key,
    required this.children,
    this.delay = const Duration(milliseconds: 60),
    this.slideOffset = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < children.length; i++)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 400 + i * delay.inMilliseconds),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1.0 - value) * slideOffset),
                  child: child,
                ),
              );
            },
            child: children[i],
          ),
      ],
    );
  }
}

class AnimatedScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double minScale;
  final Duration duration;

  const AnimatedScaleButton({
    super.key,
    required this.child,
    this.onTap,
    this.minScale = 0.94,
    this.duration = const Duration(milliseconds: 150),
  });

  @override
  State<AnimatedScaleButton> createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<AnimatedScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.minScale).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

class GlowIcon extends StatefulWidget {
  final IconData icon;
  final Color? color;
  final double size;
  final double glowRadius;
  final double glowOpacity;

  const GlowIcon({
    super.key,
    required this.icon,
    this.color,
    this.size = 24,
    this.glowRadius = 12,
    this.glowOpacity = 0.3,
  });

  @override
  State<GlowIcon> createState() => _GlowIconState();
}

class _GlowIconState extends State<GlowIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.primary;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final glowIntensity = 0.5 + _controller.value * 0.5;
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: widget.glowOpacity * glowIntensity),
                blurRadius: widget.glowRadius * glowIntensity,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            color: color,
            size: widget.size,
          ),
        );
      },
    );
  }
}

class ShimmerText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Color? shimmerColor;

  const ShimmerText({
    super.key,
    required this.text,
    this.style,
    this.shimmerColor,
  });

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shimmerColor = widget.shimmerColor ?? AppColors.primary;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (kIsWeb) {
          return Opacity(
            opacity: 0.7 + _controller.value * 0.3,
            child: Text(
              widget.text,
              style: widget.style,
            ),
          );
        }
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                (widget.style?.color ?? AppColors.textPrimary),
                shimmerColor,
                (widget.style?.color ?? AppColors.textPrimary),
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((s) => s.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: Text(
            widget.text,
            style: widget.style,
          ),
        );
      },
    );
  }
}
