// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../providers/check_in_provider.dart';
import '../../widgets/common/animated_widgets.dart';

class CheckInPage extends ConsumerStatefulWidget {
  const CheckInPage({super.key});

  @override
  ConsumerState<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends ConsumerState<CheckInPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final checkInState = ref.watch(checkInNotifierProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(
        title: const Text('打卡', style: TextStyles.heading4),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundDeep, AppColors.background],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInWidget(
                  child: _buildCheckInCard(checkInState),
                ),
                const SizedBox(height: 24),
                FadeInWidget(
                  delay: const Duration(milliseconds: 100),
                  child: _buildCalendar(),
                ),
                const SizedBox(height: 24),
                FadeInWidget(
                  delay: const Duration(milliseconds: 200),
                  child: _buildStatsCard(checkInState),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckInCard(AsyncValue<CheckInState> checkInState) {
    return checkInState.when(
      data: (state) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: state.checkedIn
                  ? [AppColors.success, AppColors.successLight]
                  : [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (state.checkedIn ? AppColors.success : AppColors.primary)
                    .withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                state.checkedIn ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 64,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                state.checkedIn ? '今日已打卡' : '今日未打卡',
                style: TextStyles.heading3.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                '已连续 ${state.streakCount} 天',
                style: TextStyles.body2.copyWith(color: Colors.white.withOpacity(0.9)),
              ),
              const SizedBox(height: 24),
              if (!state.checkedIn)
                ElevatedButton(
                  onPressed: () {
                    ref.read(checkInNotifierProvider.notifier).checkIn();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text('立即打卡'),
                ),
            ],
          ),
        );
      },
      loading: () => _buildLoadingCard(),
      error: (e, _) => _buildErrorCard(e.toString()),
    );
  }

  Widget _buildCalendar() {
    final checkInRecordsAsync = ref.watch(checkInRecordsProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: checkInRecordsAsync.when(
        data: (records) {
          final checkInDays = records.map((r) => DateTime(
            r.date.year,
            r.date.month,
            r.date.day,
          )).toSet();

          return TableCalendar<DateTime>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              titleCentered: true,
              titleTextStyle: TextStyles.heading5,
              formatButtonVisible: false,
              leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
              rightChevronIcon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyles.caption,
              weekendStyle: TextStyles.caption.copyWith(color: AppColors.textTertiary),
            ),
            eventLoader: (day) {
              final normalizedDay = DateTime(day.year, day.month, day.day);
              return checkInDays.contains(normalizedDay) ? [day] : [];
            },
          );
        },
        loading: () => _buildLoadingCard(),
        error: (e, _) => _buildErrorCard(e.toString()),
      ),
    );
  }

  Widget _buildStatsCard(AsyncValue<CheckInState> checkInState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('打卡统计', style: TextStyles.heading5),
          const SizedBox(height: 16),
          checkInState.when(
            data: (state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    icon: Icons.local_fire_department,
                    label: '连续打卡',
                    value: '${state.streakCount}天',
                    color: AppColors.warning,
                  ),
                  _buildStatItem(
                    icon: Icons.emoji_events,
                    label: '最长记录',
                    value: '${state.maxStreak}天',
                    color: AppColors.success,
                  ),
                  _buildStatItem(
                    icon: Icons.calendar_today,
                    label: '累计打卡',
                    value: '${state.totalCheckIns}天',
                    color: AppColors.primary,
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('加载失败: $e')),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(value, style: TextStyles.heading5.copyWith(color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyles.caption),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          '加载失败: $error',
          style: TextStyles.body2.copyWith(color: AppColors.error),
        ),
      ),
    );
  }
}
