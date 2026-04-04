import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/database/app_database.dart';
import '../../providers/cycle_provider.dart';
import '../../providers/task_provider.dart';
import 'widgets/add_task_dialog.dart';
import 'widgets/task_card.dart';

class TaskListPage extends ConsumerStatefulWidget {
  const TaskListPage({super.key});

  @override
  ConsumerState<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends ConsumerState<TaskListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTasks();
    });
  }

  void _loadTasks() {
    final activeCycle = ref.read(activeCycleProvider);
    activeCycle.whenData((cycle) {
      if (cycle != null) {
        ref.read(tasksNotifierProvider(cycle.id).notifier).loadTasks(cycle.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeCycleAsync = ref.watch(activeCycleProvider);

    return activeCycleAsync.when(
      data: (cycle) {
        if (cycle == null) {
          return _buildNoCycleState();
        }
        return _buildTaskList(cycle);
      },
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            '加载失败: $e',
            style: TextStyles.body2.copyWith(color: AppColors.error),
          ),
        ),
      ),
    );
  }

  Widget _buildNoCycleState() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('任务列表', style: TextStyles.heading4),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: AppColors.textTertiary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              '暂无活动周期',
              style: TextStyles.body1.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              '请先创建一个周期计划',
              style: TextStyles.caption,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/create-cycle'),
              icon: const Icon(Icons.add, size: 20),
              label: const Text('创建周期'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(Cycle cycle) {
    final tasksAsync = ref.watch(tasksNotifierProvider(cycle.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(cycle.name, style: TextStyles.heading4),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () => _showAddTaskDialog(cycle.id),
          ),
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return _buildEmptyState(cycle.id);
          }

          final inProgressTasks = tasks.where((t) => !t.isCompleted).toList();
          final completedTasks = tasks.where((t) => t.isCompleted).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (inProgressTasks.isNotEmpty) ...[
                Text('进行中 (${inProgressTasks.length})', style: TextStyles.label),
                const SizedBox(height: 8),
                ...inProgressTasks.map((task) => TaskCard(
                  name: task.name,
                  planName: cycle.name,
                  completedAmount: task.completedAmount,
                  targetAmount: task.targetAmount,
                  isCompleted: task.isCompleted,
                  onTap: () => context.push('/tasks/${task.id}'),
                )),
                const SizedBox(height: 16),
              ],
              if (completedTasks.isNotEmpty) ...[
                Text('已完成 (${completedTasks.length})', style: TextStyles.label),
                const SizedBox(height: 8),
                ...completedTasks.map((task) => TaskCard(
                  name: task.name,
                  planName: cycle.name,
                  completedAmount: task.completedAmount,
                  targetAmount: task.targetAmount,
                  isCompleted: task.isCompleted,
                  onTap: () => context.push('/tasks/${task.id}'),
                )),
              ],
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
        ),
        error: (e, _) => Center(
          child: Text(
            '加载失败: $e',
            style: TextStyles.body2.copyWith(color: AppColors.error),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(cycle.id),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(String cycleId) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt_outlined,
            size: 64,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '暂无任务',
            style: TextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            '点击右下角按钮添加任务',
            style: TextStyles.caption,
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(String cycleId) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(cycleId: cycleId),
    );
  }
}
