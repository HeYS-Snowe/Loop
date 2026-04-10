import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loop_app/core/constants/route_constants.dart';
import 'package:loop_app/core/theme/colors.dart';
import 'package:loop_app/core/theme/text_styles.dart';
import 'package:loop_app/data/database/app_database.dart';
import 'package:loop_app/l10n/generated/app_localizations.dart';
import 'package:loop_app/presentation/providers/timetable_provider.dart';
import 'package:loop_app/presentation/widgets/common/glass_card.dart';
import 'package:loop_app/presentation/widgets/common/gradient_decorations.dart';
import 'package:loop_app/presentation/widgets/common/animated_widgets.dart';

class TimetableDetailPage extends ConsumerWidget {
  final String timetableId;

  const TimetableDetailPage({super.key, required this.timetableId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetableAsync = ref.watch(timetableDetailProvider(timetableId));
    final coursesAsync = ref.watch(coursesByTimetableProvider(timetableId));
    final s = S.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go(RouteConstants.home),
        ),
        title: Text(s.timetableDetail, style: TextStyles.heading3),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.primary),
            onPressed: () => context.push(
              '${RouteConstants.courseForm}?timetableId=$timetableId',
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: GradientDecoration(
              style: GradientStyle.diagonalHalf,
              color: AppColors.primary,
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: timetableAsync.when(
                data: (timetable) {
                  if (timetable == null) {
                    return Center(
                      child: Text(
                        s.loadFailedShort,
                        style: TextStyles.body2,
                      ),
                    );
                  }
                  return _buildContent(
                    context,
                    ref,
                    s,
                    timetable,
                    coursesAsync,
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
                error: (error, _) => Center(
                  child: Text(
                    s.loadFailed(error.toString()),
                    style: TextStyles.body2.copyWith(color: AppColors.error),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    S s,
    Timetable timetable,
    AsyncValue<List<TimetableCourse>> coursesAsync,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedPageWrapper(
            index: 0,
            child: _buildTimetableInfo(context, s, timetable),
          ),
          const SizedBox(height: 16),
          AnimatedPageWrapper(
            index: 1,
            child: _buildWeekSelector(context, ref, s, timetable),
          ),
          const SizedBox(height: 20),
          AnimatedPageWrapper(
            index: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(s.courseManagement, style: TextStyles.heading4),
                TextButton(
                  onPressed: () => context.push(
                    '${RouteConstants.courseForm}?timetableId=$timetableId',
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_rounded, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        s.addCourse,
                        style: TextStyles.label.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          AnimatedPageWrapper(
            index: 3,
            child: coursesAsync.when(
              data: (courses) => _buildCourseGrid(context, ref, s, courses),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),
              error: (error, _) => Center(
                child: Text(
                  s.loadFailed(error.toString()),
                  style: TextStyles.body2.copyWith(color: AppColors.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableInfo(BuildContext context, S s, Timetable timetable) {
    final sourceLabel = timetable.source == 'html'
        ? s.sourceHtml
        : s.sourceManual;

    return GlassCard(
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(timetable.name, style: TextStyles.heading3),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(
                Icons.school_rounded,
                s.semesterFormat(
                  timetable.academicYear.toString(),
                  timetable.semester,
                ),
                AppColors.accent,
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                Icons.calendar_today_rounded,
                s.weekFormat(timetable.currentWeek),
                AppColors.primary,
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                Icons.layers_rounded,
                s.totalWeeks,
                AppColors.gold,
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoChip(
            Icons.source_rounded,
            s.timetableSource(sourceLabel),
            AppColors.warmAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyles.caption.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildWeekSelector(
    BuildContext context,
    WidgetRef ref,
    S s,
    Timetable timetable,
  ) {
    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.currentWeek, style: TextStyles.label),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: timetable.totalWeeks,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final week = index + 1;
                final isCurrent = week == timetable.currentWeek;
                return GestureDetector(
                  onTap: () {
                    ref
                        .read(timetableNotifierProvider.notifier)
                        .updateTimetable(
                      timetable.copyWith(
                        currentWeek: week,
                        updatedAt: DateTime.now(),
                      ),
                    );
                    ref.invalidate(timetableDetailProvider(timetableId));
                  },
                  child: Container(
                    width: 36,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppColors.primary
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '$week',
                        style: TextStyles.caption.copyWith(
                          color: isCurrent
                              ? AppColors.backgroundDeep
                              : AppColors.textSecondary,
                          fontWeight: isCurrent
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseGrid(
    BuildContext context,
    WidgetRef ref,
    S s,
    List<TimetableCourse> courses,
  ) {
    if (courses.isEmpty) {
      return GlassCard(
        onTap: () => context.push(
          '${RouteConstants.courseForm}?timetableId=$timetableId',
        ),
        showCornerAccent: true,
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.2),
                    AppColors.accent.withValues(alpha: 0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 24,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(s.addCourse, style: TextStyles.body1),
          ],
        ),
      );
    }

    final weekdayNames = [
      s.monday,
      s.tuesday,
      s.wednesday,
      s.thursday,
      s.friday,
      s.saturday,
      s.sunday,
    ];

    return Column(
      children: courses.map((course) {
        final color = course.colorHex != null
            ? _parseColor(course.colorHex!)
            : AppColors.primary;
        final weekdayName = weekdayNames[course.weekday - 1];

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GlassCard(
            borderRadius: 14,
            padding: const EdgeInsets.all(14),
            onTap: () => context.push(
              '${RouteConstants.courseForm}?timetableId=$timetableId&courseId=${course.id}',
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.courseName,
                        style: TextStyles.body1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 12,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$weekdayName ${s.periodFormat(course.startPeriod, course.endPeriod)}',
                            style: TextStyles.caption,
                          ),
                        ],
                      ),
                      if (course.location != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 12,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              course.location!,
                              style: TextStyles.caption,
                            ),
                          ],
                        ),
                      ],
                      if (course.teacherName != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.person_rounded,
                              size: 12,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              course.teacherName!,
                              style: TextStyles.caption,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      course.weekRanges,
                      style: TextStyles.caption.copyWith(
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () => _showDeleteCourseConfirmation(
                        context,
                        ref,
                        s,
                        course,
                      ),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: AppColors.textTertiary.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.primary;
    }
  }

  void _showDeleteCourseConfirmation(
    BuildContext context,
    WidgetRef ref,
    S s,
    TimetableCourse course,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(s.confirmDelete, style: TextStyles.heading4),
        content: Text(s.confirmDeleteCourse, style: TextStyles.body1),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              s.cancel,
              style: TextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await ref
                  .read(timetableCourseNotifierProvider.notifier)
                  .deleteCourse(course.id, course.timetableId);
              ref.invalidate(coursesByTimetableProvider(timetableId));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(s.courseDeleted),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text(
              s.delete,
              style: TextStyles.body1.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
