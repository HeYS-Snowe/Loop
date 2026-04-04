import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../providers/check_in_provider.dart';
import '../../../widgets/common/glass_card.dart';
import '../../../widgets/common/animated_widgets.dart';

class CheckInCard extends ConsumerWidget {
  const CheckInCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkInStateAsync = ref.watch(checkInNotifierProvider);

    return checkInStateAsync.when(
      data: (state) => _buildCard(context, ref, state),
      loading: () => const GlassCard(
        child: SizedBox(height: 120),
      ),
      error: (error, stack) => GlassCard(
        child: SizedBox(
          height: 120,
          child: Center(
            child: Text('Error: $error', style: TextStyles.body2),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, WidgetRef ref, CheckInState state) {
    return GlassCard(
      borderRadius: 24,
      showCornerAccent: true,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.surface.withValues(alpha: 0.8),
          AppColors.card.withValues(alpha: 0.65),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '每日打卡',
                    style: TextStyles.heading4,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    state.checkedInToday ? '今日已打卡' : '今日未打卡',
                    style: TextStyles.body2.copyWith(
                      color: state.checkedInToday
                          ? AppColors.success
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              AnimatedScaleButton(
                onTap: state.checkedInToday
                    ? null
                    : () => ref.read(checkInNotifierProvider.notifier).checkIn(),
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: state.checkedInToday
                          ? [
                              AppColors.success.withValues(alpha: 0.25),
                              AppColors.success.withValues(alpha: 0.1),
                            ]
                          : [
                              AppColors.primary.withValues(alpha: 0.2),
                              AppColors.accent.withValues(alpha: 0.08),
                            ],
                    ),
                    border: Border.all(
                      color: state.checkedInToday
                          ? AppColors.success.withValues(alpha: 0.3)
                          : AppColors.primary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: state.checkedInToday
                        ? const Icon(
                            Icons.check_rounded,
                            size: 32,
                            color: AppColors.success,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${state.streakCount}',
                                style: TextStyles.statValue.copyWith(
                                  fontSize: 22,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                '天',
                                style: TextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
          if (!state.checkedInToday) ...[
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: AnimatedScaleButton(
                onTap: () =>
                    ref.read(checkInNotifierProvider.notifier).checkIn(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_rounded,
                        color: AppColors.backgroundDeep,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '立即打卡',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.backgroundDeep,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
