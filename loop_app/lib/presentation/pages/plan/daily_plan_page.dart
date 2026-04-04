import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loop/core/theme/colors.dart';
import 'package:loop/core/theme/text_styles.dart';
import 'package:loop/data/database/app_database.dart';
import 'package:loop/presentation/providers/plan_provider.dart';
import 'package:loop/presentation/widgets/common/animated_widgets.dart';

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
            curve: Curves.easeOutCubic,
          );
        }
      });
    }
  }

  void _changeDate(DateTime date) {
    setState(() => _selectedDate = date);
    _hasScrolledToCurrentTime = false;
    ref.read(planInstanceNotifierProvider.notifier).loadForDate(date);
  }

  @override
  Widget build(BuildContext context) {
    final instancesAsync = ref.watch(planInstanceNotifierProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('日计划', style: TextStyles.heading4),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.primary),
            onPressed: () async {
              await context.push('/create-plan');
              if (mounted) {
                await ref.read(planInstanceNotifierProvider.notifier).loadForDate(_selectedDate);
              }
            },
          ),
        ],
      ),
      body: Container(
        color: AppColors.backgroundDeep,
        child: SafeArea(
          child: Column(
            children: [
              _buildWeekSelector(),
              Expanded(
                child: instancesAsync.when(
                  data: (instances) => _buildTimeTable(instances),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
                  error: (e, _) => Center(
                    child: Text(
                      '加载失败: $e',
                      style: TextStyles.body2.copyWith(color: AppColors.error),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -- Week selector with date pills --

  Widget _buildWeekSelector() {
    final now = DateTime.now();
    final weekday = now.weekday;
    final weekStart = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: weekday - 1));

    return FadeInWidget(
      child: Container(
        height: 72,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.glassBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: List.generate(7, (index) {
            final date = weekStart.add(Duration(days: index));
            final isSelected = _isSameDay(date, _selectedDate);
            final isToday = _isSameDay(date, now);
            const dayNames = ['一', '二', '三', '四', '五', '六', '日'];

            return Expanded(
              child: GestureDetector(
                onTap: () => _changeDate(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : isToday
                            ? AppColors.primaryMuted
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: isToday && !isSelected
                        ? Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 1,
                          )
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayNames[index],
                        style: TextStyles.captionSmall.copyWith(
                          color: isSelected
                              ? AppColors.textOnPrimary
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
                          fontWeight:
                              isSelected || isToday ? FontWeight.w700 : FontWeight.w400,
                          color: isSelected
                              ? AppColors.textOnPrimary
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
      ),
    );
  }

  // -- Time table body --

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

        const totalHeight = (_endHour - _startHour) * _hourHeight;

        return SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 40),
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
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
      ),
      error: (e, _) => Center(
        child: Text(
          '加载失败: $e',
          style: TextStyles.body2.copyWith(color: AppColors.error),
        ),
      ),
    );
  }

  // -- Hour labels on the left --

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
              style: TextStyles.captionSmall.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }),
      ),
    );
  }

  // -- Plan cards grid with hour lines --

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

            final startOffset =
                _getTimeOffset(template.startHour, template.startMinute);
            final endOffset =
                _getTimeOffset(template.endHour, template.endMinute);
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

  // -- Dashed hour lines --

  Widget _buildHourLines(double totalHeight) {
    return SizedBox(
      height: totalHeight,
      child: Column(
        children: List.generate(_endHour - _startHour, (index) {
          return const SizedBox(
            height: _hourHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.dividerLight,
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

  // -- Red current-time indicator line --

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
            decoration: BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.errorMuted,
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 1.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.error,
                    AppColors.error.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -- Offset calculation --

  double _getTimeOffset(int hour, int minute) {
    return (hour - _startHour + minute / 60.0) * _hourHeight;
  }

  // -- Bottom sheet detail view --

  void _showInstanceDetail(PlanInstance instance, PlanTemplate template) {
    final progress = instance.targetAmount > 0
        ? (instance.completedAmount / instance.targetAmount).clamp(0.0, 1.0)
        : (instance.isCompleted ? 1.0 : 0.0);
    final color = Color(template.colorValue);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: AppColors.glassBorder,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 6),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Content
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 28,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              template.name,
                              style: TextStyles.heading4,
                            ),
                          ),
                          _buildCompletionToggle(instance),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Time row
                      _buildDetailRow(
                        Icons.schedule_rounded,
                        '时间',
                        '${template.startHour.toString().padLeft(2, '0')}:'
                        '${template.startMinute.toString().padLeft(2, '0')} - '
                        '${template.endHour.toString().padLeft(2, '0')}:'
                        '${template.endMinute.toString().padLeft(2, '0')}',
                      ),

                      // Progress section
                      if (instance.targetAmount > 0) ...[
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          Icons.bar_chart_rounded,
                          '进度',
                          '${instance.completedAmount}/${instance.targetAmount}'
                          '${template.unit != null ? ' ${template.unit}' : ''}',
                        ),
                        const SizedBox(height: 12),
                        AnimatedProgressIndicator(
                          progress: progress,
                          height: 8,
                          gradient: progress >= 1.0
                              ? const LinearGradient(
                                  colors: [AppColors.success, AppColors.successLight],
                                )
                              : LinearGradient(
                                  colors: [color, color.withValues(alpha: 0.6)],
                                ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 16),
                        _buildAmountInput(instance),
                      ],

                      // Description
                      if (template.description != null &&
                          template.description!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          Icons.notes_rounded,
                          '描述',
                          template.description!,
                        ),
                      ],

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
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
        curve: Curves.easeOutCubic,
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: instance.isCompleted ? AppColors.success : Colors.transparent,
          border: Border.all(
            color: instance.isCompleted ? AppColors.success : AppColors.borderLight,
            width: 1.5,
          ),
          boxShadow: instance.isCompleted
              ? const [
                  BoxShadow(
                    color: AppColors.successMuted,
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: instance.isCompleted
            ? const Icon(Icons.check_rounded, size: 18, color: AppColors.textOnPrimary)
            : null,
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: TextStyles.labelSmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyles.body2),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput(PlanInstance instance) {
    final controller = TextEditingController(text: instance.completedAmount.toString());
    return Row(
      children: [
        const Text('完成量:', style: TextStyles.body3),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyles.body2.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: AppColors.primary, width: 1),
              ),
              isDense: true,
            ),
            onSubmitted: (value) {
              final amount = int.tryParse(value) ?? 0;
              ref.read(planInstanceNotifierProvider.notifier).updateCompletedAmount(
                    instance.id,
                    amount,
                  );
              Navigator.pop(context);
            },
          ),
        ),
        const SizedBox(width: 8),
        Text('/ ${instance.targetAmount}', style: TextStyles.body3),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

// -- Plan card widget with colored left border and glass effect --

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
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.35),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              // Colored left border
              Container(
                width: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color, color.withValues(alpha: 0.4)],
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Name + status
                      Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: instance.isCompleted
                                  ? AppColors.success
                                  : Colors.transparent,
                              border: Border.all(
                                color: instance.isCompleted
                                    ? AppColors.success
                                    : color.withValues(alpha: 0.7),
                                width: 1.2,
                              ),
                              boxShadow: instance.isCompleted
                                  ? const [
                                      BoxShadow(
                                        color: AppColors.successMuted,
                                        blurRadius: 4,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: instance.isCompleted
                                ? const Icon(
                                    Icons.check_rounded,
                                    size: 9,
                                    color: AppColors.textOnPrimary,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              template.name,
                              style: TextStyles.labelSmall.copyWith(
                                color: instance.isCompleted
                                    ? AppColors.textTertiary
                                    : color,
                                fontWeight: FontWeight.w600,
                                decoration: instance.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      // Time range
                      const SizedBox(height: 2),
                      Text(
                        '${template.startHour.toString().padLeft(2, '0')}:'
                        '${template.startMinute.toString().padLeft(2, '0')} - '
                        '${template.endHour.toString().padLeft(2, '0')}:'
                        '${template.endMinute.toString().padLeft(2, '0')}',
                        style: TextStyles.captionSmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      // Progress
                      if (instance.targetAmount > 0) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${instance.completedAmount}/${instance.targetAmount}'
                              '${template.unit != null ? ' ${template.unit}' : ''}',
                              style: TextStyles.captionSmall.copyWith(
                                color: color.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        AnimatedProgressIndicator(
                          progress: progress,
                          height: 3,
                          gradient: LinearGradient(
                            colors: [color, color.withValues(alpha: 0.5)],
                          ),
                          backgroundColor: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
