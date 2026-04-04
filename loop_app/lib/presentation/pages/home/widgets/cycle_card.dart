import 'package:flutter/material.dart';
import 'package:loop/core/theme/colors.dart';
import 'package:loop/core/theme/text_styles.dart';
import 'package:loop/presentation/widgets/common/animated_widgets.dart';
import 'package:loop/presentation/widgets/common/glass_card.dart';

class CycleCard extends StatelessWidget {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final int planCount;
  final int colorIndex;

  const CycleCard({
    super.key,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    this.planCount = 0,
    this.colorIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final totalDays = endDate.difference(startDate).inDays + 1;
    final remainingDays = endDate.difference(now).inDays;
    final progress =
        totalDays > 0 ? (1 - (remainingDays / totalDays)).clamp(0.0, 1.0) : 0.0;
    final accentColor =
        AppColors.cardColors[colorIndex % AppColors.cardColors.length];

    return GlassCard(
      enableTapScale: true,
      padding: const EdgeInsets.all(16),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyles.heading5,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryMuted,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$remainingDays 天剩余',
                            style: TextStyles.captionSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_formatDate(startDate)} - ${_formatDate(endDate)}',
                    style: TextStyles.labelSmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  if (planCount > 0) ...[
                    const SizedBox(height: 2),
                    Text(
                      '$planCount 个计划',
                      style: TextStyles.captionSmall,
                    ),
                  ],
                  const SizedBox(height: 12),
                  AnimatedProgressIndicator(
                    progress: progress,
                    height: 5,
                    backgroundColor: AppColors.surfaceElevated,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '共 $totalDays 天',
                        style: TextStyles.captionSmall,
                      ),
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}%',
                        style: TextStyles.captionSmall.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}月${date.day}日';
  }
}
