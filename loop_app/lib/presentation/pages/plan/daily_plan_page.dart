import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loop_app/core/constants/route_constants.dart';
import 'package:loop_app/core/constants/time_slot_constants.dart';
import 'package:loop_app/core/constants/palette_colors.dart';
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

enum _DateViewLevel { day, week, month }

class _DailyPlanPageState extends ConsumerState<DailyPlanPage> {
  late DateTime _selectedDate;

  static const int _startHour = 0;
  static const int _endHour = 24;
  static const double _timeLabelWidth = 48.0;
  static const int _dayPageCenter = 36500;
  static const double _scrollPaddingTop = 80.0;
  static const double _scrollPaddingBottom = 80.0;

  static const List<({int interval, String label, double hourHeight})> _zoomLevels = [
    (interval: 120, label: '2h',  hourHeight: 36.0),
    (interval: 60,  label: '1h',  hourHeight: 72.0),
    (interval: 45,  label: '45m', hourHeight: 96.0),
    (interval: 30,  label: '30m', hourHeight: 144.0),
    (interval: 15,  label: '15m', hourHeight: 288.0),
    (interval: 10,  label: '10m', hourHeight: 432.0),
    (interval: 5,   label: '5m',  hourHeight: 864.0),
  ];
  int _currentZoomLevel = 1;
  double _lastScaleFactor = 1.0;

  double get _hourHeight => _zoomLevels[_currentZoomLevel].hourHeight;
  int get _currentInterval => _zoomLevels[_currentZoomLevel].interval;

  _DateViewLevel _dateViewLevel = _DateViewLevel.week;
  double _dateViewLastScale = 1.0;



  static const List<Color> _courseColors = PaletteColors.courseColors;

  final PageController _weekPageController = PageController(initialPage: 5200);
  final PageController _dayPageController =
      PageController(initialPage: _dayPageCenter);
  bool _isSyncingDayPage = false;
  bool _isSyncingWeekPage = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(planInstanceNotifierProvider.notifier)
          .loadForDate(_selectedDate);
    });
  }

  @override
  void dispose() {
    _weekPageController.dispose();
    _dayPageController.dispose();
    super.dispose();
  }

  void _changeDate(DateTime date,
      {bool syncDayPage = false, bool syncWeekPage = false}) {
    setState(() => _selectedDate = date);
    ref.read(planInstanceNotifierProvider.notifier).loadForDate(date);

    if (syncDayPage && !_isSyncingDayPage) {
      _isSyncingDayPage = true;
      final dayOffset = date.difference(DateTime.now()).inDays;
      final targetPage = _dayPageCenter + dayOffset;
      if (_dayPageController.hasClients &&
          (_dayPageController.page?.round() ?? _dayPageCenter) != targetPage) {
        _dayPageController.jumpToPage(targetPage);
      }
      _isSyncingDayPage = false;
    }

    if (syncWeekPage && !_isSyncingWeekPage) {
      _isSyncingWeekPage = true;
      final now = DateTime.now();
      final currentWeekStart = _getWeekStart(now, 0);
      final targetWeekStart = _getWeekStart(date, 0);
      final weekDiff = targetWeekStart.difference(currentWeekStart).inDays ~/ 7;
      final targetWeekPage = 5200 + weekDiff;
      if (_weekPageController.hasClients &&
          (_weekPageController.page?.round() ?? 5200) != targetWeekPage) {
        _weekPageController.jumpToPage(targetWeekPage);
      }
      _isSyncingWeekPage = false;
    }
  }

  DateTime _getDateFromDayPage(int page) {
    final now = DateTime.now();
    final diff = page - _dayPageCenter;
    return DateTime(now.year, now.month, now.day).add(Duration(days: diff));
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
                ref
                    .read(planInstanceNotifierProvider.notifier)
                    .loadForDate(_selectedDate);
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
          bottom: false,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewPadding.bottom + 80.0,
            ),
            child: Column(
            children: [
              _buildWeekIndicator(),
              _buildWeekSelector(),
              Expanded(
                child: instancesAsync.when(
                  data: (instances) => _buildDayPageView(instances),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary, strokeWidth: 2),
                  ),
                  error: (e, _) => Center(
                    child: Text(S.of(context)!.loadFailed(e.toString()),
                        style:
                            TextStyles.body2.copyWith(color: AppColors.error)),
                  ),
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayPageView(List<PlanInstance> instances) {
    return GestureDetector(
      onScaleStart: (_) {
        _lastScaleFactor = 1.0;
      },
      onScaleUpdate: (details) {
        if (details.pointerCount != 2) return;
        final scaleDelta = details.scale / _lastScaleFactor;
        _lastScaleFactor = details.scale;
        if (scaleDelta > 1.15 && _currentZoomLevel < _zoomLevels.length - 1) {
          setState(() => _currentZoomLevel++);
          _lastScaleFactor = details.scale;
        } else if (scaleDelta < 0.85 && _currentZoomLevel > 0) {
          setState(() => _currentZoomLevel--);
          _lastScaleFactor = details.scale;
        }
      },
      child: PageView.builder(
        controller: _dayPageController,
        onPageChanged: (page) {
          if (_isSyncingDayPage) return;
          final date = _getDateFromDayPage(page);
          _changeDate(date, syncWeekPage: true);
        },
        itemBuilder: (context, page) {
          return _buildTimeTable(instances);
        },
      ),
    );
  }

  Widget _buildWeekIndicator() {
    final timetableAsync = ref.watch(activeTimetableProvider);
    final s = S.of(context)!;

    return timetableAsync.when(
      data: (timetable) {
        if (timetable == null) return const SizedBox.shrink();

        final firstMonday = DateTime(
          timetable.firstWeekMonday.year,
          timetable.firstWeekMonday.month,
          timetable.firstWeekMonday.day,
        );
        final diff = _selectedDate.difference(firstMonday).inDays;
        if (diff < 0) return const SizedBox.shrink();

        final weekNumber = diff ~/ 7 + 1;
        if (weekNumber > timetable.totalWeeks) return const SizedBox.shrink();

        final now = DateTime.now();
        final nowDiff = now.difference(firstMonday).inDays;
        final currentWeekNumber = nowDiff >= 0 ? nowDiff ~/ 7 + 1 : 0;
        final isCurrentWeek = weekNumber == currentWeekNumber;
        final weekText = isCurrentWeek
            ? s.weekFormat(weekNumber)
            : s.weekFormatNotCurrent(weekNumber);

        final firstMonth = timetable.firstWeekMonday.month;
        final firstYear = timetable.firstWeekMonday.year;
        final monthNumber = (_selectedDate.year - firstYear) * 12 + (_selectedDate.month - firstMonth) + 1;
        final currentMonthNumber = (now.year - firstYear) * 12 + (now.month - firstMonth) + 1;
        final isCurrentMonth = monthNumber == currentMonthNumber;
        final monthText = monthNumber > 0
            ? (isCurrentMonth
                ? s.monthFormat(monthNumber)
                : s.monthFormatNotCurrent(monthNumber))
            : '';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                weekText,
                style: TextStyles.caption.copyWith(
                  color: isCurrentWeek ? AppColors.primary : AppColors.textTertiary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              if (monthText.isNotEmpty)
                Text(
                  monthText,
                  style: TextStyles.caption.copyWith(
                    color: isCurrentMonth ? AppColors.accent : AppColors.textTertiary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildWeekSelector() {
    return GestureDetector(
      onScaleStart: (_) {
        _dateViewLastScale = 1.0;
      },
      onScaleUpdate: (details) {
        if (details.pointerCount != 2) return;
        final scaleDelta = details.scale / _dateViewLastScale;
        _dateViewLastScale = details.scale;
        if (scaleDelta > 1.2) {
          _dateViewLastScale = details.scale;
          if (_dateViewLevel == _DateViewLevel.month) {
            setState(() => _dateViewLevel = _DateViewLevel.week);
          } else if (_dateViewLevel == _DateViewLevel.week) {
            setState(() => _dateViewLevel = _DateViewLevel.day);
          }
        } else if (scaleDelta < 0.8) {
          _dateViewLastScale = details.scale;
          if (_dateViewLevel == _DateViewLevel.day) {
            setState(() => _dateViewLevel = _DateViewLevel.week);
          } else if (_dateViewLevel == _DateViewLevel.week) {
            setState(() => _dateViewLevel = _DateViewLevel.month);
          }
        }
      },
      child: switch (_dateViewLevel) {
        _DateViewLevel.day => _buildDayView(),
        _DateViewLevel.week => _buildWeekView(),
        _DateViewLevel.month => _buildMonthView(),
      },
    );
  }

  Widget _buildDayView() {
    final s = S.of(context)!;
    final dayNames = [s.monday, s.tuesday, s.wednesday, s.thursday, s.friday, s.saturday, s.sunday];
    final weekdayName = dayNames[_selectedDate.weekday - 1];

    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _changeDate(
                _selectedDate.subtract(const Duration(days: 1)),
                syncDayPage: true,
                syncWeekPage: true,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.chevron_left, color: AppColors.textSecondary, size: 20),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${_selectedDate.month}/${_selectedDate.day} $weekdayName',
              style: const TextStyle(
                fontFamily: 'MiSans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _changeDate(
                _selectedDate.add(const Duration(days: 1)),
                syncDayPage: true,
                syncWeekPage: true,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekView() {
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
          if (_isSyncingWeekPage) return;
          final newOffset = page - 5200;
          final weekStart = _getWeekStart(now, newOffset);
          final weekday = _selectedDate.weekday;
          final targetDate = weekStart.add(Duration(days: weekday - 1));
          setState(() {
            _selectedDate = targetDate;
          });
          ref
              .read(planInstanceNotifierProvider.notifier)
              .loadForDate(targetDate);
          _isSyncingDayPage = true;
          final dayOffset = targetDate.difference(now).inDays;
          final targetDayPage = _dayPageCenter + dayOffset;
          if (_dayPageController.hasClients) {
            _dayPageController.jumpToPage(targetDayPage);
          }
          _isSyncingDayPage = false;
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
                  onTap: () => _changeDate(date, syncDayPage: true),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
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
                            fontWeight: isSelected || isToday
                                ? FontWeight.w700
                                : FontWeight.w400,
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

  Widget _buildMonthView() {
    final now = DateTime.now();
    final s = S.of(context)!;
    final dayNames = [s.mon, s.tue, s.wed, s.thu, s.fri, s.sat, s.sun];

    final year = _selectedDate.year;
    final month = _selectedDate.month;
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startWeekday = firstDayOfMonth.weekday;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  final prevMonth = DateTime(year, month - 1, 1);
                  _changeDate(
                    DateTime(prevMonth.year, prevMonth.month,
                        _selectedDate.day.clamp(1, DateTime(prevMonth.year, prevMonth.month + 1, 0).day)),
                    syncDayPage: true,
                    syncWeekPage: true,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.chevron_left, color: AppColors.textSecondary, size: 20),
                ),
              ),
              Text(
                '${_selectedDate.year}/${_selectedDate.month}',
                style: const TextStyle(
                  fontFamily: 'MiSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  final nextMonth = DateTime(year, month + 1, 1);
                  _changeDate(
                    DateTime(nextMonth.year, nextMonth.month,
                        _selectedDate.day.clamp(1, DateTime(nextMonth.year, nextMonth.month + 1, 0).day)),
                    syncDayPage: true,
                    syncWeekPage: true,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: dayNames.map((name) => Expanded(
              child: Center(
                child: Text(
                  name,
                  style: TextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 4),
          ...List.generate(6, (weekIndex) {
            return Row(
              children: List.generate(7, (dayIndex) {
                final cellIndex = weekIndex * 7 + dayIndex;
                final dayNumber = cellIndex - (startWeekday - 1) + 1;
                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 32));
                }
                final date = DateTime(year, month, dayNumber);
                final isSelected = _isSameDay(date, _selectedDate);
                final isToday = _isSameDay(date, now);

                return Expanded(
                  child: GestureDetector(
                    onTap: () => _changeDate(date, syncDayPage: true, syncWeekPage: true),
                    child: Container(
                      height: 32,
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : isToday
                                ? AppColors.primary.withValues(alpha: 0.12)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '$dayNumber',
                          style: TextStyle(
                            fontFamily: 'MiSans',
                            fontSize: 12,
                            fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.w400,
                            color: isSelected
                                ? AppColors.backgroundDeep
                                : isToday
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
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

        final allDayInstances = <PlanInstance>[];
        final timedInstances = <PlanInstance>[];
        for (final instance in instances) {
          final template = templateMap[instance.planTemplateId];
          if (template == null) continue;
          if (template.enableTimeSlot) {
            timedInstances.add(instance);
          } else {
            allDayInstances.add(instance);
          }
        }

        final totalHeight = (_endHour - _startHour) * _hourHeight;

        return Column(
              children: [
                if (allDayInstances.isNotEmpty)
                  _buildAllDaySection(allDayInstances, templateMap),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      top: _scrollPaddingTop,
                      bottom: _scrollPaddingBottom,
                    ),
                    child: SizedBox(
                      height: totalHeight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTimeLabels(totalHeight),
                          Expanded(
                            child: _buildPlanGrid(
                                timedInstances, templateMap, totalHeight),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
      },
      loading: () => const Center(
          child: CircularProgressIndicator(
              color: AppColors.primary, strokeWidth: 2)),
      error: (e, _) => Center(
          child: Text(S.of(context)!.loadFailed(e.toString()),
              style: TextStyles.body2.copyWith(color: AppColors.error))),
    );
  }

  Widget _buildAllDaySection(
    List<PlanInstance> allDayInstances,
    Map<String, PlanTemplate> templateMap,
  ) {
    final s = S.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.allDayEvents,
            style: TextStyles.caption.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: allDayInstances.map((instance) {
              final template = templateMap[instance.planTemplateId];
              if (template == null) return const SizedBox.shrink();
              final color = Color(template.colorValue);
              return GestureDetector(
                onTap: () => _showInstanceDetail(instance, template),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: instance.isCompleted ? AppColors.success : Colors.transparent,
                          border: Border.all(
                            color: instance.isCompleted ? AppColors.success : color,
                            width: 1,
                          ),
                        ),
                        child: instance.isCompleted
                            ? const Icon(Icons.check, size: 7, color: AppColors.backgroundDeep)
                            : null,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        template.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: color,
                          decoration: instance.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeLabels(double totalHeight) {
    final interval = _currentInterval;
    final totalMinutes = (_endHour - _startHour) * 60;
    final labelCount = totalMinutes ~/ interval;

    return SizedBox(
      width: _timeLabelWidth,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: List.generate(labelCount + 1, (index) {
          final minutes = index * interval;
          final hour = _startHour + minutes ~/ 60;
          final minute = minutes % 60;
          if (hour > _endHour) return const SizedBox.shrink();
          final top = (minutes / 60.0) * _hourHeight - 6;
          return Positioned(
            top: top,
            left: 0,
            right: 0,
            child: Text(
              '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
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

            final startOffset =
                _getTimeOffset(template.startHour, template.startMinute);
            final endOffset =
                _getTimeOffset(template.endHour, template.endMinute);
            final cardHeight =
                (endOffset - startOffset).clamp(40.0, totalHeight);

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
                  if (startPeriod < 1 ||
                      startPeriod > TimeSlotConstants.periodTimeSlots.length) {
                    return const SizedBox.shrink();
                  }
                  final effectiveEnd =
                      endPeriod.clamp(1, TimeSlotConstants.periodTimeSlots.length);
                  final startTime = TimeSlotConstants.periodTimeSlots[startPeriod - 1];
                  final endTime = TimeSlotConstants.periodTimeSlots[effectiveEnd - 1];

                  final startOffset = _getTimeOffset(
                      startTime['startHour']!, startTime['startMinute']!);
                  final endOffset = _getTimeOffset(
                      endTime['endHour']!, endTime['endMinute']!);
                  final cardHeight =
                      (endOffset - startOffset).clamp(40.0, totalHeight);

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
    final interval = _currentInterval;
    final totalMinutes = (_endHour - _startHour) * 60;
    final lineCount = totalMinutes ~/ interval;
    final lineSpacing = (interval / 60.0) * _hourHeight;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        children: List.generate(lineCount + 1, (index) {
          final minutes = index * interval;
          final isHourLine = minutes % 60 == 0;
          return Positioned(
            top: index * lineSpacing,
            left: 0,
            right: 0,
            child: Container(
              height: 0.5,
              color: AppColors.border.withValues(
                alpha: isHourLine ? 0.4 : 0.2,
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
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
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
                      child: const Icon(Icons.edit_outlined,
                          size: 16, color: AppColors.primary),
                    ),
                  ),
                  _buildCompletionToggle(instance),
                ],
              ),
              const SizedBox(height: 16),
              if (template.enableTimeSlot)
                _buildDetailRow(s.time,
                    '${template.startHour.toString().padLeft(2, '0')}:${template.startMinute.toString().padLeft(2, '0')} - ${template.endHour.toString().padLeft(2, '0')}:${template.endMinute.toString().padLeft(2, '0')}')
              else
                _buildDetailRow(s.time, s.allDayEvents),
              if (instance.targetAmount > 0) ...[
                _buildDetailRow(s.progress,
                    '${instance.completedAmount}/${instance.targetAmount} ${template.unit ?? ''}'),
                const SizedBox(height: 12),
                _buildDetailProgressBar(progress),
                const SizedBox(height: 12),
                _buildAmountInput(instance),
              ],
              if (template.description != null &&
                  template.description!.isNotEmpty) ...[
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
        ref
            .read(planInstanceNotifierProvider.notifier)
            .toggleComplete(instance.id);
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
            child: Text(label,
                style:
                    TextStyles.body2.copyWith(color: AppColors.textTertiary)),
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
            Container(
                decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(4))),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: progress >= 1.0
                      ? const LinearGradient(
                          colors: [AppColors.success, AppColors.successLight])
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
    final controller =
        TextEditingController(text: instance.completedAmount.toString());
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
              isDense: true,
            ),
            onSubmitted: (value) {
              final amount = int.tryParse(value) ?? 0;
              ref
                  .read(planInstanceNotifierProvider.notifier)
                  .updateCompletedAmount(instance.id, amount);
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
    final startTime = TimeSlotConstants.periodTimeSlots[course.startPeriod - 1];
    final endTime = TimeSlotConstants.periodTimeSlots[
        course.endPeriod.clamp(1, TimeSlotConstants.periodTimeSlots.length) - 1];

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
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
                _buildDetailRow(
                    S.of(context)!.teacherName, course.teacherName!),
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
                    color: instance.isCompleted
                        ? AppColors.success
                        : Colors.transparent,
                    border: Border.all(
                      color: instance.isCompleted ? AppColors.success : color,
                      width: 1.2,
                    ),
                  ),
                  child: instance.isCompleted
                      ? const Icon(Icons.check,
                          size: 8, color: AppColors.backgroundDeep)
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
