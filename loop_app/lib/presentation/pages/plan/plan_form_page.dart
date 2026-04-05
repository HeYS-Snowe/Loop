import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loop_app/core/theme/colors.dart';
import 'package:loop_app/core/theme/text_styles.dart';
import 'package:loop_app/data/database/app_database.dart';
import 'package:loop_app/l10n/generated/app_localizations.dart';
import 'package:loop_app/presentation/providers/plan_provider.dart';
import 'package:loop_app/presentation/widgets/common/gradient_decorations.dart';
import 'package:loop_app/presentation/widgets/common/loop_time_picker.dart';
import 'package:loop_app/shared/extensions/date_extensions.dart';

class PlanFormPage extends ConsumerStatefulWidget {
  final PlanTemplate? template;

  const PlanFormPage({super.key, this.template});

  @override
  ConsumerState<PlanFormPage> createState() => _PlanFormPageState();
}

class _PlanFormPageState extends ConsumerState<PlanFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _unitController = TextEditingController();
  final _intervalController = TextEditingController();

  late DateTime _startDate;
  DateTime? _endDate;
  late bool _enableQuantityTracking;
  late String _repeatType;
  late Set<int> _selectedDays;
  bool _isSubmitting = false;

  late int _startHour;
  late int _startMinute;
  late int _endHour;
  late int _endMinute;
  late int _selectedColorValue;

  bool get _isEditMode => widget.template != null;

  static const List<int> _presetColors = [
    0xFF2196F3,
    0xFFE91E63,
    0xFF4CAF50,
    0xFF9C27B0,
    0xFFFF9800,
    0xFF00BCD4,
    0xFFF44336,
    0xFF3F51B5,
    0xFF8BC34A,
    0xFFFF5722,
    0xFF607D8B,
    0xFF795548,
  ];

  static const List<String> _repeatOptionKeys = [
    'none',
    'daily',
    'weekly',
    'monthly',
    'interval',
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final t = widget.template!;
      _nameController.text = t.name;
      _descController.text = t.description ?? '';
      _targetAmountController.text = t.dailyTargetAmount > 0 ? t.dailyTargetAmount.toString() : '';
      _unitController.text = t.unit ?? '';
      _intervalController.text = t.repeatInterval > 1 ? t.repeatInterval.toString() : '1';
      _startDate = t.startDate;
      _endDate = t.endDate;
      _enableQuantityTracking = t.enableQuantityTracking;
      _repeatType = t.repeatType;
      _selectedDays = t.activeDays
          .split(',')
          .map((s) => int.tryParse(s.trim()) ?? 0)
          .where((d) => d >= 1 && d <= 7)
          .toSet();
      _startHour = t.startHour;
      _startMinute = t.startMinute;
      _endHour = t.endHour;
      _endMinute = t.endMinute;
      _selectedColorValue = t.colorValue;
    } else {
      _startDate = DateTime.now();
      _endDate = null;
      _enableQuantityTracking = true;
      _repeatType = 'daily';
      _selectedDays = {1, 2, 3, 4, 5};
      _intervalController.text = '1';
      _startHour = 8;
      _startMinute = 0;
      _endHour = 9;
      _endMinute = 0;
      _selectedColorValue = 0xFF2196F3;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _targetAmountController.dispose();
    _unitController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  List<String> _getDayLabels(S s) => [s.mon, s.tue, s.wed, s.thu, s.fri, s.sat, s.sun];

  String _getRepeatLabel(S s, String key) {
    switch (key) {
      case 'none': return s.noRepeat;
      case 'daily': return s.repeatDaily;
      case 'weekly': return s.repeatWeekly;
      case 'monthly': return s.repeatMonthly;
      case 'interval': return s.repeatInterval;
      default: return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(
        title: Text(_isEditMode ? s.editPlan : s.createPlan, style: TextStyles.heading4),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
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
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              children: [
                _buildSectionCard(
                  title: s.basicInfo,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: s.planName,
                        hint: s.planNameHint,
                        required: true,
                        maxLength: 50,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _descController,
                        label: s.descriptionOptional,
                        hint: s.descriptionHint,
                        maxLines: 2,
                        maxLength: 200,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: s.quantityTarget,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _targetAmountController,
                              label: s.dailyTarget,
                              hint: '0',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 100,
                            child: _buildTextField(
                              controller: _unitController,
                              label: s.unit,
                              hint: s.unitHint,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildSwitchRow(
                        label: s.enableQuantityValidation,
                        subtitle: s.enableQuantityValidationDesc,
                        value: _enableQuantityTracking,
                        onChanged: (v) => setState(() => _enableQuantityTracking = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: s.timeSlot,
                  subtitle: s.timeSlotDesc,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTimePickerTile(
                          label: s.startTime,
                          hour: _startHour,
                          minute: _startMinute,
                          onTap: () => _pickTime(isStart: true),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.primary.withValues(alpha: 0.3),
                                    AppColors.accent.withValues(alpha: 0.3),
                                  ],
                                ),
                                border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.2),
                                  width: 0.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _buildDurationText(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textTertiary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _buildTimePickerTile(
                          label: s.endTime,
                          hour: _endHour,
                          minute: _endMinute,
                          onTap: () => _pickTime(isStart: false),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: s.cardColor,
                  subtitle: s.cardColorDesc,
                  child: _buildColorPicker(),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: s.repeatRule,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _repeatOptionKeys.map((key) {
                          final isSelected = _repeatType == key;
                          return GestureDetector(
                            onTap: () => _onRepeatTypeChanged(key),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                  width: isSelected ? 1.5 : 0.5,
                                ),
                              ),
                              child: Text(
                                _getRepeatLabel(s, key),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      if (_repeatType == 'interval') ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(s.every, style: TextStyles.body2),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 60,
                              child: TextFormField(
                                controller: _intervalController,
                                keyboardType: TextInputType.number,
                                style: TextStyles.body1,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.surfaceLight,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(s.repeatEveryDay, style: TextStyles.body2),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: s.activeDate,
                  subtitle: _repeatType == 'daily' ? s.executeDaily : s.selectWeekdays,
                  child: _repeatType == 'daily'
                      ? const SizedBox.shrink()
                      : Column(
                          children: [
                            Row(
                              children: List.generate(7, (index) {
                                final day = index + 1;
                                final isSelected = _selectedDays.contains(day);
                                final dayLabels = _getDayLabels(s);
                                return Expanded(
                                  child: GestureDetector(
                                  onTap: () => _toggleDay(day),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                                      border: Border.all(
                                        color: isSelected ? AppColors.primary : AppColors.border,
                                        width: isSelected ? 1.5 : 0.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        dayLabels[index],
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                          color: isSelected ? AppColors.backgroundDeep : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildQuickDayChip(s.weekday, {1, 2, 3, 4, 5}),
                                const SizedBox(width: 8),
                                _buildQuickDayChip(s.everyday, {1, 2, 3, 4, 5, 6, 7}),
                                const SizedBox(width: 8),
                                _buildQuickDayChip(s.weekend, {6, 7}),
                              ],
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: s.timeRange,
                  child: Column(
                    children: [
                      _buildDateRow(
                        label: s.startDate,
                        date: _startDate,
                        onTap: () => _pickDate(isStart: true),
                      ),
                      const SizedBox(height: 12),
                      _buildDateRow(
                        label: s.endDate,
                        date: _endDate,
                        onTap: () => _pickDate(isStart: false),
                        trailing: TextButton(
                          onPressed: () => setState(() => _endDate = null),
                          child: Text(s.unlimited, style: const TextStyle(color: AppColors.primary, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildSubmitButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, String? subtitle, required Widget child}) {
    return GradientContainer(
      style: GradientStyle.edgeShine,
      padding: const EdgeInsets.all(20),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyles.heading4),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyles.body2),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool required = false,
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyles.label,
            children: required
                ? [const TextSpan(text: ' *', style: TextStyle(color: AppColors.error))]
                : null,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          style: TextStyles.body1,
          validator: required
              ? (v) {
                  if (v == null || v.trim().isEmpty) return S.of(context)!.pleaseEnter(label);
                  return null;
                }
              : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyles.body2.copyWith(color: AppColors.textTertiary),
            filled: true,
            fillColor: AppColors.surfaceLight,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 1),
            ),
            counterStyle: TextStyles.caption,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchRow({
    required String label,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyles.body1),
              if (subtitle != null) Text(subtitle, style: TextStyles.caption),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
          activeTrackColor: AppColors.primaryMuted,
        ),
      ],
    );
  }

  Widget _buildDateRow({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    final s = S.of(context)!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(label, style: TextStyles.body2),
            const Spacer(),
            Text(
              date != null ? date.format() : s.unlimited,
              style: TextStyles.body1.copyWith(color: date != null ? AppColors.primary : AppColors.textTertiary),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.calendar_today, size: 16, color: AppColors.textTertiary),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerTile({
    required String label,
    required int hour,
    required int minute,
    required VoidCallback onTap,
  }) {
    final s = S.of(context)!;
    final isStart = label == s.startTime;
    final gradientColors = isStart
        ? [AppColors.primary.withValues(alpha: 0.15), AppColors.accent.withValues(alpha: 0.08)]
        : [AppColors.warmAccent.withValues(alpha: 0.15), AppColors.gold.withValues(alpha: 0.08)];
    final accentColor = isStart ? AppColors.primary : AppColors.warmAccent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.25),
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isStart ? Icons.play_arrow_rounded : Icons.stop_rounded,
                  size: 14,
                  color: accentColor,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyles.caption.copyWith(color: accentColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: 1.0,
                height: 1.0,
                fontFamily: 'MiSans',
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                s.tapToEdit,
                style: TextStyle(
                  fontSize: 10,
                  color: accentColor.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _presetColors.map((colorValue) {
        final isSelected = _selectedColorValue == colorValue;
        final color = Color(colorValue);
        return GestureDetector(
          onTap: () => setState(() => _selectedColorValue = colorValue),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? color : color.withValues(alpha: 0.3),
                width: isSelected ? 3 : 1,
              ),
            ),
            child: isSelected
                ? Icon(Icons.check, size: 20, color: color)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Future<void> _pickTime({required bool isStart}) async {
    final s = S.of(context)!;
    final initialTime = TimeOfDay(
      hour: isStart ? _startHour : _endHour,
      minute: isStart ? _startMinute : _endMinute,
    );

    final picked = await LoopTimePicker.show(
      context,
      initialTime: initialTime,
      title: isStart ? s.selectStartTime : s.selectEndTime,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startHour = picked.hour;
          _startMinute = picked.minute;
        } else {
          _endHour = picked.hour;
          _endMinute = picked.minute;
        }
      });
    }
  }

  String _buildDurationText() {
    final startMinutes = _startHour * 60 + _startMinute;
    final endMinutes = _endHour * 60 + _endMinute;
    final diff = endMinutes - startMinutes;
    if (diff <= 0) return '';
    final hours = diff ~/ 60;
    final minutes = diff % 60;
    if (hours > 0 && minutes > 0) return '${hours}h${minutes}m';
    if (hours > 0) return '${hours}h';
    return '${minutes}m';
  }

  Widget _buildQuickDayChip(String label, Set<int> days) {
    final isActive = _selectedDays.length == days.length && _selectedDays.containsAll(days);
    return GestureDetector(
      onTap: () => setState(() => _selectedDays = Set.from(days)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
            width: isActive ? 1 : 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final s = S.of(context)!;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.backgroundDeep,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.backgroundDeep,
                ),
              )
            : Text(_isEditMode ? s.saveChanges : s.createPlan, style: TextStyles.button),
      ),
    );
  }

  void _onRepeatTypeChanged(String type) {
    setState(() {
      _repeatType = type;
      if (type == 'daily') {
        _selectedDays = {1, 2, 3, 4, 5, 6, 7};
      }
    });
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : (_endDate ?? _startDate.add(const Duration(days: 30))),
      firstDate: isStart ? DateTime.now().subtract(const Duration(days: 365)) : _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.backgroundDeep,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    final s = S.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDays.isEmpty && _repeatType != 'daily') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.pleaseSelectActiveDate)),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final sortedDays = _selectedDays.toList()..sort();
      final activeDays = _repeatType == 'daily'
          ? '1,2,3,4,5,6,7'
          : sortedDays.join(',');

      final repeatInterval = _repeatType == 'interval'
          ? int.tryParse(_intervalController.text) ?? 1
          : 1;

      final dailyTargetAmount = int.tryParse(_targetAmountController.text) ?? 0;

      if (_isEditMode) {
        final t = widget.template!;
        await ref.read(planTemplateNotifierProvider.notifier).updateTemplate(
              PlanTemplate(
                id: t.id,
                name: _nameController.text.trim(),
                description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
                categoryId: t.categoryId,
                dailyTargetAmount: dailyTargetAmount,
                unit: _unitController.text.trim().isEmpty ? null : _unitController.text.trim(),
                enableQuantityTracking: _enableQuantityTracking,
                repeatType: _repeatType,
                repeatInterval: repeatInterval,
                activeDays: activeDays,
                startHour: _startHour,
                startMinute: _startMinute,
                endHour: _endHour,
                endMinute: _endMinute,
                colorValue: _selectedColorValue,
                startDate: _startDate,
                endDate: _endDate,
                isActive: true,
                sortOrder: t.sortOrder,
                createdAt: t.createdAt,
                updatedAt: DateTime.now(),
              ),
            );
      } else {
        await ref.read(planTemplateNotifierProvider.notifier).createTemplate(
              name: _nameController.text.trim(),
              description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
              dailyTargetAmount: dailyTargetAmount,
              unit: _unitController.text.trim().isEmpty ? null : _unitController.text.trim(),
              enableQuantityTracking: _enableQuantityTracking,
              repeatType: _repeatType,
              repeatInterval: repeatInterval,
              activeDays: activeDays,
              startHour: _startHour,
              startMinute: _startMinute,
              endHour: _endHour,
              endMinute: _endMinute,
              colorValue: _selectedColorValue,
              startDate: _startDate,
              endDate: _endDate,
            );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditMode ? s.planUpdated : s.planCreated)),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.operationFailed(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
