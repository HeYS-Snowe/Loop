// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loop/core/theme/colors.dart';
import 'package:loop/core/theme/text_styles.dart';
import 'package:loop/data/database/app_database.dart';
import 'package:loop/presentation/providers/cycle_provider.dart';
import 'package:loop/presentation/providers/check_in_provider.dart';
import 'package:loop/presentation/providers/plan_provider.dart';
import 'package:loop/presentation/widgets/common/glass_card.dart';
import 'package:loop/presentation/widgets/common/gradient_decorations.dart';
import 'package:loop/presentation/widgets/common/animated_widgets.dart';
import 'package:loop/presentation/widgets/common/particle_background.dart';
import 'package:loop/presentation/pages/home/widgets/quick_stats_card.dart';
import 'package:loop/presentation/pages/home/widgets/check_in_card.dart';
import 'package:loop/presentation/pages/home/widgets/cycle_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cycleNotifierProvider.notifier).loadCycles();
    });
  }

  String _getGreeting() {
    final int hour = DateTime.now().hour;
    if (hour < 6) return '夜深了';
    if (hour < 12) return '早上好';
    if (hour < 18) return '下午好';
    return '晚上好';
  }

  String _formatDate(DateTime date) {
    const List<String> weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final String weekday = weekdays[date.weekday - 1];
    return '${date.month}月${date.day}日 $weekday';
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Cycle>> cyclesAsync = ref.watch(cycleNotifierProvider);
    final DateTime today = DateTime.now();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const ParticleBackground(
            particleCount: 15,
            particleColor: AppColors.primary,
          ),
          SafeArea(
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              onRefresh: () async {
                await ref.read(cycleNotifierProvider.notifier).loadCycles();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 8, bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAppBar(today),
                    const SizedBox(height: 8),
                    FadeInWidget(
                      duration: const Duration(milliseconds: 450),
                      child: _buildQuickStatsSection(),
                    ),
                    const SizedBox(height: 20),
                    const FadeInWidget(
                      duration: Duration(milliseconds: 500),
                      child: CheckInCard(),
                    ),
                    const SizedBox(height: 20),
                    FadeInWidget(
                      duration: const Duration(milliseconds: 550),
                      child: _buildTodayPlansSection(),
                    ),
                    const SizedBox(height: 20),
                    FadeInWidget(
                      duration: const Duration(milliseconds: 600),
                      child: _buildCycleSection(cyclesAsync),
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

  Widget _buildAppBar(DateTime today) {
    return FadeInWidget(
      duration: const Duration(milliseconds: 400),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: TextStyles.heading3,
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(today),
                  style: TextStyles.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => context.push('/create-plan'),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryMuted,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsSection() {
    final DateTime today = DateTime.now();
    final AsyncValue<List<PlanInstance>> instancesAsync =
        ref.watch(planInstancesByDateProvider(today));
    final AsyncValue<CheckInState> checkInState =
        ref.watch(checkInNotifierProvider);

    return instancesAsync.when(
      data: (List<PlanInstance> instances) {
        final int completedCount =
            instances.where((PlanInstance i) => i.isCompleted).length;
        final int totalCount = instances.length;

        int streakCount = 0;
        if (checkInState.hasValue && checkInState.value != null) {
          streakCount = checkInState.value!.streakCount;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: QuickStatsCard(
                  title: '今日任务',
                  value: '$totalCount',
                  icon: Icons.today_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: QuickStatsCard(
                  title: '已完成',
                  value: '$completedCount',
                  icon: Icons.check_circle_outline_rounded,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: QuickStatsCard(
                  title: '连续打卡',
                  value: '$streakCount',
                  icon: Icons.local_fire_department_outlined,
                  color: AppColors.accent,
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
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildTodayPlansSection() {
    final DateTime today = DateTime.now();
    final AsyncValue<List<PlanInstance>> instancesAsync =
        ref.watch(planInstancesByDateProvider(today));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('今日计划', style: TextStyles.heading4),
              _NavLink(label: '查看全部', route: '/daily-plan'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        instancesAsync.when(
          data: (List<PlanInstance> instances) {
            if (instances.isEmpty) {
              return _buildEmptyPlansState();
            }
            final List<PlanInstance> displayInstances = instances.take(5).toList();
            return Column(
              children: [
                for (int i = 0; i < displayInstances.length; i++)
                  FadeInWidget(
                    delay: Duration(milliseconds: 60 * i),
                    child: _PlanItemCard(instance: displayInstances[i]),
                  ),
              ],
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            ),
          ),
          error: (Object e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
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

  Widget _buildEmptyPlansState() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          Icon(
            Icons.event_note_outlined,
            size: 44,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            '暂无今日计划',
            style: TextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => context.push('/create-plan'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: GradientDecoration.primary.copyWith(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '创建计划',
                style: TextStyles.buttonSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCycleSection(AsyncValue<List<Cycle>> cyclesAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('周期计划', style: TextStyles.heading4),
              _NavLink(label: '查看全部', route: '/create-cycle'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        cyclesAsync.when(
          data: (List<Cycle> cycles) {
            if (cycles.isEmpty) {
              return _buildEmptyCycleState();
            }

            final List<Cycle> activeCycles = cycles.where((Cycle c) {
              final DateTime now = DateTime.now();
              return c.isActive && c.endDate.isAfter(now);
            }).toList();

            final List<Cycle> historyCycles = cycles.where((Cycle c) {
              final DateTime now = DateTime.now();
              return !c.isActive || c.endDate.isBefore(now);
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (activeCycles.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '当前周期',
                      style: TextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (int i = 0; i < activeCycles.take(2).length; i++)
                    FadeInWidget(
                      delay: Duration(milliseconds: 60 * i),
                      child: CycleCard(
                        name: activeCycles[i].name,
                        startDate: activeCycles[i].startDate,
                        endDate: activeCycles[i].endDate,
                        isActive: true,
                        colorIndex: i,
                      ),
                    ),
                ],
                if (historyCycles.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '历史周期',
                      style: TextStyles.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (int i = 0; i < historyCycles.take(2).length; i++)
                    FadeInWidget(
                      delay: Duration(
                        milliseconds: 60 * (i + (activeCycles.isNotEmpty ? 2 : 0)),
                      ),
                      child: CycleCard(
                        name: historyCycles[i].name,
                        startDate: historyCycles[i].startDate,
                        endDate: historyCycles[i].endDate,
                        isActive: false,
                        colorIndex: i + activeCycles.length,
                      ),
                    ),
                ],
              ],
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            ),
          ),
          error: (Object e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
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

  Widget _buildEmptyCycleState() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 48,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '开始你的第一个周期计划',
            style: TextStyles.body1.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => context.push('/create-cycle'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: GradientDecoration.primary.copyWith(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_rounded,
                    size: 18,
                    color: AppColors.textOnPrimary,
                  ),
                  SizedBox(width: 6),
                  Text('创建周期', style: TextStyles.buttonSmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final String route;

  const _NavLink({required this.label, required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Text(
        label,
        style: TextStyles.labelSmall.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _PlanItemCard extends ConsumerWidget {
  final PlanInstance instance;

  const _PlanItemCard({required this.instance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PlanTemplate?> templateAsync = ref.watch(
      planTemplateDetailProvider(instance.planTemplateId),
    );

    return templateAsync.when(
      data: (PlanTemplate? template) {
        final Color color = template != null
            ? Color(template.colorValue)
            : AppColors.primary;
        final String name = template?.name ?? '未知计划';
        final double progress = instance.targetAmount > 0
            ? (instance.completedAmount / instance.targetAmount).clamp(0.0, 1.0)
            : (instance.isCompleted ? 1.0 : 0.0);

        return GestureDetector(
          onTap: () => context.push('/daily-plan'),
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 38,
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
                        name,
                        style: TextStyles.label.copyWith(
                          decoration: instance.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: instance.isCompleted
                              ? AppColors.textTertiary
                              : AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      AnimatedProgressIndicator(
                        progress: progress,
                        height: 5,
                        gradient: AppColors.progressGradient,
                        backgroundColor: AppColors.surfaceLight,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: instance.isCompleted
                        ? AppColors.successMuted
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: instance.isCompleted
                          ? AppColors.success.withOpacity(0.4)
                          : AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: instance.isCompleted
                      ? const Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: AppColors.success,
                        )
                      : null,
                ),
              ],
            ),
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
