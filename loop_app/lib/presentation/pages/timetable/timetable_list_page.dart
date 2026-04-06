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

class TimetableListPage extends ConsumerWidget {
  const TimetableListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetablesAsync = ref.watch(allTimetablesProvider);
    final s = S.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(s.timetableManagement, style: TextStyles.heading3),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.primary),
            onPressed: () => _showCreateOptions(context),
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
            child: SafeArea(
              child: timetablesAsync.when(
                data: (timetables) {
                  if (timetables.isEmpty) {
                    return _buildEmptyState(context, s);
                  }
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                    children: [
                      AnimatedPageWrapper(
                        index: 0,
                        child: _buildImportBanner(context, s),
                      ),
                      const SizedBox(height: 16),
                      ...timetables.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AnimatedPageWrapper(
                            index: entry.key + 1,
                            child: _buildTimetableCard(
                              context,
                              ref,
                              s,
                              entry.value,
                            ),
                          ),
                        );
                      }),
                    ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateOptions(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: AppColors.backgroundDeep),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, S s) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
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
                Icons.schedule_rounded,
                size: 36,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(s.noTimetable, style: TextStyles.heading4),
            const SizedBox(height: 8),
            Text(
              s.importFromHtmlDesc,
              style: TextStyles.body2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => context.push(RouteConstants.timetableImport),
                icon: const Icon(Icons.upload_file_rounded, size: 18),
                label: Text(s.importFromHtml),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.backgroundDeep,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportBanner(BuildContext context, S s) {
    return GlassCard(
      onTap: () => context.push(RouteConstants.timetableImport),
      borderRadius: 16,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.upload_file_rounded,
              color: AppColors.accent,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.importFromHtml, style: TextStyles.body1),
                const SizedBox(height: 2),
                Text(s.importFromHtmlDesc, style: TextStyles.caption),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textTertiary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableCard(
    BuildContext context,
    WidgetRef ref,
    S s,
    Timetable timetable,
  ) {
    final sourceLabel = timetable.source == 'html'
        ? s.sourceHtml
        : s.sourceManual;
    final semesterText = s.semesterFormat(
      timetable.academicYear.toString(),
      timetable.semester,
    );

    return GlassCard(
      onTap: () => context.push(
        '${RouteConstants.timetableDetail}?id=${timetable.id}',
      ),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  timetable.name,
                  style: TextStyles.heading4,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteConfirmation(context, ref, s, timetable);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      s.delete,
                      style: TextStyles.body2.copyWith(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildInfoChip(
                Icons.school_rounded,
                semesterText,
                AppColors.accent,
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                Icons.calendar_today_rounded,
                s.weekFormat(timetable.currentWeek),
                AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildInfoChip(
                Icons.source_rounded,
                sourceLabel,
                AppColors.warmAccent,
              ),
              const SizedBox(width: 8),
              FutureBuilder<int>(
                future: ref
                    .read(timetableRepositoryProvider)
                    .getCoursesByTimetable(timetable.id)
                    .then((c) => c.length),
                builder: (context, snapshot) {
                  return _buildInfoChip(
                    Icons.menu_book_rounded,
                    s.courseCount(snapshot.data ?? 0),
                    AppColors.success,
                  );
                },
              ),
            ],
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
          Text(
            label,
            style: TextStyles.caption.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  void _showCreateOptions(BuildContext context) {
    final s = S.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.upload_file_rounded,
                    color: AppColors.accent,
                  ),
                ),
                title: Text(s.importFromHtml, style: TextStyles.body1),
                subtitle: Text(s.importFromHtmlDesc, style: TextStyles.body2),
                onTap: () {
                  Navigator.pop(context);
                  context.push(RouteConstants.timetableImport);
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.edit_calendar_rounded,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(s.createTimetable, style: TextStyles.body1),
                subtitle: Text(
                  s.timetableNameHint,
                  style: TextStyles.body2,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showCreateTimetableDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateTimetableDialog(BuildContext context) {
    final s = S.of(context)!;
    final nameController = TextEditingController();
    int selectedSemester = 2;
    int selectedAcademicYear = DateTime.now().year;
    DateTime selectedFirstWeek = DateTime.now();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: Text(s.createTimetable, style: TextStyles.heading4),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      style: TextStyles.body1,
                      decoration: InputDecoration(
                        labelText: s.timetableName,
                        hintText: s.timetableNameHint,
                        hintStyle: TextStyles.body1.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(s.academicYear, style: TextStyles.label),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setDialogState(() => selectedAcademicYear--);
                          },
                          icon: const Icon(
                            Icons.remove_rounded,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '$selectedAcademicYear-${selectedAcademicYear + 1}',
                            style: TextStyles.body1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setDialogState(() => selectedAcademicYear++);
                          },
                          icon: const Icon(
                            Icons.add_rounded,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(s.semester, style: TextStyles.label),
                    const SizedBox(height: 8),
                    Row(
                      children: [1, 2, 3].map((sem) {
                        final label = sem == 1
                            ? s.firstSemester
                            : sem == 2
                                ? s.secondSemester
                                : s.thirdSemester;
                        final isSelected = sem == selectedSemester;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setDialogState(() => selectedSemester = sem);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.15)
                                    : AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              child: Text(
                                label,
                                style: TextStyles.body2.copyWith(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(s.firstWeekMonday, style: TextStyles.label),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedFirstWeek,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          setDialogState(() => selectedFirstWeek = date);
                        }
                      },
                      child: Text(
                        '${selectedFirstWeek.year}-${selectedFirstWeek.month.toString().padLeft(2, '0')}-${selectedFirstWeek.day.toString().padLeft(2, '0')}',
                        style: TextStyles.body2,
                      ),
                    ),
                  ],
                ),
              ),
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
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(
                    s.confirm,
                    style: TextStyles.body1.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    S s,
    Timetable timetable,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(s.confirmDelete, style: TextStyles.heading4),
        content: Text(
          s.confirmDeleteTimetable,
          style: TextStyles.body1,
        ),
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
                  .read(timetableNotifierProvider.notifier)
                  .deleteTimetable(timetable.id);
              ref.invalidate(allTimetablesProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(s.timetableDeleted),
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
