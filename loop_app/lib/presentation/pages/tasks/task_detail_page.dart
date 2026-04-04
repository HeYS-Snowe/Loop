import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/extensions/model_extensions.dart';
import '../../providers/task_provider.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/gradient_decorations.dart';
import '../../widgets/common/animated_widgets.dart';

class TaskDetailPage extends ConsumerWidget {
  final String taskId;

  const TaskDetailPage({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskDetailProvider(taskId));

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('任务详情', style: TextStyles.heading3),
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: GradientDecoration(
              style: GradientStyle.radialGlow,
              color: AppColors.primary,
            ),
          ),
          Positioned.fill(
            child: taskAsync.when(
              data: (task) {
                if (task == null) {
                  return Center(
                    child: Text('任务不存在', style: TextStyles.body2),
                  );
                }
                return SafeArea(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.fromLTRB(20, 8, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedPageWrapper(
                          index: 0,
                          child: GlassCard(
                            borderRadius: 24,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.surface.withValues(alpha: 0.8),
                                AppColors.card.withValues(alpha: 0.6),
                              ],
                            ),
                            showCornerAccent: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (task.isCompleted)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.successMuted,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '已完成',
                                          style: TextStyles.label.copyWith(
                                            color: AppColors.success,
                                          ),
                                        ),
                                      )
                                    else
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryMuted,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '进行中',
                                          style: TextStyles.label.copyWith(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  task.name,
                                  style: TextStyles.heading2,
                                ),
                                if (task.description != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    task.description!,
                                    style: TextStyles.body1.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '进度',
                                          style: TextStyles.label,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${task.completedAmount} / ${task.targetAmount}',
                                          style: TextStyles.heading3.copyWith(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 72,
                                      height: 72,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.primary.withValues(alpha: 0.15),
                                            AppColors.accent.withValues(alpha: 0.08),
                                          ],
                                        ),
                                        border: Border.all(
                                          color: AppColors.primary.withValues(alpha: 0.2),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Center(
                                        child: TweenAnimationBuilder<double>(
                                          tween: Tween(
                                              begin: 0,
                                              end: task.progress * 100),
                                          duration: const Duration(
                                              milliseconds: 800),
                                          curve: Curves.easeOutCubic,
                                          builder:
                                              (context, value, child) {
                                            return Text(
                                              '${value.round()}%',
                                              style: TextStyles.heading4
                                                  .copyWith(
                                                color: AppColors.primary,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween(
                                        begin: 0, end: task.progress),
                                    duration:
                                        const Duration(milliseconds: 800),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, value, child) {
                                      return Container(
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceLight,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: FractionallySizedBox(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: value,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient:
                                                  AppColors.progressGradient,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.primary
                                                      .withValues(alpha: 0.3),
                                                  blurRadius: 10,
                                                  offset:
                                                      const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (!task.isCompleted) ...[
                          const SizedBox(height: 24),
                          AnimatedPageWrapper(
                            index: 1,
                            child: GlassCard(
                              borderRadius: 20,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.surface.withValues(alpha: 0.75),
                                  AppColors.card.withValues(alpha: 0.55),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text('更新进度', style: TextStyles.heading4),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AnimatedScaleButton(
                                          onTap: () => _updateProgress(
                                              ref, task.cycleId, task.id, 1),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: AppColors.primary
                                                    .withValues(alpha: 0.2),
                                              ),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                '+1',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: AnimatedScaleButton(
                                          onTap: () => _updateProgress(
                                              ref, task.cycleId, task.id, 5),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: AppColors.primary
                                                    .withValues(alpha: 0.2),
                                              ),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                '+5',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: AnimatedScaleButton(
                                          onTap: () => _updateProgress(
                                              ref, task.cycleId, task.id, 10),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: AppColors.primary
                                                    .withValues(alpha: 0.2),
                                              ),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                '+10',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
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
        ],
      ),
    );
  }

  void _updateProgress(
      WidgetRef ref, String cycleId, String taskId, int amount) {
    ref
        .read(taskNotifierProvider(cycleId).notifier)
        .updateProgress(taskId, amount);
  }
}
