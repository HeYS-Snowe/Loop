import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:loop/core/theme/colors.dart';

class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? tintColor;
  final double fillOpacity;
  final double blurSigma;
  final double borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final double? height;
  final bool enableTapScale;
  final double tapScaleFactor;
  final Gradient? backgroundGradient;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    this.tintColor,
    this.fillOpacity = 0.78,
    this.blurSigma = 16,
    this.borderRadius = 16,
    this.borderColor,
    this.borderWidth = 1.0,
    this.boxShadow,
    this.width,
    this.height,
    this.enableTapScale = false,
    this.tapScaleFactor = 0.97,
    this.backgroundGradient,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.tapScaleFactor)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.enableTapScale) _controller.forward();
  }

  void _onTapUp(TapUpDetails _) {
    if (widget.enableTapScale) _controller.reverse();
  }

  void _onTapCancel() {
    if (widget.enableTapScale) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final tintColor = widget.tintColor ?? AppColors.surface;
    final effectiveBorderColor =
        widget.borderColor ?? AppColors.glassBorder;
    final effectiveBoxShadow = widget.boxShadow ??
        [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ];

    Widget content = Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.blurSigma,
            sigmaY: widget.blurSigma,
          ),
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              color: tintColor.withOpacity(widget.fillOpacity),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: effectiveBorderColor,
                width: widget.borderWidth,
              ),
              boxShadow: effectiveBoxShadow,
              gradient: widget.backgroundGradient,
            ),
            child: widget.child,
          ),
        ),
      ),
    );

    if (widget.enableTapScale) {
      content = GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: content,
        ),
      );
    }

    return content;
  }
}
