import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop/core/theme/colors.dart';
import 'package:loop/core/theme/text_styles.dart';
import 'package:loop/data/database/app_database.dart';
import 'package:loop/presentation/providers/task_provider.dart';
import 'package:loop/presentation/widgets/common/animated_widgets.dart';
import 'package:loop/presentation/widgets/common/glass_card.dart';

final progressRecordsProvider =
    FutureProvider.family<List<ProgressRecord>, String>((ref, taskId) async {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.getProgressRecords(taskId);
});

class TaskDetailPage extends ConsumerWidget {
  final String taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskDetailProvider(taskId));
    final recordsAsync = ref.watch(progressRecordsProvider(taskId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('任务详情', style: TextStyles.heading4),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: taskAsync.when(
        data: (task) {
          if (task == null) {
            return Center(
              child: Text(
                '任务不存在',
                style: TextStyles.body2.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInWidget(
                  child: _buildTaskInfoCard(task),
                ),
                const SizedBox(height: 16),
                FadeInWidget(
                  duration: const Duration(milliseconds: 400),
                  child: _buildProgressCard(task),
                ),
                const SizedBox(height: 16),
                FadeInWidget(
                  duration: const Duration(milliseconds: 600),
                  child: _buildCompletionStatusCard(task),
                ),
                const SizedBox(height: 20),
                FadeInWidget(
                  duration: const Duration(milliseconds: 800),
                  child: _buildRecordsSection(recordsAsync),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => Center(
          child: Text(
            '加载失败: $error',
            style: TextStyles.body2.copyWith(color: AppColors.error),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskInfoCard(Task task) {
    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.name,
                  style: TextStyles.heading3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (task.isCompleted)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.successMuted,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '已完成',
                    style: TextStyles.labelSmall.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ),
            ],
          ),
          if (task.description != null && task.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              task.description!,
              style: TextStyles.body3,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          if (task.unit != null && task.unit!.isNotEmpty)
            _buildInfoRow(
              Icons.straighten_outlined,
              '单位',
              task.unit!,
            ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(Task task) {
    final progress =
        task.targetAmount > 0 ? task.completedAmount / task.targetAmount : 0.0;
    final clampedProgress = progress.clamp(0.0, 1.0);
    final percent = (clampedProgress * 100).toInt();

    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('进度', style: TextStyles.heading5),
              Text(
                '$percent%',
                style: TextStyles.heading4.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProgressBar(clampedProgress),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '已完成 ${task.completedAmount}',
                style: TextStyles.labelSmall,
              ),
              Text(
                '目标 ${task.targetAmount}',
                style: TextStyles.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
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

  Widget _buildCompletionStatusCard(Task task) {
    final remaining = task.targetAmount - task.completedAmount;
    final isOver = remaining <= 0;

    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isOver
                  ? AppColors.successMuted
                  : AppColors.accentMuted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isOver ? Icons.check_circle_outline : Icons.pending_outlined,
              color: isOver ? AppColors.success : AppColors.accent,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOver ? '已完成' : '进行中',
                  style: TextStyles.body1,
                ),
                const SizedBox(height: 2),
                Text(
                  isOver
                      ? '恭喜，已达成目标'
                      : '还差 $remaining ${task.unit ?? ''} 达成目标',
                  style: TextStyles.body3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsSection(AsyncValue<List<ProgressRecord>> recordsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            '完成记录',
            style: TextStyles.heading5,
          ),
        ),
        recordsAsync.when(
          data: (records) {
            if (records.isEmpty) {
              return GlassCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    '暂无完成记录',
                    style: TextStyles.body3.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              );
            }

            final sortedRecords = List<ProgressRecord>.from(records)
              ..sort((a, b) => b.date.compareTo(a.date));

            return GlassCard(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: sortedRecords.map((record) {
                  return _buildRecordItem(record);
                }).toList(),
              ),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildRecordItem(ProgressRecord record) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(record.date),
                  style: TextStyles.body2,
                ),
                if (record.note != null && record.note!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    record.note!,
                    style: TextStyles.body3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryMuted,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+${record.amount}',
              style: TextStyles.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyles.body3.copyWith(color: AppColors.textTertiary),
          ),
          Text(value, style: TextStyles.body3),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${_pad(date.month)}-${_pad(date.day)} ${_pad(date.hour)}:${_pad(date.minute)}';
  }

  String _pad(int value) => value.toString().padLeft(2, '0');
}
