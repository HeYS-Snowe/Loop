import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../l10n/generated/app_localizations.dart';

class LoopTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final String? title;

  const LoopTimePicker({super.key, required this.initialTime, this.title});

  static Future<TimeOfDay?> show(BuildContext context, {required TimeOfDay initialTime, String? title}) {
    return showGeneralDialog<TimeOfDay>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Time Picker',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: LoopTimePicker(initialTime: initialTime, title: title),
        );
      },
    );
  }

  @override
  State<LoopTimePicker> createState() => _LoopTimePickerState();
}

class _LoopTimePickerState extends State<LoopTimePicker> with TickerProviderStateMixin {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late AnimationController _confirmController;

  int _selectedHour = 0;
  int _selectedMinute = 0;

  static const double _itemExtent = 52.0;
  static const int _visibleItemCount = 5;
  static const double _wheelHeight = _itemExtent * _visibleItemCount;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialTime.hour;
    _selectedMinute = widget.initialTime.minute;
    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController = FixedExtentScrollController(initialItem: _selectedMinute);
    _confirmController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: math.min(MediaQuery.of(context).size.width * 0.88, 380),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surface.withValues(alpha: 0.95),
              AppColors.card.withValues(alpha: 0.9),
            ],
          ),
          border: Border.all(
            color: AppColors.glassBorder.withValues(alpha: 0.15),
            width: 0.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 40,
              offset: Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildTimeDisplay(),
            const SizedBox(height: 20),
            _buildWheelSection(),
            const SizedBox(height: 24),
            _buildActions(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final displayTitle = widget.title ?? S.of(context)!.timePickerDefaultTitle;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: const Icon(
                Icons.schedule_rounded,
                color: AppColors.backgroundDeep,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(displayTitle, style: TextStyles.heading4),
                const SizedBox(height: 2),
                Text(S.of(context)!.timePicker24Hour, style: TextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDisplay() {
    final hourStr = _selectedHour.toString().padLeft(2, '0');
    final minuteStr = _selectedMinute.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.accent.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTimeDigit(hourStr),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              ':',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                height: 1.0,
              ),
            ),
          ),
          _buildTimeDigit(minuteStr),
        ],
      ),
    );
  }

  Widget _buildTimeDigit(String value) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        );
      },
      child: Text(
        value,
        key: ValueKey(value),
        style: const TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: 2,
          height: 1.0,
        ),
      ),
    );
  }

  Widget _buildWheelSection() {
    final s = S.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: _wheelHeight,
        child: Row(
          children: [
            Expanded(
              child: _buildWheel(
                controller: _hourController,
                itemCount: 24,
                selectedItem: _selectedHour,
                unit: s.hourUnit,
                onChanged: (index) {
                  setState(() => _selectedHour = index);
                },
              ),
            ),
            _buildWheelSeparator(),
            Expanded(
              child: _buildWheel(
                controller: _minuteController,
                itemCount: 60,
                selectedItem: _selectedMinute,
                unit: s.minuteUnit,
                onChanged: (index) {
                  setState(() => _selectedMinute = index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWheelSeparator() {
    return SizedBox(
      width: 48,
      height: _wheelHeight,
      child: Center(
        child: Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required int selectedItem,
    required String unit,
    required ValueChanged<int> onChanged,
  }) {
    return Stack(
      children: [
        Positioned.fill(
          child: Center(
            child: Container(
              height: _itemExtent,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.12),
                    AppColors.accent.withValues(alpha: 0.06),
                  ],
                ),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),
        NotificationListener<ScrollNotification>(
          onNotification: (_) => true,
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: _itemExtent,
            diameterRatio: 1.8,
            perspective: 0.003,
            physics: const FixedExtentScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: itemCount,
              builder: (context, index) {
                final isSelected = index == selectedItem;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: isSelected ? 26 : 18,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textTertiary,
                          letterSpacing: isSelected ? 1.0 : 0.0,
                        ),
                        child: Text(index.toString().padLeft(2, '0')),
                      ),
                      const SizedBox(width: 4),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: isSelected ? 12.0 : 10.0,
                          fontWeight: FontWeight.w400,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textTertiary,
                        ),
                        child: Text(unit),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.surfaceLight,
                  border: Border.all(
                    color: AppColors.border,
                    width: 0.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  S.of(context)!.cancel,
                  style: TextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                final result = TimeOfDay(
                  hour: _selectedHour,
                  minute: _selectedMinute,
                );
                Navigator.of(context).pop(result);
              },
              child: AnimatedBuilder(
                animation: _confirmController,
                builder: (context, child) {
                  final scale = 1.0 - _confirmController.value * 0.03;
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    S.of(context)!.confirm,
                    style: TextStyles.button.copyWith(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
