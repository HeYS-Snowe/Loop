import 'package:flutter/material.dart';
import 'package:loop/core/theme/colors.dart';
import 'package:loop/core/theme/text_styles.dart';
import 'package:loop/presentation/widgets/common/glass_card.dart';

class TaskCard extends StatelessWidget {
  final String name;
  final String planName;
  final int completedAmount;
  final int targetAmount;
  final bool isCompleted;
  final int colorValue;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.name,
    required this.planName,
    required this.completedAmount,
    required this.targetAmount,
    this.isCompleted = false,
    this.colorValue = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        targetAmount > 0 ? completedAmount / targetAmount : 0.0;
    final clampedProgress = progress.clamp(0.0, 1.0);

    return GlassCard(
      enableTapScale: true,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: TextStyles.body1.copyWith(
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                      color: isCompleted
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusIcon(),
              ],
            ),
            if (planName.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                planName,
                style: TextStyles.body3.copyWith(
                  color: AppColors.textTertiary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            _buildProgressBar(clampedProgress),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$completedAmount/$targetAmount',
                  style: TextStyles.labelSmall.copyWith(
                    color: isCompleted
                        ? AppColors.success
                        : AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${(clampedProgress * 100).toInt()}%',
                  style: TextStyles.labelSmall.copyWith(
                    color: isCompleted
                        ? AppColors.success
                        : AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (isCompleted) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: AppColors.success,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check,
          size: 16,
          color: Colors.white,
        ),
      );
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.borderLight,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(3),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: isCompleted
                      ? const LinearGradient(
                          colors: [AppColors.success, AppColors.success],
                        )
                      : const LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
