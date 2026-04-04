import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../providers/check_in_provider.dart';
import '../../../domain/services/check_in_service.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/gradient_decorations.dart';
import '../../widgets/common/particle_background.dart';
import '../../widgets/common/animated_widgets.dart';

class CheckInPage extends ConsumerStatefulWidget {
  const CheckInPage({super.key});

  @override
  ConsumerState<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends ConsumerState<CheckInPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkInStateAsync = ref.watch(checkInNotifierProvider);
    final statsAsync = ref.watch(checkInStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('打卡', style: TextStyles.heading3),
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: GradientDecoration(
              style: GradientStyle.meshGradient,
            ),
          ),
          const Positioned.fill(
            child: ParticleBackground(
              particleCount: 20,
              baseColor: AppColors.warmAccent,
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedPageWrapper(
                      index: 0,
                      child: checkInStateAsync.when(
                        data: (state) => _buildCheckInButton(context, ref, state),
                        loading: () => const GlassCard(
                          child: SizedBox(height: 160),
                        ),
                        error: (_, __) => const GlassCard(
                          child: SizedBox(height: 160),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedPageWrapper(
                      index: 1,
                      child: statsAsync.when(
                        data: (stats) => _buildStatsRow(stats),
                        loading: () => const SizedBox(height: 80),
                        error: (_, __) => const SizedBox(height: 80),
                      ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedPageWrapper(
                      index: 2,
                      child: Text('打卡日历', style: TextStyles.heading4),
                    ),
                    const SizedBox(height: 12),
                    AnimatedPageWrapper(
                      index: 3,
                      child: _buildCalendar(context, ref),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInButton(
      BuildContext context, WidgetRef ref, CheckInState state) {
    return GlassCard(
      borderRadius: 24,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: state.checkedInToday
            ? [
                AppColors.successMuted.withValues(alpha: 0.6),
                AppColors.surface.withValues(alpha: 0.4),
              ]
            : [
                AppColors.surface.withValues(alpha: 0.8),
                AppColors.card.withValues(alpha: 0.6),
              ],
      ),
      showCornerAccent: !state.checkedInToday,
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final pulse = 0.5 + _pulseController.value * 0.5;
              return Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: state.checkedInToday
                        ? [
                            AppColors.success.withValues(alpha: 0.15 + pulse * 0.1),
                            AppColors.success.withValues(alpha: 0.05),
                          ]
                        : [
                            AppColors.primary.withValues(alpha: 0.15 + pulse * 0.1),
                            AppColors.accent.withValues(alpha: 0.05),
                          ],
                  ),
                  border: Border.all(
                    color: state.checkedInToday
                        ? AppColors.success.withValues(alpha: 0.2 + pulse * 0.1)
                        : AppColors.primary.withValues(alpha: 0.2 + pulse * 0.1),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (state.checkedInToday
                              ? AppColors.success
                              : AppColors.primary)
                          .withValues(alpha: 0.15 * pulse),
                      blurRadius: 24 * pulse,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: state.checkedInToday
                      ? const Icon(
                          Icons.check_rounded,
                          size: 48,
                          color: AppColors.success,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${state.streakCount}',
                              style: TextStyles.heading1.copyWith(
                                color: AppColors.primary,
                                fontSize: 32,
                              ),
                            ),
                            Text(
                              '天',
                              style: TextStyles.caption.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            state.checkedInToday ? '今日已打卡' : '点击打卡',
            style: TextStyles.heading4.copyWith(
              color: state.checkedInToday
                  ? AppColors.success
                  : AppColors.textPrimary,
            ),
          ),
          if (!state.checkedInToday) ...[
            const SizedBox(height: 6),
            Text(
              '已连续 ${state.streakCount} 天',
              style: TextStyles.body2,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsRow(CheckInStats stats) {
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(vertical: 20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.surface.withValues(alpha: 0.7),
          AppColors.card.withValues(alpha: 0.5),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('连续打卡', '${stats.currentStreak}', AppColors.warmAccent),
          Container(width: 1, height: 32, color: AppColors.divider),
          _buildStatItem('最长记录', '${stats.maxStreak}', AppColors.gold),
          Container(width: 1, height: 32, color: AppColors.divider),
          _buildStatItem('累计打卡', '${stats.totalDays}', AppColors.accent),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyles.statValue.copyWith(fontSize: 24, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyles.caption),
      ],
    );
  }

  Widget _buildCalendar(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(checkInStatsProvider);

    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(16),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.surface.withValues(alpha: 0.75),
          AppColors.card.withValues(alpha: 0.55),
        ],
      ),
      child: statsAsync.when(
        data: (stats) => TableCalendar(
          firstDay: DateTime(2024, 1, 1),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onDaySelected: (selected, focused) {
            setState(() {
              _focusedDay = focused;
            });
          },
          headerVisible: true,
          daysOfWeekHeight: 40,
          rowHeight: 48,
          headerStyle: HeaderStyle(
            formatButtonVisible: true,
            formatButtonDecoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            formatButtonTextStyle:
                TextStyles.label.copyWith(color: AppColors.primary),
            titleTextStyle: TextStyles.heading4,
            titleCentered: false,
            leftChevronIcon: Icon(
              Icons.chevron_left_rounded,
              color: AppColors.textSecondary,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyles.label.copyWith(
              color: AppColors.textSecondary,
            ),
            weekendStyle: TextStyles.label.copyWith(
              color: AppColors.warmAccent.withValues(alpha: 0.7),
            ),
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              final isToday = _isSameDay(day, DateTime.now());
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isToday
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyles.body1.copyWith(
                      color: isToday
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
            selectedBuilder: (context, day, focusedDay) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyles.body1.copyWith(
                      color: AppColors.backgroundDeep,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
            markerBuilder: (context, date, events) {
              final isChecked = stats.checkedInDates.any(
                (d) => _isSameDay(d, date),
              );
              if (isChecked) {
                return Positioned(
                  bottom: 2,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.success.withValues(alpha: 0.4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return null;
            },
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            isTodayHighlighted: false,
          ),
        ),
        loading: () => const SizedBox(height: 300),
        error: (_, __) => const SizedBox(height: 300),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
