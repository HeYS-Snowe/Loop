import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:loop_app/l10n/generated/app_localizations.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/extensions/model_extensions.dart';
import '../../../data/database/app_database.dart';
import '../../../domain/services/check_in_service.dart';
import '../../providers/cycle_provider.dart';
import '../../providers/check_in_provider.dart';
import '../../providers/plan_provider.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/gradient_decorations.dart';
import '../../widgets/common/particle_background.dart';
import '../../widgets/common/animated_widgets.dart';
import 'summary_card.dart';

class SummaryPage extends ConsumerStatefulWidget {
  const SummaryPage({super.key});

  @override
  ConsumerState<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends ConsumerState<SummaryPage>
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
    final cyclesAsync = ref.watch(cyclesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(S.of(context)!.statistics, style: TextStyles.heading3),
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: GradientDecoration(
              style: GradientStyle.radialGlow,
              color: AppColors.warmAccent,
            ),
          ),
          Positioned.fill(
            child: ParticleBackground(
              particleCount: 15,
              baseColor: AppColors.gold,
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedPageWrapper(
                      index: 0,
                      child: checkInStateAsync.when(
                        data: (state) =>
                            _buildCheckInButton(context, ref, state),
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
                      child: Text(S.of(context)!.checkInCalendar, style: TextStyles.heading4),
                    ),
                    const SizedBox(height: 12),
                    AnimatedPageWrapper(
                      index: 3,
                      child: _buildCalendar(),
                    ),
                    const SizedBox(height: 24),
                    AnimatedPageWrapper(
                      index: 4,
                      child: _buildWeeklyPlanStats(),
                    ),
                    const SizedBox(height: 24),
                    AnimatedPageWrapper(
                      index: 5,
                      child: cyclesAsync.when(
                        data: (cycles) => _buildCycleSection(cycles),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
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
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: state.checkedInToday
            ? null
            : () {
                ref.read(checkInNotifierProvider.notifier).checkIn();
              },
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
                              AppColors.success
                                  .withValues(alpha: 0.15 + pulse * 0.1),
                              AppColors.success
                                  .withValues(alpha: 0.05),
                            ]
                          : [
                              AppColors.primary
                                  .withValues(alpha: 0.15 + pulse * 0.1),
                              AppColors.accent
                                  .withValues(alpha: 0.05),
                            ],
                    ),
                    border: Border.all(
                      color: state.checkedInToday
                          ? AppColors.success
                              .withValues(alpha: 0.2 + pulse * 0.1)
                          : AppColors.primary
                              .withValues(alpha: 0.2 + pulse * 0.1),
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
                                S.of(context)!.dayUnit,
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
              state.checkedInToday ? S.of(context)!.checkedInToday : S.of(context)!.clickToCheckIn,
              style: TextStyles.heading4.copyWith(
                color: state.checkedInToday
                    ? AppColors.success
                    : AppColors.textPrimary,
              ),
            ),
            if (!state.checkedInToday) ...[
              const SizedBox(height: 6),
              Text(
                S.of(context)!.streakDays(state.streakCount),
                style: TextStyles.body2,
              ),
            ],
          ],
        ),
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
          _buildStatItem(
              S.of(context)!.streakCheckIn, '${stats.currentStreak}', AppColors.warmAccent),
          Container(width: 1, height: 32, color: AppColors.divider),
          _buildStatItem(
              S.of(context)!.maxRecord, '${stats.maxStreak}', AppColors.gold),
          Container(width: 1, height: 32, color: AppColors.divider),
          _buildStatItem(
              S.of(context)!.totalCheckIn, '${stats.totalDays}', AppColors.accent),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style:
                TextStyles.statValue.copyWith(fontSize: 24, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyles.caption),
      ],
    );
  }

  Widget _buildCalendar() {
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
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
                      fontWeight:
                          isToday ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
            selectedBuilder: (context, day, focusedDay) {
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
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
                          color:
                              AppColors.success.withValues(alpha: 0.4),
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

  Widget _buildCycleSection(List<Cycle> cycles) {
    if (cycles.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.insights_rounded,
              size: 48,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 12),
            Text(S.of(context)!.noCycleData, style: TextStyles.body2),
          ],
        ),
      );
    }

    final completedCycles = cycles.where((c) => c.isActive == false).toList();
    final avgCompletion = completedCycles.isNotEmpty
        ? completedCycles
                .map((c) => c.progressPercentage)
                .reduce((a, b) => a + b) /
            completedCycles.length
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.of(context)!.cycleStats, style: TextStyles.heading4),
            Text(
              S.of(context)!.avgCompletionRate((avgCompletion * 100).round()),
              style: TextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (completedCycles.isNotEmpty) ...[
          _buildCompletionChart(completedCycles),
          const SizedBox(height: 24),
        ],
        ...cycles.asMap().entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SummaryCard(cycle: entry.value),
            )),
      ],
    );
  }

  Widget _buildCompletionChart(List<Cycle> completedCycles) {
    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.surface.withValues(alpha: 0.75),
          AppColors.card.withValues(alpha: 0.55),
        ],
      ),
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < completedCycles.length) {
                      return Text(
                        '#${index + 1}',
                        style: TextStyles.caption,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  reservedSize: 20,
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: completedCycles.asMap().entries.map((entry) {
                  return FlSpot(
                    entry.key.toDouble(),
                    entry.value.progressPercentage * 100,
                  );
                }).toList(),
                isCurved: true,
                color: AppColors.primary,
                barWidth: 2.5,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: AppColors.primary,
                      strokeWidth: 2,
                      strokeColor: AppColors.surface,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.2),
                      AppColors.primary.withValues(alpha: 0.02),
                    ],
                  ),
                ),
              ),
            ],
            minY: 0,
            maxY: 100,
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyPlanStats() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final weekEndDate = weekStartDate.add(const Duration(days: 7));

    final weekInstancesAsync = ref.watch(planInstancesByDateRangeProvider(
      (start: weekStartDate, end: weekEndDate),
    ));

    return weekInstancesAsync.when(
      data: (instances) {
        if (instances.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context)!.weeklyPlanStats, style: TextStyles.heading4),
              const SizedBox(height: 16),
              GlassCard(
                child: Column(
                  children: [
                    const Icon(Icons.bar_chart_rounded, size: 40, color: AppColors.textTertiary),
                    const SizedBox(height: 12),
                    Text(S.of(context)!.noWeeklyPlanData, style: TextStyles.body2),
                    const SizedBox(height: 4),
                    Text(S.of(context)!.createPlanWeeklyHint, style: TextStyles.caption),
                  ],
                ),
              ),
            ],
          );
        }

        final completedCount = instances.where((i) => i.isCompleted).length;
        final totalCount = instances.length;
        final totalTarget = instances.fold<int>(0, (sum, i) => sum + i.targetAmount);
        final totalCompleted = instances.fold<int>(0, (sum, i) => sum + i.completedAmount);
        final completionRate = totalCount > 0 ? completedCount / totalCount : 0.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context)!.weeklyPlanStats, style: TextStyles.heading4),
                Text(
                  '${weekStartDate.month}/${weekStartDate.day} - ${weekStartDate.add(const Duration(days: 6)).month}/${weekStartDate.add(const Duration(days: 6)).day}',
                  style: TextStyles.caption,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildWeeklyStatCard(S.of(context)!.completionRate, '${(completionRate * 100).round()}%', AppColors.primary)),
                const SizedBox(width: 10),
                Expanded(child: _buildWeeklyStatCard(S.of(context)!.completedAmount, '$completedCount/$totalCount', AppColors.success)),
                const SizedBox(width: 10),
                Expanded(child: _buildWeeklyStatCard(S.of(context)!.totalAmount, '$totalCompleted/$totalTarget', AppColors.accent)),
              ],
            ),
            const SizedBox(height: 16),
            _buildDailyChart(instances, weekStartDate),
          ],
        );
      },
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context)!.weeklyPlanStats, style: TextStyles.heading4),
          const SizedBox(height: 16),
          const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
        ],
      ),
      error: (e, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context)!.weeklyPlanStats, style: TextStyles.heading4),
          const SizedBox(height: 16),
          Text(S.of(context)!.loadFailed(e.toString()), style: TextStyles.body2.copyWith(color: AppColors.error)),
        ],
      ),
    );
  }

  Widget _buildWeeklyStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 0.5),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyles.statValue.copyWith(color: color, fontSize: 18)),
          const SizedBox(height: 4),
          Text(label, style: TextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildDailyChart(List<PlanInstance> instances, DateTime weekStart) {
    final s = S.of(context)!;
    final dailyData = <int, ({int completed, int target})>{};
    for (int i = 0; i < 7; i++) {
      dailyData[i] = (completed: 0, target: 0);
    }

    for (final instance in instances) {
      final dayIndex = instance.date.difference(weekStart).inDays;
      if (dayIndex >= 0 && dayIndex < 7) {
        final prev = dailyData[dayIndex]!;
        dailyData[dayIndex] = (
          completed: prev.completed + instance.completedAmount,
          target: prev.target + instance.targetAmount,
        );
      }
    }

    final dayLabels = [s.mon, s.tue, s.wed, s.thu, s.fri, s.sat, s.sun];
    final maxTarget = dailyData.values.map((d) => d.target).fold(0, (a, b) => a > b ? a : b);

    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context)!.dailyCompletion, style: TextStyles.label),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxTarget > 0 ? (maxTarget * 1.2).toDouble() : 10,
                barGroups: List.generate(7, (i) {
                  final data = dailyData[i]!;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data.target.toDouble(),
                        color: AppColors.primary.withValues(alpha: 0.2),
                        width: 16,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                      BarChartRodData(
                        toY: data.completed.toDouble(),
                        color: AppColors.primary,
                        width: 16,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < 7) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              dayLabels[index],
                              style: TextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 20,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildChartLegend(S.of(context)!.target, AppColors.primary.withValues(alpha: 0.2)),
              const SizedBox(width: 16),
              _buildChartLegend(S.of(context)!.finish, AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyles.caption),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
