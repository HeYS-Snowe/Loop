import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/database/app_database.dart';
import '../../providers/cycle_provider.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> with SingleTickerProviderStateMixin {
  late DateTime _currentWeekStart;
  late PageController _pageController;
  static const int _initialPage = 5200;

  static const List<String> _weekDays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  static const List<Color> _cardColors = [
    Color(0xFF4A90D9),
    Color(0xFF00BFA5),
    Color(0xFFFF7043),
    Color(0xFFAB47BC),
    Color(0xFF42A5F5),
    Color(0xFFFFCA28),
    Color(0xFF66BB6A),
    Color(0xFFEF5350),
  ];

  static const List<Map<String, String>> _timeSlots = [
    {'index': '1', 'start': '08:00', 'end': '08:45'},
    {'index': '2', 'start': '08:55', 'end': '09:40'},
    {'index': '3', 'start': '10:00', 'end': '10:45'},
    {'index': '4', 'start': '10:55', 'end': '11:40'},
    {'index': '5', 'start': '14:00', 'end': '14:45'},
    {'index': '6', 'start': '14:55', 'end': '15:40'},
    {'index': '7', 'start': '16:00', 'end': '16:45'},
    {'index': '8', 'start': '16:55', 'end': '17:40'},
    {'index': '9', 'start': '19:00', 'end': '19:45'},
    {'index': '10', 'start': '19:55', 'end': '20:40'},
  ];

  @override
  void initState() {
    super.initState();
    _currentWeekStart = _getWeekStart(DateTime.now());
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return DateTime(date.year, date.month, date.day).subtract(Duration(days: weekday - 1));
  }

  DateTime _getWeekStartFromIndex(int index) {
    final offset = index - _initialPage;
    return _getWeekStart(DateTime.now().add(Duration(days: offset * 7)));
  }

  int _getWeekIndex(DateTime weekStart) {
    final base = _getWeekStart(DateTime.now());
    return _initialPage + weekStart.difference(base).inDays ~/ 7;
  }

  void _goToWeek(DateTime weekStart) {
    final index = _getWeekIndex(weekStart);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeCycleAsync = ref.watch(activeCycleProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(
        title: const Text('行程表', style: TextStyles.heading4),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildWeekNavigation(),
          _buildDayHeaders(),
          Expanded(
            child: activeCycleAsync.when(
              data: (cycle) {
                if (cycle == null) {
                  return _buildEmptyState();
                }
                return _buildScheduleGrid(cycle);
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => Center(
                child: Text('加载失败', style: TextStyles.body2.copyWith(color: AppColors.error)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
              });
              _goToWeek(_currentWeekStart);
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chevron_left_rounded, color: AppColors.textSecondary, size: 22),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentWeekStart = _getWeekStart(DateTime.now());
                });
                _goToWeek(_currentWeekStart);
              },
              child: Column(
                children: [
                  Text(
                    _getWeekLabel(_currentWeekStart),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getDateRangeLabel(_currentWeekStart),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
              });
              _goToWeek(_currentWeekStart);
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  String _getWeekLabel(DateTime weekStart) {
    final now = DateTime.now();
    final currentWeekStart = _getWeekStart(now);
    final diff = currentWeekStart.difference(weekStart).inDays;

    if (diff == 0) return '本周';
    if (diff == 7) return '上周';
    if (diff == -7) return '下周';

    final weekNum = (now.difference(weekStart).inDays / 7).ceil();
    if (weekNum > 0) return '${weekNum}周前';
    return '${-weekNum}周后';
  }

  String _getDateRangeLabel(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    return '${weekStart.month}/${weekStart.day} - ${weekEnd.month}/${weekEnd.day}';
  }

  Widget _buildDayHeaders() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: Center(
              child: Text(
                '节次',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: List.generate(7, (i) {
                final day = _currentWeekStart.add(Duration(days: i));
                final isToday = day == today;

                return Expanded(
                  child: Column(
                    children: [
                      Text(
                        _weekDays[i],
                        style: TextStyle(
                          fontSize: 11,
                          color: isToday ? AppColors.primary : AppColors.textTertiary,
                          fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isToday ? AppColors.primary : Colors.transparent,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                            color: isToday ? AppColors.backgroundDeep : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleGrid(Cycle cycle) {
    return FutureBuilder<List<Task>>(
      future: ref.read(taskRepositoryProvider).getTasksByCycle(cycle.id),
      builder: (context, snapshot) {
        final tasks = snapshot.data ?? <Task>[];

        return PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentWeekStart = _getWeekStartFromIndex(index);
            });
          },
          itemCount: 10400,
          itemBuilder: (context, pageIndex) {
            final weekStart = _getWeekStartFromIndex(pageIndex);
            return _buildWeekGrid(weekStart, tasks, cycle);
          },
        );
      },
    );
  }

  Widget _buildWeekGrid(DateTime weekStart, List<Task> tasks, Cycle cycle) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: _timeSlots.length,
      itemBuilder: (context, rowIndex) {
        final slot = _timeSlots[rowIndex];
        return _buildTimeRow(weekStart, rowIndex, slot, tasks, cycle);
      },
    );
  }

  Widget _buildTimeRow(DateTime weekStart, int rowIndex, Map<String, String> slot, List<Task> tasks, Cycle cycle) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 52,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  slot['index']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${slot['start']}',
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.textTertiary,
                  ),
                ),
                Text(
                  '${slot['end']}',
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: List.generate(7, (dayIndex) {
                final day = weekStart.add(Duration(days: dayIndex));
                final task = _getTaskForSlot(day, rowIndex, tasks, cycle);

                return Expanded(
                  child: Container(
                    height: 68,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                    child: task != null
                        ? _buildTaskCard(task, dayIndex)
                        : const SizedBox.shrink(),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Task? _getTaskForSlot(DateTime day, int slotIndex, List<Task> tasks, Cycle cycle) {
    if (tasks.isEmpty) return null;

    final isDayInCycle = !day.isBefore(cycle.startDate) && !day.isAfter(cycle.endDate);
    if (!isDayInCycle) return null;

    final dailyTasks = tasks.where((t) => t.isRepeatable && t.repeatType == 'daily').toList();
    final weeklyTasks = tasks.where((t) => t.isRepeatable && t.repeatType == 'weekly').toList();
    final onceTasks = tasks.where((t) => !t.isRepeatable || (t.repeatType != 'daily' && t.repeatType != 'weekly')).toList();

    if (dailyTasks.isNotEmpty) {
      final taskIndex = slotIndex % dailyTasks.length;
      if (slotIndex < dailyTasks.length) {
        return dailyTasks[taskIndex];
      }
    }

    final dayOfWeek = day.weekday;
    if (weeklyTasks.isNotEmpty) {
      final weekSlot = (dayOfWeek - 1) % weeklyTasks.length;
      if (slotIndex == 0 || slotIndex == 3 || slotIndex == 5) {
        return weeklyTasks[weekSlot];
      }
    }

    if (onceTasks.isNotEmpty) {
      final cycleStart = cycle.startDate;
      final dayOffset = day.difference(cycleStart).inDays;
      final totalDays = cycle.endDate.difference(cycle.startDate).inDays + 1;
      final tasksPerDay = (onceTasks.length / totalDays).ceil();
      final dayTaskStart = dayOffset * tasksPerDay;

      if (slotIndex < tasksPerDay && dayTaskStart + slotIndex < onceTasks.length) {
        return onceTasks[dayTaskStart + slotIndex];
      }
    }

    return null;
  }

  Widget _buildTaskCard(Task task, int dayIndex) {
    final color = _cardColors[task.name.hashCode.abs() % _cardColors.length];

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: color.withValues(alpha: 0.18),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
                height: 1.2,
              ),
            ),
            if (task.description != null && task.description!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                task.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 8,
                  color: color.withValues(alpha: 0.7),
                  height: 1.3,
                ),
              ),
            ],
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: task.targetAmount > 0 ? (task.completedAmount / task.targetAmount).clamp(0.0, 1.0) : 0.0,
                      backgroundColor: color.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(color.withValues(alpha: 0.6)),
                      minHeight: 2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.accent.withValues(alpha: 0.08),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                size: 32,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text('暂无周期计划', style: TextStyles.heading4),
            const SizedBox(height: 8),
            Text(
              '创建一个周期计划后\n行程表将自动展示你的任务安排',
              textAlign: TextAlign.center,
              style: TextStyles.body2,
            ),
          ],
        ),
      ),
    );
  }
}
