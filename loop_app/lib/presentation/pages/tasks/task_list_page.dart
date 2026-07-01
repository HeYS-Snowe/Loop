import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loop_app/l10n/generated/app_localizations.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/database/app_database.dart';
import '../../providers/cycle_provider.dart';
import '../../providers/task_provider.dart';
import '../../widgets/common/gradient_decorations.dart';
import '../../widgets/common/animated_widgets.dart';
import 'widgets/task_card.dart';
import 'widgets/add_task_dialog.dart';
import 'widgets/edit_task_dialog.dart';

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
        title: Text(S.of(context)!.taskList, style: TextStyles.heading3),
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
            Text(S.of(context)!.noActiveCycle, style: TextStyles.heading4),
            const SizedBox(height: 8),
            Text(S.of(context)!.pleaseCreateCycleFirst,
                style: TextStyles.body2),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => context.go(RouteConstants.createCycle),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(S.of(context)!.createCycleBtn,
                    style: TextStyles.button),
              ),
            ),
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
        title: Text(S.of(context)!.taskList, style: TextStyles.heading3),
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
              onPressed: () => _showFilterSheet(context, ref),
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
          Text(S.of(context)!.noTask, style: TextStyles.heading4),
          const SizedBox(height: 8),
          Text(S.of(context)!.addTaskHint, style: TextStyles.body2),
        ],
      ),
    );
  }

  Widget _buildTaskList(
      BuildContext context, WidgetRef ref, List<Task> tasks, String cycleId) {
    final filter = ref.watch(taskFilterProvider);
    final completedTasks = tasks.where((t) => t.isCompleted).toList();
    final pendingTasks = tasks.where((t) => !t.isCompleted).toList();

    final showPending = filter == 0 || filter == 1;
    final showCompleted = filter == 0 || filter == 2;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 80, 20, 100),
      children: [
        if (showPending && pendingTasks.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              S.of(context)!.inProgressCount(pendingTasks.length),
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
                    onEdit: () => _showEditTaskDialog(context, entry.value),
                    onProgressUpdate: (amount) {
                      ref
                          .read(taskNotifierProvider(cycleId).notifier)
                          .updateProgress(entry.value.id, amount);
                    },
                  ),
                ),
              )),
        ],
        if (showCompleted && completedTasks.isNotEmpty) ...[
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              S.of(context)!.completedCount(completedTasks.length),
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
                    onEdit: () => _showEditTaskDialog(context, entry.value),
                  ),
                ),
              )),
        ],
      ],
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    final s = S.of(context)!;
    final current = ref.read(taskFilterProvider);
    final options = [
      (0, s.total, Icons.list_rounded),
      (1, s.inProgress, Icons.play_circle_outline_rounded),
      (2, s.completed, Icons.check_circle_outline_rounded),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(s.filterTasks, style: TextStyles.heading4),
              ),
              ...options.map((opt) {
                final (value, label, icon) = opt;
                final isSelected = value == current;
                return ListTile(
                  leading: Icon(icon,
                      size: 20,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary),
                  title: Text(label,
                      style: TextStyles.body1.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      )),
                  trailing: isSelected
                      ? const Icon(Icons.check_rounded,
                          size: 18, color: AppColors.primary)
                      : null,
                  onTap: () {
                    ref.read(taskFilterProvider.notifier).setFilter(value);
                    Navigator.pop(sheetContext);
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditTaskDialog(task: task),
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
