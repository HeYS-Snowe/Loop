import 'package:flutter/material.dart';
import 'package:loop/core/theme/colors.dart';

class FadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double slideOffset;
  final FadeInDirection direction;
  final bool enableScale;

  const FadeInWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.delay = Duration.zero,
    this.slideOffset = 20.0,
    this.direction = FadeInDirection.up,
    this.enableScale = false,
  });

  @override
  State<FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;
  late Animation<double> _scale;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _slide = Tween<Offset>(
      begin: _getBeginOffset(),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _scale = Tween<double>(
      begin: widget.enableScale ? 0.92 : 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() => _started = true);
        _controller.forward();
      }
    });
  }

  Offset _getBeginOffset() {
    switch (widget.direction) {
      case FadeInDirection.up:
        return Offset(0, widget.slideOffset);
      case FadeInDirection.down:
        return Offset(0, -widget.slideOffset);
      case FadeInDirection.left:
        return Offset(-widget.slideOffset, 0);
      case FadeInDirection.right:
        return Offset(widget.slideOffset, 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) {
      return const SizedBox.shrink();
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: _slide.value,
            child: Transform.scale(
              scale: _scale.value,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

enum FadeInDirection { up, down, left, right }

class AnimatedProgressIndicator extends StatelessWidget {
  final double progress;
  final double height;
  final LinearGradient? gradient;
  final Color backgroundColor;
  final Duration duration;
  final Curve curve;
  final BorderRadius borderRadius;

  const AnimatedProgressIndicator({
    super.key,
    required this.progress,
    this.height = 6,
    this.gradient,
    this.backgroundColor = AppColors.surfaceElevated,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeInOutCubic,
    this.borderRadius = const BorderRadius.all(Radius.circular(3)),
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGradient =
        gradient ?? AppColors.progressGradient;

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: borderRadius,
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(end: progress.clamp(0.0, 1.0)),
              duration: duration,
              curve: curve,
              builder: (context, value, child) {
                return FractionallySizedBox(
                  widthFactor: value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: effectiveGradient,
                      borderRadius: borderRadius,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class StaggeredList extends StatelessWidget {
  final List<Widget> children;
  final Duration itemDuration;
  final Duration staggerDelay;
  final int maxItems;

  const StaggeredList({
    super.key,
    required this.children,
    this.itemDuration = const Duration(milliseconds: 400),
    this.staggerDelay = const Duration(milliseconds: 50),
    this.maxItems = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < children.length; i++)
          FadeInWidget(
            duration: itemDuration,
            delay: Duration(
              milliseconds: staggerDelay.inMilliseconds *
                  (i < maxItems ? i : maxItems),
            ),
            child: children[i],
          ),
      ],
    );
  }
}
