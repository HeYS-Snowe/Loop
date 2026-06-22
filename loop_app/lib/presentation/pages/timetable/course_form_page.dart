import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loop_app/core/constants/palette_colors.dart';
import 'package:loop_app/core/theme/colors.dart';
import 'package:loop_app/core/theme/text_styles.dart';
import 'package:loop_app/data/database/app_database.dart';
import 'package:loop_app/l10n/generated/app_localizations.dart';
import 'package:loop_app/presentation/providers/timetable_provider.dart';
import 'package:loop_app/presentation/widgets/common/glass_card.dart';
import 'package:loop_app/presentation/widgets/common/gradient_decorations.dart';
import 'package:loop_app/presentation/widgets/common/animated_widgets.dart';

class CourseFormPage extends ConsumerStatefulWidget {
  final String timetableId;
  final String? courseId;

  const CourseFormPage({
    super.key,
    required this.timetableId,
    this.courseId,
  });

  @override
  ConsumerState<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends ConsumerState<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _courseNameController = TextEditingController();
  final _teacherNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _weekRangesController = TextEditingController();

  int _selectedWeekday = 1;
  int _startPeriod = 1;
  int _endPeriod = 2;
  Color _selectedColor = AppColors.primary;
  bool _isLoading = false;
  TimetableCourse? _existingCourse;

  static const List<Color> _presetColors = PaletteColors.coursePickerColors;

  @override
  void initState() {
    super.initState();
    if (widget.courseId != null) {
      _loadExistingCourse();
    }
  }

  Future<void> _loadExistingCourse() async {
    final repository = ref.read(timetableRepositoryProvider);
    final courses = await repository.getCoursesByTimetable(widget.timetableId);
    final course = courses.where((c) => c.id == widget.courseId).firstOrNull;
    if (course != null) {
      setState(() {
        _existingCourse = course;
        _courseNameController.text = course.courseName;
        _teacherNameController.text = course.teacherName ?? '';
        _locationController.text = course.location ?? '';
        _weekRangesController.text = course.weekRanges;
        _selectedWeekday = course.weekday;
        _startPeriod = course.startPeriod;
        _endPeriod = course.endPeriod;
        if (course.colorHex != null) {
          try {
            _selectedColor = Color(
              int.parse(course.colorHex!.replaceFirst('#', '0xFF')),
            );
          } catch (_) {}
        }
      });
    }
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _teacherNameController.dispose();
    _locationController.dispose();
    _weekRangesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final isEditing = widget.courseId != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          isEditing ? s.editCourse : s.addCourse,
          style: TextStyles.heading3,
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _save,
            child: Text(
              isEditing ? s.saveChanges : s.add,
              style: TextStyles.body1.copyWith(color: AppColors.primary),
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
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedPageWrapper(
                        index: 0,
                        child: _buildBasicInfoSection(s),
                      ),
                      const SizedBox(height: 20),
                      AnimatedPageWrapper(
                        index: 1,
                        child: _buildTimeSection(s),
                      ),
                      const SizedBox(height: 20),
                      AnimatedPageWrapper(
                        index: 2,
                        child: _buildColorSection(s),
                      ),
                      const SizedBox(height: 32),
                      AnimatedPageWrapper(
                        index: 3,
                        child: _buildSaveButton(s, isEditing),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection(S s) {
    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.basicInfo, style: TextStyles.heading4),
          const SizedBox(height: 16),
          TextFormField(
            controller: _courseNameController,
            style: TextStyles.body1,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return s.courseNameRequired;
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: s.courseName,
              hintText: s.courseNameHint,
              hintStyle: TextStyles.body1.copyWith(color: AppColors.textHint),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _teacherNameController,
            style: TextStyles.body1,
            decoration: InputDecoration(
              labelText: s.teacherName,
              hintText: s.teacherNameHint,
              hintStyle: TextStyles.body1.copyWith(color: AppColors.textHint),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _locationController,
            style: TextStyles.body1,
            decoration: InputDecoration(
              labelText: s.location,
              hintText: s.locationHint,
              hintStyle: TextStyles.body1.copyWith(color: AppColors.textHint),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSection(S s) {
    final weekdayLabels = [
      s.monday,
      s.tuesday,
      s.wednesday,
      s.thursday,
      s.friday,
      s.saturday,
      s.sunday,
    ];

    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.time, style: TextStyles.heading4),
          const SizedBox(height: 16),
          Text(s.weekday, style: TextStyles.label),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(7, (index) {
              final weekday = index + 1;
              final isSelected = weekday == _selectedWeekday;
              return GestureDetector(
                onTap: () => setState(() => _selectedWeekday = weekday),
                child: Container(
                  width: 44,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      weekdayLabels[index],
                      style: TextStyles.caption.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Text(s.periodRange, style: TextStyles.label),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildPeriodSelector(
                  label: s.startPeriod,
                  value: _startPeriod,
                  onChanged: (v) => setState(() {
                    _startPeriod = v;
                    if (_endPeriod < _startPeriod) {
                      _endPeriod = _startPeriod;
                    }
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('-', style: TextStyles.body1),
              ),
              Expanded(
                child: _buildPeriodSelector(
                  label: s.endPeriod,
                  value: _endPeriod,
                  onChanged: (v) => setState(() {
                    _endPeriod = v;
                    if (_startPeriod > _endPeriod) {
                      _startPeriod = _endPeriod;
                    }
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _weekRangesController,
            style: TextStyles.body1,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return s.weekRangesRequired;
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: s.weekRanges,
              hintText: s.weekRangesHint,
              hintStyle: TextStyles.body1.copyWith(color: AppColors.textHint),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyles.caption),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              dropdownColor: AppColors.surface,
              style: TextStyles.body1,
              items: List.generate(
                12,
                (i) => DropdownMenuItem(
                  value: i + 1,
                  child: Text('${i + 1}'),
                ),
              ),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorSection(S s) {
    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.courseColor, style: TextStyles.heading4),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _presetColors.map((color) {
              final isSelected = color == _selectedColor;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = color),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(
                            color: AppColors.textPrimary,
                            width: 2.5,
                          )
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: AppColors.backgroundDeep,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(S s, bool isEditing) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _save,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.backgroundDeep,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppColors.backgroundDeep,
                  strokeWidth: 2,
                ),
              )
            : Text(
                isEditing ? s.saveChanges : s.add,
                style: TextStyles.button,
              ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final colorHex = '#${_selectedColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

      if (widget.courseId != null && _existingCourse != null) {
        final updated = _existingCourse!.copyWith(
          courseName: _courseNameController.text.trim(),
          teacherName: Value(_teacherNameController.text.trim().isEmpty
              ? null
              : _teacherNameController.text.trim()),
          location: Value(_locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim()),
          weekday: _selectedWeekday,
          startPeriod: _startPeriod,
          endPeriod: _endPeriod,
          weekRanges: _weekRangesController.text.trim(),
          colorHex: Value(colorHex),
          updatedAt: DateTime.now(),
        );
        await ref.read(timetableRepositoryProvider).updateCourse(updated);
      } else {
        await ref
            .read(timetableCourseNotifierProvider.notifier)
            .createCourse(
              timetableId: widget.timetableId,
              courseName: _courseNameController.text.trim(),
              teacherName: _teacherNameController.text.trim().isEmpty
                  ? null
                  : _teacherNameController.text.trim(),
              location: _locationController.text.trim().isEmpty
                  ? null
                  : _locationController.text.trim(),
              weekday: _selectedWeekday,
              startPeriod: _startPeriod,
              endPeriod: _endPeriod,
              weekRanges: _weekRangesController.text.trim(),
              colorHex: colorHex,
            );
      }

      ref.invalidate(coursesByTimetableProvider(widget.timetableId));

      if (mounted) {
        final s = S.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.courseId != null ? s.courseUpdated : s.courseCreated,
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        final s = S.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(s.operationFailed(e.toString())),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
