import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loop_app/core/constants/route_constants.dart';
import 'package:loop_app/core/theme/colors.dart';
import 'package:loop_app/core/theme/text_styles.dart';
import 'package:loop_app/data/database/app_database.dart';
import 'package:loop_app/l10n/generated/app_localizations.dart';
import 'package:loop_app/presentation/providers/plan_provider.dart';
import 'package:loop_app/presentation/providers/timetable_provider.dart';

class DailyPlanPage extends ConsumerStatefulWidget {
  const DailyPlanPage({super.key});

  @override
  ConsumerState<DailyPlanPage> createState() => _DailyPlanPageState();
}

class _DailyPlanPageState extends ConsumerState<DailyPlanPage> {
  late DateTime _selectedDate;
  bool _hasScrolledToCurrentTime = false;
  int _weekOffset = 0;

  static const double _hourHeight = 72.0;
  static const int _startHour = 6;
  static const int _endHour = 23;
  static const double _timeLabelWidth = 48.0;

  static const List<Map<String, int>> _periodTimeSlots = [
    {'startHour': 8, 'startMinute': 0, 'endHour': 8, 'endMinute': 45},
    {'startHour': 8, 'startMinute': 55, 'endHour': 9, 'endMinute': 40},
    {'startHour': 10, 'startMinute': 0, 'endHour': 10, 'endMinute': 45},
    {'startHour': 10, 'startMinute': 55, 'endHour': 11, 'endMinute': 40},
    {'startHour': 14, 'startMinute': 0, 'endHour': 14, 'endMinute': 45},
    {'startHour': 14, 'startMinute': 55, 'endHour': 15, 'endMinute': 40},
    {'startHour': 16, 'startMinute': 0, 'endHour': 16, 'endMinute': 45},
    {'startHour': 16, 'startMinute': 55, 'endHour': 17, 'endMinute': 40},
    {'startHour': 19, 'startMinute': 0, 'endHour': 19, 'endMinute': 45},
    {'startHour': 19, 'startMinute': 55, 'endHour': 20, 'endMinute': 40},
  ];

  static const List<Color> _courseColors = [
    Color(0xFF4A90D9),
    Color(0xFF00BFA5),
    Color(0xFFFF7043),
    Color(0xFFAB47BC),
    Color(0xFF42A5F5),
    Color(0xFFFFCA28),
    Color(0xFF66BB6A),
    Color(0xFFEF5350),
  ];

  final ScrollController _scrollController = ScrollController();
  final PageController _weekPageController = PageController(initialPage: 5200);

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
    _weekPageController.dispose();
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
        title: Text(S.of(context)!.dailyPlan, style: TextStyles.heading4),
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
                    child: Text(S.of(context)!.loadFailed(e.toString()), style: TextStyles.body2.copyWith(color: AppColors.error)),
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
    final s = S.of(context)!;
    final dayNames = [s.mon, s.tue, s.wed, s.thu, s.fri, s.sat, s.sun];

    return Container(
      height: 72,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: PageView.builder(
        controller: _weekPageController,
        onPageChanged: (page) {
          final newOffset = page - 5200;
          final weekStart = _getWeekStart(now, newOffset);
          final targetDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
          setState(() {
            _weekOffset = newOffset;
            _selectedDate = targetDate;
          });
          ref.read(planInstanceNotifierProvider.notifier).loadForDate(targetDate);
        },
        itemBuilder: (context, page) {
          final offset = page - 5200;
          final weekStart = _getWeekStart(now, offset);

          return Row(
            children: List.generate(7, (index) {
              final date = weekStart.add(Duration(days: index));
              final isSelected = _isSameDay(date, _selectedDate);
              final isToday = _isSameDay(date, now);

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
                            fontFamily: 'MiSans',
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
                            fontFamily: 'MiSans',
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
          );
        },
      ),
    );
  }

  DateTime _getWeekStart(DateTime now, int weekOffset) {
    final weekday = now.weekday;
    return DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: weekday - 1))
        .add(Duration(days: weekOffset * 7));
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
      error: (e, _) => Center(child: Text(S.of(context)!.loadFailed(e.toString()), style: TextStyles.body2.copyWith(color: AppColors.error))),
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
    final coursesAsync = ref.watch(coursesForDateProvider(_selectedDate));

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
          ...coursesAsync.whenOrNull(
                data: (courses) => courses.map((course) {
                  final startPeriod = course.startPeriod;
                  final endPeriod = course.endPeriod;
                  if (startPeriod < 1 || startPeriod > _periodTimeSlots.length) {
                    return const SizedBox.shrink();
                  }
                  final effectiveEnd =
                      endPeriod.clamp(1, _periodTimeSlots.length);
                  final startTime =
                      _periodTimeSlots[startPeriod - 1];
                  final endTime =
                      _periodTimeSlots[effectiveEnd - 1];

                  final startOffset = _getTimeOffset(
                      startTime['startHour']!, startTime['startMinute']!);
                  final endOffset = _getTimeOffset(
                      endTime['endHour']!, endTime['endMinute']!);
                  final cardHeight = (endOffset - startOffset).clamp(40.0, totalHeight);

                  final colorIndex =
                      course.courseName.hashCode.abs() % _courseColors.length;
                  final color = _courseColors[colorIndex];

                  return Positioned(
                    top: startOffset,
                    left: 4,
                    right: 8,
                    height: cardHeight,
                    child: _CourseCard(
                      course: course,
                      color: color,
                      onTap: () => _showCourseDetail(course, color),
                    ),
                  );
                }).toList(),
              ) ??
              [],
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
    final s = S.of(context)!;
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToEditPlan(template);
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.12),
                      ),
                      child: const Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
                    ),
                  ),
                  _buildCompletionToggle(instance),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow(s.time, '${template.startHour.toString().padLeft(2, '0')}:${template.startMinute.toString().padLeft(2, '0')} - ${template.endHour.toString().padLeft(2, '0')}:${template.endMinute.toString().padLeft(2, '0')}'),
              if (instance.targetAmount > 0) ...[
                _buildDetailRow(s.progress, '${instance.completedAmount}/${instance.targetAmount} ${template.unit ?? ''}'),
                const SizedBox(height: 12),
                _buildDetailProgressBar(progress),
                const SizedBox(height: 12),
                _buildAmountInput(instance),
              ],
              if (template.description != null && template.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildDetailRow(s.descriptionOptional, template.description!),
              ],
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _navigateToEditPlan(PlanTemplate template) {
    context.push(
      RouteConstants.editPlan,
      extra: (template: template, currentDate: _selectedDate),
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
    final s = S.of(context)!;
    final controller = TextEditingController(text: instance.completedAmount.toString());
    return Row(
      children: [
        Text(s.completedAmountLabel, style: TextStyles.body2),
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

  void _showCourseDetail(TimetableCourse course, Color color) {
    final startTime = _periodTimeSlots[course.startPeriod - 1];
    final endTime = _periodTimeSlots[course.endPeriod.clamp(1, _periodTimeSlots.length) - 1];

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
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(course.courseName, style: TextStyles.heading4),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                S.of(context)!.time,
                '${startTime['startHour'].toString().padLeft(2, '0')}:${startTime['startMinute'].toString().padLeft(2, '0')} - ${endTime['endHour'].toString().padLeft(2, '0')}:${endTime['endMinute'].toString().padLeft(2, '0')}',
              ),
              if (course.teacherName != null && course.teacherName!.isNotEmpty)
                _buildDetailRow(S.of(context)!.teacherName, course.teacherName!),
              if (course.location != null && course.location!.isNotEmpty)
                _buildDetailRow(S.of(context)!.location, course.location!),
              _buildDetailRow(S.of(context)!.weekRanges, course.weekRanges),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
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

class _CourseCard extends StatelessWidget {
  final TimetableCourse course;
  final Color color;
  final VoidCallback onTap;

  const _CourseCard({
    required this.course,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(Icons.school_outlined, size: 14, color: color),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    course.courseName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (course.location != null && course.location!.isNotEmpty) ...[
              const SizedBox(height: 3),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      course.location!,
                      style: TextStyle(
                        fontSize: 11,
                        color: color.withValues(alpha: 0.75),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
