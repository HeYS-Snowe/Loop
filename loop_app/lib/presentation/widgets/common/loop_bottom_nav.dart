import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loop/core/theme/colors.dart';
import 'package:loop/core/theme/text_styles.dart';

class LoopBottomNav extends StatelessWidget {
  final Widget child;

  const LoopBottomNav({super.key, required this.child});

  static const _items = [
    _NavItem('/home', Icons.home_rounded, '首页'),
    _NavItem('/daily-plan', Icons.calendar_today_rounded, '日计划'),
    _NavItem('/summary', Icons.bar_chart_rounded, '统计'),
    _NavItem('/settings', Icons.settings_rounded, '设置'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _items.length; i++) {
      if (location.startsWith(_items[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: Container(
        height: 68,
        margin: const EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 12,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.glassBorder,
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowDefault,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < _items.length; i++)
                  _NavItemWidget(
                    item: _items[i],
                    isSelected: i == index,
                    onTap: () {
                      if (i != index) {
                        context.go(_items[i].path);
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String path;
  final IconData icon;
  final String label;

  const _NavItem(this.path, this.icon, this.label);
}

class _NavItemWidget extends StatefulWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavItemWidget> createState() => _NavItemWidgetState();
}

class _NavItemWidgetState extends State<_NavItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.1, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant _NavItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color =
        widget.isSelected ? AppColors.primary : AppColors.textTertiary;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: widget.isSelected
                      ? BoxDecoration(
                          color: AppColors.primaryMuted,
                          borderRadius: BorderRadius.circular(12),
                        )
                      : null,
                  child: Icon(
                    widget.item.icon,
                    color: color,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.item.label,
                style: TextStyles.labelSmall.copyWith(
                  color: color,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
