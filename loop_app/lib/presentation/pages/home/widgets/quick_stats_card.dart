import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../providers/check_in_provider.dart';
import '../../../providers/cycle_provider.dart';
import '../../../../data/extensions/model_extensions.dart';
import '../../../widgets/common/glass_card.dart';

class QuickStatsCard extends ConsumerWidget {
  const QuickStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkInStatsAsync = ref.watch(checkInStatsProvider);
    final activeCycleAsync = ref.watch(activeCycleProvider);

    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.surface.withValues(alpha: 0.7),
          AppColors.card.withValues(alpha: 0.55),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              context,
              icon: Icons.local_fire_department_rounded,
              label: '连续打卡',
              valueAsync: checkInStatsAsync,
              getValue: (stats) => '${stats.currentStreak}',
              unit: '天',
              color: AppColors.warmAccent,
              colorMuted: Color(0xFF3D2A1A),
            ),
          ),
          Container(
            width: 1,
            height: 36,
            color: AppColors.divider,
          ),
          Expanded(
            child: _buildStatItem(
              context,
              icon: Icons.emoji_events_rounded,
              label: '最长记录',
              valueAsync: checkInStatsAsync,
              getValue: (stats) => '${stats.maxStreak}',
              unit: '天',
              color: AppColors.gold,
              colorMuted: AppColors.goldMuted,
            ),
          ),
          Container(
            width: 1,
            height: 36,
            color: AppColors.divider,
          ),
          Expanded(
            child: _buildStatItem(
              context,
              icon: Icons.schedule_rounded,
              label: '当前周期',
              valueAsync: activeCycleAsync,
              getValue: (cycle) => cycle != null ? '${cycle.remainingDays}' : '-',
              unit: '天',
              color: AppColors.accent,
              colorMuted: Color(0xFF0D2D3D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem<T>(
    BuildContext context, {
    required IconData icon,
    required String label,
    required AsyncValue<T> valueAsync,
    required String Function(T) getValue,
    required String unit,
    required Color color,
    required Color colorMuted,
  }) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colorMuted,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 10),
        valueAsync.when(
          data: (data) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                getValue(data),
                style: TextStyles.statValue.copyWith(
                  fontSize: 22,
                ),
              ),
              const SizedBox(width: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  unit,
                  style: TextStyles.caption.copyWith(
                    color: color,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          loading: () => const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ),
          error: (_, __) => const Text('-'),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyles.caption,
        ),
      ],
    );
  }
}
