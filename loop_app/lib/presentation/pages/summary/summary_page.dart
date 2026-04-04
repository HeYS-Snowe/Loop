import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop/core/theme/colors.dart';
import 'package:loop/core/theme/text_styles.dart';
import 'package:loop/data/database/app_database.dart';
import 'package:loop/presentation/providers/plan_provider.dart';
import 'package:loop/presentation/providers/check_in_provider.dart';
import 'package:loop/presentation/widgets/common/glass_card.dart';
import 'package:loop/presentation/widgets/common/gradient_decorations.dart';
import 'package:loop/presentation/widgets/common/animated_widgets.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    final instancesAsync = ref.watch(planInstancesByDateRangeProvider(
      (start: DateTime(weekStart.year, weekStart.month, weekStart.day),
       end: DateTime(weekEnd.year, weekEnd.month, weekEnd.day)),
    ));
    final templatesAsync = ref.watch(allPlanTemplatesProvider);
    final checkInState = ref.watch(checkInNotifierProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      body: Container(
        color: AppColors.backgroundDeep,
        child: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            onRefresh: () async {
              ref.invalidate(allPlanTemplatesProvider);
              ref.invalidate(planInstancesByDateRangeProvider);
              ref.invalidate(checkInNotifierProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 8, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -- AppBar --
                  FadeInWidget(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Text('统计', style: TextStyles.heading3),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // -- Overview Card --
                  FadeInWidget(
                    duration: const Duration(milliseconds: 450),
                    child: _OverviewCard(
                      instancesAsync: instancesAsync,
                      templatesAsync: templatesAsync,
                      checkInState: checkInState,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // -- Weekly Stats --
                  FadeInWidget(
                    duration: const Duration(milliseconds: 500),
                    child: _WeeklyStatsSection(instancesAsync: instancesAsync),
                  ),

                  const SizedBox(height: 20),

                  // -- Plan Statistics --
                  FadeInWidget(
                    duration: const Duration(milliseconds: 550),
                    child: _PlanStatsSection(templatesAsync: templatesAsync),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Overview Card
// ---------------------------------------------------------------------------
class _OverviewCard extends StatelessWidget {
  final AsyncValue<List<PlanInstance>> instancesAsync;
  final AsyncValue<List<PlanTemplate>> templatesAsync;
  final AsyncValue<CheckInState> checkInState;

  const _OverviewCard({
    required this.instancesAsync,
    required this.templatesAsync,
    required this.checkInState,
  });

  @override
  Widget build(BuildContext context) {
    return instancesAsync.when(
      data: (instances) {
        final totalCount = instances.length;
        final completedCount = instances.where((i) => i.isCompleted).length;
        final completionRate = totalCount > 0 ? completedCount / totalCount : 0.0;

        int totalCheckIns = 0;
        if (checkInState.hasValue && checkInState.value != null) {
          totalCheckIns = checkInState.value!.totalCheckIns;
        }

        return GradientContainer(
          style: GradientStyle.primary,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '本周概览',
                style: TextStyles.labelSmall.copyWith(
                  color: const Color(0xCCFFFFFF),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _OverviewStatItem(
                      icon: Icons.assignment_outlined,
                      label: '总计划',
                      value: '$totalCount',
                    ),
                  ),
                  Expanded(
                    child: _OverviewStatItem(
                      icon: Icons.analytics_outlined,
                      label: '完成率',
                      value: '${(completionRate * 100).toInt()}%',
                    ),
                  ),
                  Expanded(
                    child: _OverviewStatItem(
                      icon: Icons.check_circle_outline_rounded,
                      label: '总打卡',
                      value: '$totalCheckIns',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const GradientContainer(
        style: GradientStyle.primary,
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        ),
      ),
      error: (e, _) => GradientContainer(
        style: GradientStyle.primary,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            '加载失败: $e',
            style: TextStyles.body2.copyWith(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}

class _OverviewStatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _OverviewStatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24, color: const Color(0xE6FFFFFF)),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyles.numberSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyles.labelSmall.copyWith(
            color: const Color(0xB3FFFFFF),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Weekly Stats Section
// ---------------------------------------------------------------------------
class _WeeklyStatsSection extends StatelessWidget {
  final AsyncValue<List<PlanInstance>> instancesAsync;

  const _WeeklyStatsSection({required this.instancesAsync});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('每日完成情况', style: TextStyles.heading4),
        ),
        const SizedBox(height: 10),
        instancesAsync.when(
          data: (instances) {
            final now = DateTime.now();
            final weekStart = now.subtract(Duration(days: now.weekday - 1));
            final dailyStats = _computeDailyStats(instances, weekStart);

            return GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  for (int i = 0; i < dailyStats.length; i++)
                    FadeInWidget(
                      delay: Duration(milliseconds: 60 * i),
                      child: _DailyStatRow(
                        dayLabel: dailyStats[i].dayLabel,
                        completed: dailyStats[i].completed,
                        total: dailyStats[i].total,
                        progress: dailyStats[i].progress,
                        isToday: dailyStats[i].isToday,
                      ),
                    ),
                ],
              ),
            );
          },
          loading: () => const GlassCard(
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            ),
          ),
          error: (e, _) => GlassCard(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(
                '加载失败: $e',
                style: TextStyles.body2.copyWith(color: AppColors.error),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<_DailyStat> _computeDailyStats(List<PlanInstance> instances, DateTime weekStart) {
    const dayLabels = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final List<_DailyStat> stats = [];

    for (int i = 0; i < 7; i++) {
      final date = DateTime(weekStart.year, weekStart.month, weekStart.day).add(Duration(days: i));
      final dateInstances = instances.where((inst) {
        final instDate = DateTime(inst.date.year, inst.date.month, inst.date.day);
        return instDate.isAtSameMomentAs(date);
      }).toList();

      final total = dateInstances.length;
      final completed = dateInstances.where((inst) => inst.isCompleted).length;
      final progress = total > 0 ? completed / total : 0.0;

      stats.add(_DailyStat(
        dayLabel: dayLabels[i],
        completed: completed,
        total: total,
        progress: progress,
        isToday: date.isAtSameMomentAs(today),
      ));
    }

    return stats;
  }
}

class _DailyStat {
  final String dayLabel;
  final int completed;
  final int total;
  final double progress;
  final bool isToday;

  const _DailyStat({
    required this.dayLabel,
    required this.completed,
    required this.total,
    required this.progress,
    required this.isToday,
  });
}

class _DailyStatRow extends StatelessWidget {
  final String dayLabel;
  final int completed;
  final int total;
  final double progress;
  final bool isToday;

  const _DailyStatRow({
    required this.dayLabel,
    required this.completed,
    required this.total,
    required this.progress,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              dayLabel,
              style: TextStyles.labelSmall.copyWith(
                color: isToday ? AppColors.primary : AppColors.textTertiary,
                fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AnimatedProgressIndicator(
              progress: progress,
              height: 8,
              gradient: isToday ? AppColors.progressGradient : AppColors.progressGradient,
              backgroundColor: AppColors.surfaceLight,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 48,
            child: Text(
              total > 0 ? '$completed/$total' : '-',
              style: TextStyles.labelSmall.copyWith(
                color: isToday ? AppColors.primary : AppColors.textTertiary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Plan Statistics Section
// ---------------------------------------------------------------------------
class _PlanStatsSection extends ConsumerWidget {
  final AsyncValue<List<PlanTemplate>> templatesAsync;

  const _PlanStatsSection({required this.templatesAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('计划统计', style: TextStyles.heading4),
        ),
        const SizedBox(height: 10),
        templatesAsync.when(
          data: (templates) {
            if (templates.isEmpty) {
              return _buildEmptyState();
            }

            return Column(
              children: [
                for (int i = 0; i < templates.length; i++)
                  FadeInWidget(
                    delay: Duration(milliseconds: 60 * i),
                    child: _PlanStatCard(template: templates[i]),
                  ),
              ],
            );
          },
          loading: () => const GlassCard(
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            ),
          ),
          error: (e, _) => GlassCard(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(
                '加载失败: $e',
                style: TextStyles.body2.copyWith(color: AppColors.error),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          const Icon(
            Icons.bar_chart_rounded,
            size: 48,
            color: Color(0x8064748B),
          ),
          const SizedBox(height: 16),
          Text(
            '暂无统计数据',
            style: TextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          const Text(
            '创建计划后这里会显示统计信息',
            style: TextStyles.body3,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PlanStatCard extends ConsumerWidget {
  final PlanTemplate template;

  const _PlanStatCard({required this.template});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Color(template.colorValue);

    // 获取本周该模板的实例来计算完成率
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    final instancesAsync = ref.watch(planInstancesByDateRangeProvider(
      (start: DateTime(weekStart.year, weekStart.month, weekStart.day),
       end: DateTime(weekEnd.year, weekEnd.month, weekEnd.day)),
    ));

    return instancesAsync.when(
      data: (instances) {
        final templateInstances = instances
            .where((i) => i.planTemplateId == template.id)
            .toList();
        final completed = templateInstances.where((i) => i.isCompleted).length;
        final total = templateInstances.length;
        final progress = total > 0 ? completed / total : 0.0;

        return GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 36,
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
                          style: TextStyles.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '本周 $completed/$total 完成',
                          style: TextStyles.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyles.labelSmall.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AnimatedProgressIndicator(
                progress: progress,
                height: 6,
                gradient: AppColors.progressGradient,
                backgroundColor: AppColors.surfaceLight,
              ),
            ],
          ),
        );
      },
      loading: () => const GlassCard(
        padding: EdgeInsets.symmetric(vertical: 14),
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 1.5,
            ),
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
