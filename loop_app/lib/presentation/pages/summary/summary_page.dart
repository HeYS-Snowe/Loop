import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/extensions/model_extensions.dart';
import '../../../data/database/app_database.dart';
import '../../providers/cycle_provider.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/gradient_decorations.dart';
import '../../widgets/common/particle_background.dart';
import '../../widgets/common/animated_widgets.dart';
import 'widgets/summary_card.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cyclesAsync = ref.watch(cyclesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('总结', style: TextStyles.heading3),
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
                child: cyclesAsync.when(
                  data: (cycles) {
                    if (cycles.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(48),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.insights_rounded,
                                size: 64,
                                color: AppColors.textTertiary,
                              ),
                              const SizedBox(height: 16),
                              Text('暂无总结数据', style: TextStyles.heading4),
                              const SizedBox(height: 8),
                              Text(
                                '完成一个周期后这里会显示总结',
                                style: TextStyles.body2,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedPageWrapper(
                          index: 0,
                          child: _buildOverviewStats(cycles),
                        ),
                        const SizedBox(height: 24),
                        AnimatedPageWrapper(
                          index: 1,
                          child: Text('完成率趋势', style: TextStyles.heading4),
                        ),
                        const SizedBox(height: 12),
                        AnimatedPageWrapper(
                          index: 2,
                          child: _buildCompletionChart(cycles),
                        ),
                        const SizedBox(height: 24),
                        AnimatedPageWrapper(
                          index: 3,
                          child: Text('周期详情', style: TextStyles.heading4),
                        ),
                        const SizedBox(height: 12),
                        ...cycles.asMap().entries.map((entry) => AnimatedPageWrapper(
                              index: entry.key + 4,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: SummaryCard(cycle: entry.value),
                              ),
                            )),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                  error: (error, stack) => Center(
                    child: Text('Error: $error', style: TextStyles.body2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStats(List<Cycle> cycles) {
    final completedCycles = cycles.where((c) => c.isActive == false).toList();
    final avgCompletion = completedCycles.isNotEmpty
        ? completedCycles
                .map((c) => c.progressPercentage)
                .reduce((a, b) => a + b) /
            completedCycles.length
        : 0.0;

    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(vertical: 20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.surface.withValues(alpha: 0.75),
          AppColors.card.withValues(alpha: 0.55),
        ],
      ),
      showCornerAccent: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildOverviewItem(
            '总周期',
            '${cycles.length}',
            AppColors.primary,
          ),
          Container(width: 1, height: 32, color: AppColors.divider),
          _buildOverviewItem(
            '已完成',
            '${completedCycles.length}',
            AppColors.success,
          ),
          Container(width: 1, height: 32, color: AppColors.divider),
          _buildOverviewItem(
            '平均完成率',
            '${(avgCompletion * 100).round()}%',
            AppColors.warmAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyles.statValue.copyWith(fontSize: 22, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyles.caption),
      ],
    );
  }

  Widget _buildCompletionChart(List<Cycle> cycles) {
    final completedCycles = cycles.where((c) => c.isActive == false).toList();

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
        child: completedCycles.isEmpty
            ? Center(
                child: Text('暂无数据', style: TextStyles.body2),
              )
            : LineChart(
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
}
