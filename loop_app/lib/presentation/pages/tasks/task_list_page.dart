import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/database/app_database.dart';
import '../../providers/cycle_provider.dart';
import '../../providers/task_provider.dart';
import '../../widgets/common/gradient_decorations.dart';
import '../../widgets/common/animated_widgets.dart';
import 'widgets/task_card.dart';
import 'widgets/add_task_dialog.dart';

class TaskListPage extends ConsumerWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCycleAsync = ref.watch(activeCycleProvider);

    return activeCycleAsync.when(
      data: (cycle) {
        if (cycle == null) {
          return _buildNoCycleView(context);
        }
        return _buildTaskListView(context, ref, cycle.id);
      },
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text('Error: $error', style: TextStyles.body2),
        ),
      ),
    );
  }

  Widget _buildNoCycleView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('任务列表', style: TextStyles.heading3),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy_rounded,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text('暂无活动周期', style: TextStyles.heading4),
            const SizedBox(height: 8),
            Text('请先创建一个周期计划', style: TextStyles.body2),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskListView(
      BuildContext context, WidgetRef ref, String cycleId) {
    final tasksAsync = ref.watch(taskNotifierProvider(cycleId));

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('任务列表', style: TextStyles.heading3),
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
              icon: const Icon(Icons.filter_list_rounded, size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: GradientDecoration(
              style: GradientStyle.diagonalHalf,
              color: AppColors.accent,
            ),
          ),
          Positioned.fill(
            child: tasksAsync.when(
              data: (tasks) {
                if (tasks.isEmpty) {
                  return _buildEmptyView(context);
                }
                return _buildTaskList(context, ref, tasks, cycleId);
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
          onPressed: () => _showAddTaskDialog(context, cycleId),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.backgroundDeep,
          elevation: 0,
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt_rounded,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text('暂无任务', style: TextStyles.heading4),
          const SizedBox(height: 8),
          Text('点击右下角按钮添加任务', style: TextStyles.body2),
        ],
      ),
    );
  }

  Widget _buildTaskList(
      BuildContext context, WidgetRef ref, List<Task> tasks, String cycleId) {
    final completedTasks = tasks.where((t) => t.isCompleted).toList();
    final pendingTasks = tasks.where((t) => !t.isCompleted).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 80, 20, 100),
      children: [
        if (pendingTasks.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '进行中 (${pendingTasks.length})',
              style: TextStyles.overline,
            ),
          ),
          ...pendingTasks.asMap().entries.map((entry) => AnimatedPageWrapper(
                index: entry.key,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TaskCard(
                    task: entry.value,
                    onTap: () => context.go('/tasks/${entry.value.id}'),
                    onProgressUpdate: (amount) {
                      ref
                          .read(taskNotifierProvider(cycleId).notifier)
                          .updateProgress(entry.value.id, amount);
                    },
                  ),
                ),
              )),
        ],
        if (completedTasks.isNotEmpty) ...[
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '已完成 (${completedTasks.length})',
              style: TextStyles.overline,
            ),
          ),
          ...completedTasks.asMap().entries.map((entry) => AnimatedPageWrapper(
                index: entry.key + pendingTasks.length,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TaskCard(
                    task: entry.value,
                    onTap: () => context.go('/tasks/${entry.value.id}'),
                  ),
                ),
              )),
        ],
      ],
    );
  }

  void _showAddTaskDialog(BuildContext context, String cycleId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTaskDialog(cycleId: cycleId),
    );
  }
}
