import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loop_app/core/theme/colors.dart';
import 'package:loop_app/core/theme/text_styles.dart';
import 'package:loop_app/data/database/app_database.dart';
import 'package:loop_app/presentation/providers/plan_provider.dart';
import 'package:loop_app/presentation/widgets/common/gradient_decorations.dart';
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

  static const List<String> _dayLabels = ['一', '二', '三', '四', '五', '六', '日'];

  static const List<MapEntry<String, String>> _repeatOptions = [
    MapEntry('none', '不重复'),
    MapEntry('daily', '每天'),
    MapEntry('weekly', '每周'),
    MapEntry('monthly', '每月'),
    MapEntry('interval', '自定义间隔'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(
        title: Text(_isEditMode ? '编辑计划' : '创建计划', style: TextStyles.heading4),
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
                  title: '基本信息',
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: '计划名称',
                        hint: '例如: 背英语单词',
                        required: true,
                        maxLength: 50,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _descController,
                        label: '描述(可选)',
                        hint: '计划的详细说明',
                        maxLines: 2,
                        maxLength: 200,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: '数量目标',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _targetAmountController,
                              label: '每日目标',
                              hint: '0',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 100,
                            child: _buildTextField(
                              controller: _unitController,
                              label: '单位',
                              hint: '个/分钟',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildSwitchRow(
                        label: '启用数量验证',
                        subtitle: '开启后需输入完成数量',
                        value: _enableQuantityTracking,
                        onChanged: (v) => setState(() => _enableQuantityTracking = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: '时间段',
                  subtitle: '设置计划在课程表中的显示时间',
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTimePickerTile(
                              label: '开始时间',
                              hour: _startHour,
                              minute: _startMinute,
                              onTap: () => _pickTime(isStart: true),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('-', style: TextStyles.heading4),
                          ),
                          Expanded(
                            child: _buildTimePickerTile(
                              label: '结束时间',
                              hour: _endHour,
                              minute: _endMinute,
                              onTap: () => _pickTime(isStart: false),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: '卡片颜色',
                  subtitle: '选择在课程表中的显示颜色',
                  child: _buildColorPicker(),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: '重复规则',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _repeatOptions.map((option) {
                          final isSelected = _repeatType == option.key;
                          return GestureDetector(
                            onTap: () => _onRepeatTypeChanged(option.key),
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
                                option.value,
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
                            Text('每', style: TextStyles.body2),
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
                            Text('天重复一次', style: TextStyles.body2),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: '活动日期',
                  subtitle: _repeatType == 'daily' ? '每天执行' : '选择要执行计划的星期',
                  child: _repeatType == 'daily'
                      ? const SizedBox.shrink()
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(7, (index) {
                                final day = index + 1;
                                final isSelected = _selectedDays.contains(day);
                                return GestureDetector(
                                  onTap: () => _toggleDay(day),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 40,
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
                                        _dayLabels[index],
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                          color: isSelected ? AppColors.backgroundDeep : AppColors.textSecondary,
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
                                _buildQuickDayChip('工作日', {1, 2, 3, 4, 5}),
                                const SizedBox(width: 8),
                                _buildQuickDayChip('每天', {1, 2, 3, 4, 5, 6, 7}),
                                const SizedBox(width: 8),
                                _buildQuickDayChip('周末', {6, 7}),
                              ],
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: '时间范围',
                  child: Column(
                    children: [
                      _buildDateRow(
                        label: '开始日期',
                        date: _startDate,
                        onTap: () => _pickDate(isStart: true),
                      ),
                      const SizedBox(height: 12),
                      _buildDateRow(
                        label: '结束日期',
                        date: _endDate,
                        onTap: () => _pickDate(isStart: false),
                        trailing: TextButton(
                          onPressed: () => setState(() => _endDate = null),
                          child: const Text('不限', style: TextStyle(color: AppColors.primary, fontSize: 12)),
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
                  if (v == null || v.trim().isEmpty) return '请输入$label';
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
              date != null ? date.format() : '不限',
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyles.caption),
            const SizedBox(height: 4),
            Text(
              '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
              style: TextStyles.heading4.copyWith(color: AppColors.primary),
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
    final initialTime = isStart
        ? TimeOfDay(hour: _startHour, minute: _startMinute)
        : TimeOfDay(hour: _endHour, minute: _endMinute);

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.backgroundDeep,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.surface,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          child: child!,
        );
      },
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
            : Text(_isEditMode ? '保存修改' : '创建计划', style: TextStyles.button),
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
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDays.isEmpty && _repeatType != 'daily') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请至少选择一个活动日期')),
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
          SnackBar(content: Text(_isEditMode ? '计划已更新' : '计划已创建')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作失败: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
