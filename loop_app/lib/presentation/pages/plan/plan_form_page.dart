import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loop/core/theme/colors.dart';
import 'package:loop/core/theme/text_styles.dart';
import 'package:loop/data/database/app_database.dart';
import 'package:loop/presentation/providers/plan_provider.dart';
import 'package:loop/presentation/providers/cycle_provider.dart';
import 'package:loop/presentation/widgets/common/animated_widgets.dart';
import 'package:loop/presentation/widgets/common/glass_card.dart';
import 'package:loop/presentation/widgets/common/gradient_decorations.dart';

final planFormProvider =
    StateNotifierProvider<PlanFormNotifier, PlanFormState>(
  (ref) => PlanFormNotifier(),
);

class PlanFormState {
  final String name;
  final String description;
  final String cycleId;
  final int targetAmount;
  final String unit;
  final int selectedColorIndex;
  final String categoryId;
  final bool isRepeatable;
  final String repeatType;

  PlanFormState({
    this.name = '',
    this.description = '',
    this.cycleId = '',
    this.targetAmount = 0,
    this.unit = '',
    this.selectedColorIndex = 0,
    this.categoryId = '',
    this.isRepeatable = false,
    this.repeatType = 'none',
  });

  PlanFormState copyWith({
    String? name,
    String? description,
    String? cycleId,
    int? targetAmount,
    String? unit,
    int? selectedColorIndex,
    String? categoryId,
    bool? isRepeatable,
    String? repeatType,
  }) {
    return PlanFormState(
      name: name ?? this.name,
      description: description ?? this.description,
      cycleId: cycleId ?? this.cycleId,
      targetAmount: targetAmount ?? this.targetAmount,
      unit: unit ?? this.unit,
      selectedColorIndex: selectedColorIndex ?? this.selectedColorIndex,
      categoryId: categoryId ?? this.categoryId,
      isRepeatable: isRepeatable ?? this.isRepeatable,
      repeatType: repeatType ?? this.repeatType,
    );
  }
}

class PlanFormNotifier extends StateNotifier<PlanFormState> {
  PlanFormNotifier() : super(PlanFormState());

  void initFromTemplate(PlanTemplate template) {
    state = PlanFormState(
      name: template.name,
      description: template.description ?? '',
      cycleId: '',
      targetAmount: template.dailyTargetAmount,
      unit: template.unit ?? '',
      selectedColorIndex: AppColors.cardColors
          .indexWhere((c) => c.value == template.colorValue)
          .clamp(0, AppColors.cardColors.length - 1),
      categoryId: template.categoryId ?? '',
      isRepeatable: template.repeatType != 'none',
      repeatType: template.repeatType,
    );
  }

  void updateName(String value) =>
      state = state.copyWith(name: value);
  void updateDescription(String value) =>
      state = state.copyWith(description: value);
  void updateCycleId(String value) =>
      state = state.copyWith(cycleId: value);
  void updateTargetAmount(int value) =>
      state = state.copyWith(targetAmount: value);
  void updateUnit(String value) =>
      state = state.copyWith(unit: value);
  void updateColorIndex(int value) =>
      state = state.copyWith(selectedColorIndex: value);
  void updateCategoryId(String value) =>
      state = state.copyWith(categoryId: value);
  void updateIsRepeatable(bool value) =>
      state = state.copyWith(isRepeatable: value);
  void updateRepeatType(String value) =>
      state = state.copyWith(repeatType: value);
}

class PlanFormPage extends ConsumerStatefulWidget {
  final PlanTemplate? template;

  const PlanFormPage({super.key, this.template});

  @override
  ConsumerState<PlanFormPage> createState() => _PlanFormPageState();
}

class _PlanFormPageState extends ConsumerState<PlanFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _unitController = TextEditingController();

  bool get isEditing => widget.template != null;

  @override
  void initState() {
    super.initState();
    if (widget.template != null) {
      _nameController.text = widget.template!.name;
      _targetAmountController.text =
          widget.template!.dailyTargetAmount.toString();
      _unitController.text = widget.template!.unit ?? '';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(planFormProvider.notifier)
            .initFromTemplate(widget.template!);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetAmountController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(planFormProvider);
    final cyclesAsync = ref.watch(allCyclesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEditing ? '编辑计划' : '创建计划',
          style: TextStyles.heading3,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          TextButton(
            onPressed: _savePlan,
            child: Text(
              '保存',
              style: TextStyles.buttonSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInWidget(
                child: _buildBasicInfoSection(formState, cyclesAsync),
              ),
              const SizedBox(height: 20),
              FadeInWidget(
                duration: const Duration(milliseconds: 500),
                child: _buildTargetSection(formState),
              ),
              const SizedBox(height: 20),
              FadeInWidget(
                duration: const Duration(milliseconds: 600),
                child: _buildColorSection(formState),
              ),
              const SizedBox(height: 20),
              FadeInWidget(
                duration: const Duration(milliseconds: 700),
                child: _buildRepeatSection(formState),
              ),
              const SizedBox(height: 32),
              FadeInWidget(
                duration: const Duration(milliseconds: 800),
                child: _buildSaveButton(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(
      PlanFormState formState, AsyncValue<List<Cycle>> cyclesAsync) {
    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel('基本信息', AppColors.primary),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _nameController,
            label: '计划名称',
            hint: '例如: 背英语单词',
            required: true,
            maxLength: 50,
            onChanged: (v) =>
                ref.read(planFormProvider.notifier).updateName(v),
          ),
          const SizedBox(height: 16),
          _buildCycleDropdown(formState, cyclesAsync),
        ],
      ),
    );
  }

  Widget _buildTargetSection(PlanFormState formState) {
    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel('目标设置', AppColors.accent),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _targetAmountController,
                  label: '目标量',
                  hint: '0',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) {
                    final amount = int.tryParse(v) ?? 0;
                    ref
                        .read(planFormProvider.notifier)
                        .updateTargetAmount(amount);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _unitController,
                  label: '单位',
                  hint: '个/分钟',
                  onChanged: (v) =>
                      ref.read(planFormProvider.notifier).updateUnit(v),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorSection(PlanFormState formState) {
    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel('卡片颜色', AppColors.info),
          const SizedBox(height: 16),
          _buildColorSelector(formState.selectedColorIndex),
        ],
      ),
    );
  }

  Widget _buildRepeatSection(PlanFormState formState) {
    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel('重复设置', AppColors.success),
          const SizedBox(height: 16),
          _buildRepeatToggle(formState.isRepeatable),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text, Color indicatorColor) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: indicatorColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: TextStyles.heading5),
      ],
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
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: TextStyles.body1,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        hintStyle: TextStyles.body2.copyWith(color: AppColors.textHint),
        labelStyle: TextStyles.labelSmall,
        floatingLabelStyle:
            TextStyles.labelSmall.copyWith(color: AppColors.primary),
        counterText: '',
        filled: true,
        fillColor: AppColors.surfaceLight.withOpacity(0.4),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error),
        ),
      ),
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return '请输入$label';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildCycleDropdown(
      PlanFormState formState, AsyncValue<List<Cycle>> cyclesAsync) {
    return cyclesAsync.when(
      data: (cycles) {
        if (cycles.isEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              '暂无可用周期，请先创建周期',
              style: TextStyles.body2.copyWith(color: AppColors.textTertiary),
            ),
          );
        }

        final selectedId = formState.cycleId.isEmpty
            ? cycles.first.id
            : formState.cycleId;
        final selectedCycle = cycles.where((c) => c.id == selectedId).firstOrNull;

        return GestureDetector(
          onTap: () => _showCyclePicker(cycles, selectedId),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('选择周期', style: TextStyles.labelSmall),
                      const SizedBox(height: 4),
                      Text(
                        selectedCycle?.name ?? '请选择周期',
                        style: TextStyles.body1,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.expand_more,
                  size: 20,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox(
        height: 48,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppColors.primary),
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  void _showCyclePicker(List<Cycle> cycles, String selectedId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('选择周期', style: TextStyles.heading4),
              ),
              const SizedBox(height: 12),
              ...cycles.map((cycle) {
                final isSelected = cycle.id == selectedId;
                return ListTile(
                  title: Text(cycle.name, style: TextStyles.body2),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    ref
                        .read(planFormProvider.notifier)
                        .updateCycleId(cycle.id);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildColorSelector(int selectedIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(AppColors.cardColors.length, (index) {
        final color = AppColors.cardColors[index];
        final isSelected = index == selectedIndex;

        return GestureDetector(
          onTap: () =>
              ref.read(planFormProvider.notifier).updateColorIndex(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 3)
                  : Border.all(color: Colors.transparent, width: 3),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check,
                    color: AppColors.textOnPrimary, size: 16)
                : null,
          ),
        );
      }),
    );
  }

  Widget _buildRepeatToggle(bool isRepeatable) {
    return GestureDetector(
      onTap: () => ref
          .read(planFormProvider.notifier)
          .updateIsRepeatable(!isRepeatable),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('是否重复', style: TextStyles.body2),
                const SizedBox(height: 2),
                Text(
                  isRepeatable ? '每个周期自动创建' : '仅在当前周期有效',
                  style: TextStyles.labelSmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 28,
            decoration: BoxDecoration(
              color: isRepeatable
                  ? AppColors.primary
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isRepeatable
                    ? AppColors.primary
                    : AppColors.border,
              ),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: isRepeatable
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                width: 22,
                height: 22,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: isRepeatable
                      ? Colors.white
                      : AppColors.textTertiary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _savePlan,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: GradientDecoration.primary.copyWith(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            isEditing ? '保存计划' : '创建计划',
            style: TextStyles.button,
          ),
        ),
      ),
    );
  }

  Future<void> _savePlan() async {
    if (!_formKey.currentState!.validate()) return;

    final formState = ref.read(planFormProvider);
    final name = _nameController.text.trim();
    final targetAmount = int.tryParse(_targetAmountController.text) ?? 0;
    final unit = _unitController.text.trim();
    final colorValue = AppColors.cardColors[formState.selectedColorIndex].value;

    try {
      if (isEditing) {
        final template = widget.template!;
        await ref.read(planTemplateNotifierProvider.notifier).updateTemplate(
              PlanTemplate(
                id: template.id,
                name: name,
                description: formState.description.isEmpty
                    ? null
                    : formState.description,
                categoryId: formState.categoryId.isEmpty
                    ? null
                    : formState.categoryId,
                dailyTargetAmount: targetAmount,
                unit: unit.isEmpty ? null : unit,
                enableQuantityTracking: true,
                repeatType:
                    formState.isRepeatable ? formState.repeatType : 'none',
                repeatInterval: 1,
                activeDays: '1,2,3,4,5,6,7',
                startHour: template.startHour,
                startMinute: template.startMinute,
                endHour: template.endHour,
                endMinute: template.endMinute,
                colorValue: colorValue,
                startDate: template.startDate,
                endDate: template.endDate,
                isActive: template.isActive,
                sortOrder: template.sortOrder,
                createdAt: template.createdAt,
                updatedAt: DateTime.now(),
              ),
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('计划已更新')),
          );
          context.pop();
        }
      } else {
        await ref
            .read(planTemplateNotifierProvider.notifier)
            .createTemplate(
              name: name,
              description: formState.description.isEmpty
                  ? null
                  : formState.description,
              dailyTargetAmount: targetAmount,
              unit: unit.isEmpty ? null : unit,
              enableQuantityTracking: true,
              repeatType:
                  formState.isRepeatable ? formState.repeatType : 'none',
              repeatInterval: 1,
              activeDays: '1,2,3,4,5,6,7',
              startHour: 8,
              startMinute: 0,
              endHour: 9,
              endMinute: 0,
              colorValue: colorValue,
              startDate: DateTime.now(),
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('计划已创建')),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作失败: $e')),
        );
      }
    }
  }
}
