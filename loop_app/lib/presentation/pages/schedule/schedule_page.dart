import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/database/app_database.dart';
import '../../providers/plan_provider.dart';
import '../../widgets/common/animated_widgets.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  late DateTime _currentWeekStart;
  int _currentWeekOffset = 0;

  @override
  void initState() {
    super.initState();
    _currentWeekStart = _getWeekStart(DateTime.now());
  }

  DateTime _getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  void _previousWeek() {
    setState(() {
      _currentWeekOffset--;
      _currentWeekStart = _getWeekStart(DateTime.now())
          .add(Duration(days: _currentWeekOffset * 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _currentWeekOffset++;
      _currentWeekStart = _getWeekStart(DateTime.now())
          .add(Duration(days: _currentWeekOffset * 7));
    });
  }

  void _goToToday() {
    setState(() {
      _currentWeekOffset = 0;
      _currentWeekStart = _getWeekStart(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(
        title: const Text('行程表', style: TextStyles.heading4),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _goToToday,
            child: Text('今天', style: TextStyles.buttonSmall),
          ),
        ],
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
          child: Column(
            children: [
              _buildWeekHeader(),
              Expanded(
                child: _buildWeekGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekHeader() {
    final weekEnd = _currentWeekStart.add(const Duration(days: 6));
    final isCurrentWeek = _currentWeekOffset == 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _previousWeek,
            color: AppColors.textPrimary,
          ),
          Column(
            children: [
              Text(
                '${_currentWeekStart.month}月${_currentWeekStart.day}日 - ${weekEnd.month}月${weekEnd.day}日',
                style: TextStyles.heading5,
              ),
              if (isCurrentWeek)
                Text(
                  '本周',
                  style:
                      TextStyles.caption.copyWith(color: AppColors.primary),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextWeek,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekGrid() {
    return FutureBuilder<List<PlanInstance>>(
      future: _getWeekInstances(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
                color: AppColors.primary, strokeWidth: 2),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('加载失败: ${snapshot.error}',
                style: TextStyles.body2.copyWith(color: AppColors.error)),
          );
        }

        final instances = snapshot.data ?? [];

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 7,
          itemBuilder: (context, index) {
            final date = _currentWeekStart.add(Duration(days: index));
            final dayInstances = instances
                .where((i) =>
                    i.date.year == date.year &&
                    i.date.month == date.month &&
                    i.date.day == date.day)
                .toList();

            return FadeInWidget(
              delay: Duration(milliseconds: index * 50),
              child: _buildDayRow(date, dayInstances),
            );
          },
        );
      },
    );
  }

  Future<List<PlanInstance>> _getWeekInstances() async {
    final weekEnd = _currentWeekStart.add(const Duration(days: 7));
    final repository = ref.read(planInstanceRepositoryProvider);
    return repository.getInstancesByDateRange(_currentWeekStart, weekEnd);
  }

  Widget _buildDayRow(DateTime date, List<PlanInstance> instances) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final weekdayNames = ['一', '二', '三', '四', '五', '六', '日'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: isToday
            ? Border.all(color: AppColors.primary, width: 2)
            : Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isToday ? AppColors.primary.withValues(alpha: 0.1) : null,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Text(
                  '周${weekdayNames[date.weekday - 1]}',
                  style: TextStyles.label.copyWith(
                    color: isToday ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${date.month}/${date.day}',
                  style: TextStyles.body2.copyWith(
                    color:
                        isToday ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
                if (isToday) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '今天',
                      style:
                          TextStyles.caption.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (instances.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '暂无计划',
                style: TextStyles.caption,
              ),
            )
          else
            ...instances.map((instance) => _buildInstanceItem(instance)),
        ],
      ),
    );
  }

  Widget _buildInstanceItem(PlanInstance instance) {
    final templatesAsync =
        ref.watch(planTemplateDetailProvider(instance.planTemplateId));

    return templatesAsync.when(
      data: (template) {
        if (template == null) return const SizedBox.shrink();

        final color = Color(template.colorValue);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: TextStyles.label.copyWith(
                        decoration: instance.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${template.startHour.toString().padLeft(2, '0')}:${template.startMinute.toString().padLeft(2, '0')} - ${template.endHour.toString().padLeft(2, '0')}:${template.endMinute.toString().padLeft(2, '0')}',
                      style: TextStyles.caption,
                    ),
                  ],
                ),
              ),
              if (instance.isCompleted)
                Icon(Icons.check_circle, color: AppColors.success, size: 20),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
