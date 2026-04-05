import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../data/database/app_database.dart';
import '../../../../data/extensions/model_extensions.dart';
import '../../../widgets/common/glass_card.dart';
import '../../../widgets/common/animated_widgets.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final void Function(int)? onProgressUpdate;
  final VoidCallback? onEdit;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onProgressUpdate,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      borderRadius: 20,
      padding: const EdgeInsets.all(18),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.surface.withValues(alpha: 0.75),
          AppColors.card.withValues(alpha: 0.55),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.name,
                  style: TextStyles.heading4.copyWith(
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                    color: task.isCompleted
                        ? AppColors.textTertiary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              if (onEdit != null)
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              if (onEdit != null) const SizedBox(width: 8),
              if (task.isCompleted)
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.successMuted,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: AppColors.success,
                  ),
                )
              else
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getProgressColor().withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getProgressText(),
                    style: TextStyles.label.copyWith(
                      color: _getProgressColor(),
                    ),
                  ),
                ),
            ],
          ),
          if (task.description != null) ...[
            const SizedBox(height: 8),
            Text(
              task.description!,
              style: TextStyles.body2,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: task.progress),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: _getProgressGradient(),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: _getProgressColor().withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (!task.isCompleted && onProgressUpdate != null) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildQuickActionButton(
                  label: '+1',
                  onPressed: () => onProgressUpdate!(1),
                ),
                const SizedBox(width: 10),
                _buildQuickActionButton(
                  label: '+5',
                  onPressed: () => onProgressUpdate!(5),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return AnimatedScaleButton(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyles.label.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color _getProgressColor() {
    if (task.progress >= 1.0) return AppColors.success;
    if (task.progress >= 0.5) return AppColors.primary;
    return AppColors.warmAccent;
  }

  LinearGradient _getProgressGradient() {
    if (task.progress >= 1.0) {
      return const LinearGradient(
        colors: [AppColors.success, AppColors.successLight],
      );
    }
    if (task.progress >= 0.5) {
      return AppColors.progressGradient;
    }
    return const LinearGradient(
      colors: [AppColors.warmAccent, AppColors.warning],
    );
  }

  String _getProgressText() {
    return '${task.completedAmount}/${task.targetAmount}';
  }
}
