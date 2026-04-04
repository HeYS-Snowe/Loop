import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loop_app/core/theme/colors.dart';
import 'package:loop_app/core/theme/text_styles.dart';
import 'package:loop_app/data/database/app_database.dart';
import 'package:loop_app/presentation/providers/plan_provider.dart';

class DailyPlanPage extends ConsumerStatefulWidget {
  const DailyPlanPage({super.key});

  @override
  ConsumerState<DailyPlanPage> createState() => _DailyPlanPageState();
}

class _DailyPlanPageState extends ConsumerState<DailyPlanPage> {
  late DateTime _selectedDate;
  bool _hasScrolledToCurrentTime = false;

  static const double _hourHeight = 72.0;
  static const int _startHour = 6;
  static const int _endHour = 23;
  static const double _timeLabelWidth = 48.0;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(planInstanceNotifierProvider.notifier).loadForDate(_selectedDate);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentTime() {
    if (!_scrollController.hasClients) return;
    final now = DateTime.now();
    final hour = now.hour;
    if (hour >= _startHour && hour < _endHour) {
      final offset = (hour - _startHour) * _hourHeight - 40;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            offset.clamp(0.0, _scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _changeDate(DateTime date) {
    setState(() => _selectedDate = date);
    ref.read(planInstanceNotifierProvider.notifier).loadForDate(date);
  }

  @override
  Widget build(BuildContext context) {
    final instancesAsync = ref.watch(planInstanceNotifierProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(
        title: const Text('日计划', style: TextStyles.heading4),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () async {
              await context.push('/create-plan');
              if (mounted) {
                ref.read(planInstanceNotifierProvider.notifier).loadForDate(_selectedDate);
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundDeep, AppColors.background],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildWeekSelector(),
              Expanded(
                child: instancesAsync.when(
                  data: (instances) => _buildTimeTable(instances),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                  ),
                  error: (e, _) => Center(
                    child: Text('加载失败: $e', style: TextStyles.body2.copyWith(color: AppColors.error)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekSelector() {
    final now = DateTime.now();
    final weekday = now.weekday;
    final weekStart = DateTime(now.year, now.month, now.day).subtract(Duration(days: weekday - 1));

    return Container(
      height: 72,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(7, (index) {
          final date = weekStart.add(Duration(days: index));
          final isSelected = _isSameDay(date, _selectedDate);
          final isToday = _isSameDay(date, now);
          final dayNames = ['一', '二', '三', '四', '五', '六', '日'];

          return Expanded(
            child: GestureDetector(
              onTap: () => _changeDate(date),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : isToday
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayNames[index],
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected
                            ? AppColors.backgroundDeep
                            : isToday
                                ? AppColors.primary
                                : AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.w400,
                        color: isSelected
                            ? AppColors.backgroundDeep
                            : isToday
                                ? AppColors.primary
                                : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTimeTable(List<PlanInstance> instances) {
    final templatesFuture = ref.watch(allPlanTemplatesProvider);

    return templatesFuture.when(
      data: (templates) {
        final templateMap = {for (final t in templates) t.id: t};
        if (!_hasScrolledToCurrentTime) {
          _hasScrolledToCurrentTime = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToCurrentTime();
          });
        }

        final totalHeight = (_endHour - _startHour) * _hourHeight;

        return SingleChildScrollView(
          controller: _scrollController,
          child: SizedBox(
            height: totalHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimeLabels(totalHeight),
                Expanded(
                  child: _buildPlanGrid(instances, templateMap, totalHeight),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
      error: (e, _) => Center(child: Text('加载失败: $e', style: TextStyles.body2.copyWith(color: AppColors.error))),
    );
  }

  Widget _buildTimeLabels(double totalHeight) {
    return SizedBox(
      width: _timeLabelWidth,
      height: totalHeight,
      child: Stack(
        children: List.generate(_endHour - _startHour, (index) {
          final hour = _startHour + index;
          return Positioned(
            top: index * _hourHeight - 6,
            left: 0,
            right: 0,
            child: Text(
              '${hour.toString().padLeft(2, '0')}:00',
              style: TextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPlanGrid(
    List<PlanInstance> instances,
    Map<String, PlanTemplate> templateMap,
    double totalHeight,
  ) {
    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          _buildHourLines(totalHeight),
          ...instances.map((instance) {
            final template = templateMap[instance.planTemplateId];
            if (template == null) return const SizedBox.shrink();

            final startOffset = _getTimeOffset(template.startHour, template.startMinute);
            final endOffset = _getTimeOffset(template.endHour, template.endMinute);
            final cardHeight = (endOffset - startOffset).clamp(40.0, totalHeight);

            return Positioned(
              top: startOffset,
              left: 4,
              right: 8,
              height: cardHeight,
              child: _PlanCard(
                instance: instance,
                template: template,
                onTap: () => _showInstanceDetail(instance, template),
              ),
            );
          }),
          _buildCurrentTimeIndicator(totalHeight),
        ],
      ),
    );
  }

  Widget _buildHourLines(double totalHeight) {
    return SizedBox(
      height: totalHeight,
      child: Column(
        children: List.generate(_endHour - _startHour, (index) {
          return SizedBox(
            height: _hourHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.border.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentTimeIndicator(double totalHeight) {
    final now = DateTime.now();
    if (!_isSameDay(_selectedDate, now)) return const SizedBox.shrink();

    final offset = _getTimeOffset(now.hour, now.minute);
    if (offset < 0 || offset > totalHeight) return const SizedBox.shrink();

    return Positioned(
      top: offset,
      left: 0,
      right: 0,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Container(
              height: 1.5,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  double _getTimeOffset(int hour, int minute) {
    return (hour - _startHour + minute / 60.0) * _hourHeight;
  }

  void _showInstanceDetail(PlanInstance instance, PlanTemplate template) {
    final progress = instance.targetAmount > 0
        ? (instance.completedAmount / instance.targetAmount).clamp(0.0, 1.0)
        : (instance.isCompleted ? 1.0 : 0.0);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(template.colorValue),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(template.name, style: TextStyles.heading4),
                  ),
                  _buildCompletionToggle(instance),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow('时间', '${template.startHour.toString().padLeft(2, '0')}:${template.startMinute.toString().padLeft(2, '0')} - ${template.endHour.toString().padLeft(2, '0')}:${template.endMinute.toString().padLeft(2, '0')}'),
              if (instance.targetAmount > 0) ...[
                _buildDetailRow('进度', '${instance.completedAmount}/${instance.targetAmount} ${template.unit ?? ''}'),
                const SizedBox(height: 12),
                _buildDetailProgressBar(progress),
                const SizedBox(height: 12),
                _buildAmountInput(instance),
              ],
              if (template.description != null && template.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildDetailRow('描述', template.description!),
              ],
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompletionToggle(PlanInstance instance) {
    return GestureDetector(
      onTap: () {
        ref.read(planInstanceNotifierProvider.notifier).toggleComplete(instance.id);
        Navigator.pop(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: instance.isCompleted ? AppColors.success : Colors.transparent,
          border: Border.all(
            color: instance.isCompleted ? AppColors.success : AppColors.border,
            width: 1.5,
          ),
        ),
        child: instance.isCompleted
            ? const Icon(Icons.check, size: 16, color: AppColors.backgroundDeep)
            : null,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(label, style: TextStyles.body2.copyWith(color: AppColors.textTertiary)),
          ),
          Expanded(child: Text(value, style: TextStyles.body1)),
        ],
      ),
    );
  }

  Widget _buildDetailProgressBar(double progress) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 6,
        child: Stack(
          children: [
            Container(decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(4))),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: progress >= 1.0
                      ? const LinearGradient(colors: [AppColors.success, AppColors.successLight])
                      : AppColors.progressGradient,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput(PlanInstance instance) {
    final controller = TextEditingController(text: instance.completedAmount.toString());
    return Row(
      children: [
        Text('完成量:', style: TextStyles.body2),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyles.body1.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceLight,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              isDense: true,
            ),
            onSubmitted: (value) {
              final amount = int.tryParse(value) ?? 0;
              ref.read(planInstanceNotifierProvider.notifier).updateCompletedAmount(instance.id, amount);
              Navigator.pop(context);
            },
          ),
        ),
        const SizedBox(width: 8),
        Text('/ ${instance.targetAmount}', style: TextStyles.body2),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _PlanCard extends StatelessWidget {
  final PlanInstance instance;
  final PlanTemplate template;
  final VoidCallback onTap;

  const _PlanCard({
    required this.instance,
    required this.template,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(template.colorValue);
    final progress = instance.targetAmount > 0
        ? (instance.completedAmount / instance.targetAmount).clamp(0.0, 1.0)
        : (instance.isCompleted ? 1.0 : 0.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: instance.isCompleted ? AppColors.success : Colors.transparent,
                    border: Border.all(
                      color: instance.isCompleted ? AppColors.success : color,
                      width: 1.2,
                    ),
                  ),
                  child: instance.isCompleted
                      ? const Icon(Icons.check, size: 8, color: AppColors.backgroundDeep)
                      : null,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    template.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color,
                      decoration: instance.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (instance.targetAmount > 0) ...[
              const SizedBox(height: 4),
              Text(
                '${instance.completedAmount}/${instance.targetAmount} ${template.unit ?? ''}',
                style: TextStyle(
                  fontSize: 11,
                  color: color.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 3),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: SizedBox(
                  height: 3,
                  child: Stack(
                    children: [
                      Container(color: color.withValues(alpha: 0.15)),
                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(color: color),
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
  }
}
