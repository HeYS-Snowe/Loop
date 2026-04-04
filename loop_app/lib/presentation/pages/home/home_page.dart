import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/extensions/model_extensions.dart';
import '../../providers/cycle_provider.dart';
import '../../providers/check_in_provider.dart';
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_rounded, size: 22),
              onPressed: () => context.go(RouteConstants.settings),
            ),
          ),
        ],
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
                },
                color: AppColors.primary,
                backgroundColor: AppColors.surface,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
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
                              '当前周期',
                              style: TextStyles.heading4,
                            ),
                            TextButton(
                              onPressed: () => context.go(RouteConstants.tasks),
                              child: Text(
                                '查看全部',
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
                                '加载失败: $error',
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
                              '历史周期',
                              style: TextStyles.heading4,
                            ),
                            TextButton(
                              onPressed: () => context.go(RouteConstants.summary),
                              child: Text(
                                '查看全部',
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
                        index: 5,
                        child: _buildHistoryCyclesList(ref),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => context.go(RouteConstants.tasks),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.backgroundDeep,
          elevation: 0,
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
    );
  }

  Widget _buildEmptyCycleCard(BuildContext context) {
    return GlassCard(
      onTap: () => context.go(RouteConstants.tasks),
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
            '创建新周期',
            style: TextStyles.heading4,
          ),
          const SizedBox(height: 6),
          Text(
            '开始你的第一个周期计划',
            style: TextStyles.body2,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCyclesList(WidgetRef ref) {
    final cyclesAsync = ref.watch(cyclesProvider);

    return cyclesAsync.when(
      data: (cycles) {
        final historyCycles = cycles.where((c) => !c.isActive).take(3).toList();
        if (historyCycles.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                '暂无历史周期',
                style: TextStyles.body2,
              ),
            ),
          );
        }
        return Column(
          children: historyCycles.map((cycle) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CycleCard(cycle: cycle, compact: true),
          )).toList(),
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
          '加载失败: $error',
          style: TextStyles.body2.copyWith(color: AppColors.error),
        ),
      ),
    );
  }
}
