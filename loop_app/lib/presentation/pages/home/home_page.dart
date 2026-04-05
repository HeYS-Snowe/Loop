import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loop_app/l10n/generated/app_localizations.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/database/app_database.dart';
import '../../../data/extensions/model_extensions.dart';
import '../../providers/cycle_provider.dart';
import '../../providers/check_in_provider.dart';
import '../../providers/plan_provider.dart';
import '../../widgets/common/gradient_decorations.dart';
import '../../widgets/common/particle_background.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/animated_widgets.dart';
import 'widgets/cycle_card.dart';
import 'widgets/check_in_card.dart';
import 'widgets/quick_stats_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCycleAsync = ref.watch(activeCycleProvider);
    ref.watch(checkInStatsProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(
        title: Text(
          'Loop',
          style: TextStyles.heading2.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              children: [
                Positioned.fill(
                  child: GradientDecoration(
                    style: GradientStyle.meshGradient,
                  ),
                ),
                const Positioned.fill(
                  child: ParticleBackground(
                    particleCount: 25,
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              top: true,
              bottom: false,
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(activeCycleProvider);
                  ref.invalidate(checkInStatsProvider);
                  ref.invalidate(allPlanTemplatesProvider);
                  final now = DateTime.now();
                  final todayDate = DateTime(now.year, now.month, now.day);
                  ref.invalidate(planInstancesByDateProvider(todayDate));
                },
                color: AppColors.primary,
                backgroundColor: AppColors.surface,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      AnimatedPageWrapper(
                        index: 0,
                        child: const CheckInCard(),
                      ),
                      const SizedBox(height: 16),
                      AnimatedPageWrapper(
                        index: 1,
                        child: const QuickStatsCard(),
                      ),
                      const SizedBox(height: 28),
                      AnimatedPageWrapper(
                        index: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.of(context)!.todayPlan,
                              style: TextStyles.heading4,
                            ),
                            TextButton(
                              onPressed: () => context.go(RouteConstants.dailyPlan),
                              child: Text(
                                S.of(context)!.viewAll,
                                style: TextStyles.label.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedPageWrapper(
                        index: 3,
                        child: _buildTodayPlanPreview(context, ref),
                      ),
                      const SizedBox(height: 28),
                      AnimatedPageWrapper(
                        index: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.of(context)!.currentCycle,
                              style: TextStyles.heading4,
                            ),
                            TextButton(
                              onPressed: () => context.go(RouteConstants.tasks),
                              child: Text(
                                S.of(context)!.viewAll,
                                style: TextStyles.label.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedPageWrapper(
                        index: 3,
                        child: activeCycleAsync.when(
                          data: (cycle) {
                            if (cycle == null) {
                              return _buildEmptyCycleCard(context);
                            }
                            return CycleCard(cycle: cycle);
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
                          error: (error, stack) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text(
                                S.of(context)!.loadFailed(error.toString()),
                                style: TextStyles.body2.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      AnimatedPageWrapper(
                        index: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.of(context)!.historyCycle,
                              style: TextStyles.heading4,
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.go(RouteConstants.summary),
                              child: Text(
                                S.of(context)!.viewAll,
                                style: TextStyles.label.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedPageWrapper(
                        index: 7,
                        child: _buildHistoryCyclesList(context, ref),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCycleCard(BuildContext context) {
    return GlassCard(
      onTap: () => context.go(RouteConstants.createCycle),
      showCornerAccent: true,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.2),
                  AppColors.accent.withValues(alpha: 0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add_rounded,
              size: 28,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            S.of(context)!.createCycle,
            style: TextStyles.heading4,
          ),
          const SizedBox(height: 6),
          Text(
            S.of(context)!.startFirstCycle,
            style: TextStyles.body2,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCyclesList(BuildContext context, WidgetRef ref) {
    final cyclesAsync = ref.watch(cyclesProvider);

    return cyclesAsync.when(
      data: (cycles) {
        final historyCycles = cycles.where((c) => !c.isActive).take(3).toList();
        if (historyCycles.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                S.of(context)!.noHistoryCycle,
                style: TextStyles.body2,
              ),
            ),
          );
        }
        return Column(
          children: historyCycles
              .map((cycle) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CycleCard(cycle: cycle, compact: true),
                  ))
              .toList(),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2,
        ),
      ),
      error: (error, stack) => Center(
        child: Text(
          S.of(context)!.loadFailed(error.toString()),
          style: TextStyles.body2.copyWith(color: AppColors.error),
        ),
      ),
    );
  }

  Widget _buildTodayPlanPreview(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final todayInstances = ref.watch(planInstancesByDateProvider(todayDate));
    final templatesAsync = ref.watch(allPlanTemplatesProvider);

    return todayInstances.when(
      data: (instances) {
        if (instances.isEmpty) {
          return GlassCard(
            onTap: () => context.push(RouteConstants.createPlan),
            showCornerAccent: true,
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.2),
                        AppColors.accent.withValues(alpha: 0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_rounded, size: 24, color: AppColors.primary),
                ),
                const SizedBox(height: 10),
                Text(S.of(context)!.createTodayPlan, style: TextStyles.body1),
                const SizedBox(height: 4),
                Text(S.of(context)!.startPlanDay, style: TextStyles.body2),
              ],
            ),
          );
        }

        final templateMap = templatesAsync.whenOrNull(
          data: (templates) => {for (final t in templates) t.id: t},
        ) ?? <String, PlanTemplate>{};

        final completedCount = instances.where((i) => i.isCompleted).length;
        final totalCount = instances.length;

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildMiniStat(
                    context: context,
                    label: S.of(context)!.completed,
                    value: '$completedCount',
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMiniStat(
                    context: context,
                    label: S.of(context)!.inProgress,
                    value: '${totalCount - completedCount}',
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMiniStat(
                    context: context,
                    label: S.of(context)!.total,
                    value: '$totalCount',
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...instances.take(3).map((instance) => _buildMiniPlanItem(context, instance, templateMap)),
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
        ),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(S.of(context)!.loadFailed(e.toString()), style: TextStyles.body2.copyWith(color: AppColors.error)),
      ),
    );
  }

  Widget _buildMiniStat({required BuildContext context, required String label, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 0.5),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyles.statValue.copyWith(color: color, fontSize: 22)),
          const SizedBox(height: 2),
          Text(label, style: TextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildMiniPlanItem(BuildContext context, PlanInstance instance, Map<String, PlanTemplate> templateMap) {
    final template = templateMap[instance.planTemplateId];
    final planName = template?.name ?? S.of(context)!.unknownPlan;
    final planColor = template != null ? Color(template.colorValue) : AppColors.primary;
    final progress = instance.targetAmount > 0
        ? (instance.completedAmount / instance.targetAmount).clamp(0.0, 1.0)
        : (instance.isCompleted ? 1.0 : 0.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: planColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: planColor.withValues(alpha: 0.15), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: instance.isCompleted ? AppColors.success : Colors.transparent,
              border: Border.all(
                color: instance.isCompleted ? AppColors.success : planColor,
                width: 1.5,
              ),
            ),
            child: instance.isCompleted
                ? const Icon(Icons.check, size: 10, color: AppColors.backgroundDeep)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              planName,
              style: TextStyles.body2.copyWith(
                color: planColor,
                decoration: instance.isCompleted ? TextDecoration.lineThrough : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (instance.targetAmount > 0)
            Text(
              '${instance.completedAmount}/${instance.targetAmount}',
              style: TextStyles.caption.copyWith(
                color: progress >= 1.0 ? AppColors.success : AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}
