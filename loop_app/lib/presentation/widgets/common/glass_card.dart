import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final double blur;
  final Color? tintColor;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final LinearGradient? gradient;
  final List<BoxShadow>? boxShadow;
  final bool showCornerAccent;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 20,
    this.blur = 24,
    this.tintColor,
    this.borderColor,
    this.borderWidth = 0.5,
    this.onTap,
    this.gradient,
    this.boxShadow,
    this.showCornerAccent = false,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: GestureDetector(
        onTapDown: widget.onTap != null ? (_) => _onTapDown() : null,
        onTapUp: widget.onTap != null ? (_) => _onTapUp() : null,
        onTapCancel: widget.onTap != null ? _onTapCancel : null,
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: widget.boxShadow ??
                  [
                    BoxShadow(
                      color: AppColors.backgroundDeep.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
              gradient: widget.gradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: kIsWeb
                        ? [
                            AppColors.surface.withValues(alpha: 0.95),
                            AppColors.card.withValues(alpha: 0.85),
                          ]
                        : [
                            AppColors.surface.withValues(alpha: 0.75),
                            AppColors.card.withValues(alpha: 0.6),
                          ],
                  ),
              border: Border.all(
                color: widget.borderColor ??
                    AppColors.glassBorder.withValues(alpha: widget.borderWidth == 0 ? 0 : 0.12),
                width: widget.borderWidth,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: kIsWeb
                  ? _buildWebContent()
                  : BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: widget.blur,
                        sigmaY: widget.blur,
                      ),
                      child: _buildContent(),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        Padding(
          padding: widget.padding,
          child: widget.child,
        ),
        if (widget.showCornerAccent)
          Positioned(
            top: 0,
            right: 0,
            width: widget.borderRadius * 2,
            height: widget.borderRadius * 2,
            child: ClipRect(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment(0.0, 1.0),
                    colors: [
                      AppColors.primary.withValues(alpha: 0.08),
                      AppColors.primary.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWebContent() {
    return _buildContent();
  }

  void _onTapDown() {
    setState(() => _scale = 0.97);
  }

  void _onTapUp() {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }
}
