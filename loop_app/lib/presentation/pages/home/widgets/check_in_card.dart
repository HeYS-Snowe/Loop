// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop/core/theme/colors.dart';
import 'package:loop/core/theme/text_styles.dart';
import 'package:loop/presentation/providers/check_in_provider.dart';
import 'package:loop/presentation/widgets/common/glass_card.dart';
import 'package:loop/presentation/widgets/common/gradient_decorations.dart';

class CheckInCard extends ConsumerWidget {
  const CheckInCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<CheckInState> checkInState = ref.watch(checkInNotifierProvider);

    return checkInState.when(
      data: (CheckInState state) => _buildCard(ref, state),
      loading: () => const GlassCard(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      ),
      error: (Object e, _) => GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            '加载失败: $e',
            style: TextStyles.body2.copyWith(color: AppColors.error),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(WidgetRef ref, CheckInState state) {
    return GestureDetector(
      onTap: state.checkedIn
          ? null
          : () => ref.read(checkInNotifierProvider.notifier).checkIn(),
      child: GradientContainer(
        style: state.checkedIn
            ? GradientStyle.success
            : GradientStyle.primaryToAccent,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.checkedIn ? '今日已打卡' : '点击打卡',
                        style: TextStyles.heading4.copyWith(
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '已连续 ${state.streakCount} 天',
                        style: TextStyles.body2.copyWith(
                          color: AppColors.textOnPrimary.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(
                      state.checkedIn ? 0.25 : 0.15,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    state.checkedIn
                        ? Icons.check_rounded
                        : Icons.touch_app_rounded,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _CheckInStatChip(
                  label: '连续打卡',
                  value: '${state.streakCount} 天',
                ),
                const SizedBox(width: 20),
                _CheckInStatChip(
                  label: '最长记录',
                  value: '${state.maxStreak} 天',
                ),
                const SizedBox(width: 20),
                _CheckInStatChip(
                  label: '累计打卡',
                  value: '${state.totalCheckIns} 天',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckInStatChip extends StatelessWidget {
  final String label;
  final String value;

  const _CheckInStatChip({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyles.captionSmall.copyWith(
              color: Colors.white.withOpacity(0.70),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyles.numberSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
