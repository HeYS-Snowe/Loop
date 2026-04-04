import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loop/core/theme/colors.dart';
import 'package:loop/core/theme/text_styles.dart';
import 'package:loop/data/database/app_database.dart';
import 'package:loop/presentation/providers/cycle_provider.dart';
import 'package:loop/presentation/widgets/common/animated_widgets.dart';
import 'package:loop/presentation/widgets/common/glass_card.dart';
import 'package:loop/presentation/widgets/common/gradient_decorations.dart';
import 'package:uuid/uuid.dart';

final cycleFormStateProvider =
    StateNotifierProvider<CycleFormNotifier, CycleFormState>(
  (ref) => CycleFormNotifier(),
);

class CycleFormState {
  final DateTime startDate;
  final DateTime endDate;

  CycleFormState({
    required this.startDate,
    required this.endDate,
  });

  CycleFormState copyWith({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return CycleFormState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class CycleFormNotifier extends StateNotifier<CycleFormState> {
  CycleFormNotifier()
      : super(CycleFormState(
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 7)),
        ));

  void initFromCycle(Cycle cycle) {
    state = CycleFormState(
      startDate: cycle.startDate,
      endDate: cycle.endDate,
    );
  }

  void updateStartDate(DateTime date) {
    state = state.copyWith(startDate: date);
  }

  void updateEndDate(DateTime date) {
    state = state.copyWith(endDate: date);
  }
}

class CycleFormPage extends ConsumerStatefulWidget {
  final Cycle? cycle;

  const CycleFormPage({super.key, this.cycle});

  @override
  ConsumerState<CycleFormPage> createState() => _CycleFormPageState();
}

class _CycleFormPageState extends ConsumerState<CycleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool get isEditing => widget.cycle != null;

  @override
  void initState() {
    super.initState();
    if (widget.cycle != null) {
      _nameController.text = widget.cycle!.name;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(cycleFormStateProvider.notifier).initFromCycle(widget.cycle!);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(cycleFormStateProvider);
    final startDate = formState.startDate;
    final endDate = formState.endDate;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInWidget(
                        child: _buildNameSection(),
                      ),
                      const SizedBox(height: 16),
                      FadeInWidget(
                        duration: const Duration(milliseconds: 500),
                        child: _buildDateSection(startDate, endDate),
                      ),
                      const SizedBox(height: 16),
                      FadeInWidget(
                        duration: const Duration(milliseconds: 600),
                        child: _buildQuickSelectSection(startDate, endDate),
                      ),
                      const SizedBox(height: 32),
                      FadeInWidget(
                        duration: const Duration(milliseconds: 700),
                        child: _buildSaveButton(),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        isEditing ? '编辑周期' : '创建周期',
        style: TextStyles.heading4,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        TextButton(
          onPressed: _saveCycle,
          child: Text(
            '保存',
            style: TextStyles.buttonSmall.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.glassBorder,
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildNameSection() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel('周期名称', AppColors.primary),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            maxLength: 30,
            style: TextStyles.body1,
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              labelText: '周期名称 *',
              hintText: '例如：第一周学习计划',
              hintStyle:
                  TextStyles.body2.copyWith(color: AppColors.textHint),
              labelStyle: TextStyles.labelSmall,
              counterText: '',
              filled: true,
              fillColor: AppColors.surfaceLight,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.border.withOpacity(0.5),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.borderLight,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.5,
                ),
              ),
              errorStyle:
                  TextStyles.caption.copyWith(color: AppColors.error),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入周期名称';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(DateTime startDate, DateTime endDate) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel('周期时间', AppColors.accent),
          const SizedBox(height: 16),
          _buildDateSelector(
            label: '开始日期',
            icon: Icons.play_arrow_rounded,
            iconColor: AppColors.primary,
            date: startDate,
            onTap: () => _selectStartDate(startDate),
          ),
          const SizedBox(height: 12),
          _buildDateSelector(
            label: '结束日期',
            icon: Icons.flag_rounded,
            iconColor: AppColors.accent,
            date: endDate,
            onTap: () => _selectEndDate(startDate, endDate),
          ),
          const SizedBox(height: 16),
          _buildDurationHint(startDate, endDate),
        ],
      ),
    );
  }

  Widget _buildDurationHint(DateTime startDate, DateTime endDate) {
    final days = endDate.difference(startDate).inDays;
    String durationText;
    if (days < 0) {
      durationText = '结束日期不能早于开始日期';
    } else if (days == 0) {
      durationText = '周期为 1 天';
    } else {
      final weeks = (days / 7).floor();
      if (weeks > 0 && days % 7 == 0) {
        durationText = '周期为 $weeks 周（共 ${days + 1} 天）';
      } else {
        durationText = '周期为 ${days + 1} 天';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryMuted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 6),
          Text(
            durationText,
            style: TextStyles.labelSmall.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSelectSection(DateTime startDate, DateTime endDate) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel('快速选择周期', AppColors.info),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickChip('1周', 7, startDate, endDate),
              _buildQuickChip('2周', 14, startDate, endDate),
              _buildQuickChip('3周', 21, startDate, endDate),
              _buildQuickChip('1个月', 30, startDate, endDate),
              _buildQuickChip('2个月', 60, startDate, endDate),
              _buildQuickChip('3个月', 90, startDate, endDate),
            ],
          ),
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

  Widget _buildDateSelector({
    required String label,
    required IconData icon,
    required Color iconColor,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.border.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyles.labelSmall),
                  const SizedBox(height: 2),
                  Text(
                    '${date.year}年${date.month}月${date.day}日',
                    style: TextStyles.body2,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickChip(
      String label, int days, DateTime startDate, DateTime endDate) {
    final isSelected = endDate.difference(startDate).inDays == days;

    return GestureDetector(
      onTap: () {
        ref
            .read(cycleFormStateProvider.notifier)
            .updateEndDate(startDate.add(Duration(days: days)));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryMuted
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withOpacity(0.4)
                : AppColors.border.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyles.labelSmall.copyWith(
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _saveCycle,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: GradientDecoration.primaryToAccent.copyWith(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: AppColors.accent.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            isEditing ? '保存周期' : '创建周期',
            style: TextStyles.button,
          ),
        ),
      ),
    );
  }

  Future<void> _selectStartDate(DateTime current) async {
    final date = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('zh', 'CN'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.textOnPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: AppColors.surfaceLight,
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      ref.read(cycleFormStateProvider.notifier).updateStartDate(date);
    }
  }

  Future<void> _selectEndDate(
      DateTime startDate, DateTime current) async {
    final date = await showDatePicker(
      context: context,
      initialDate:
          current.isAfter(startDate) ? current : startDate,
      firstDate: startDate,
      lastDate: DateTime(2030),
      locale: const Locale('zh', 'CN'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.textOnPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: AppColors.surfaceLight,
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      ref.read(cycleFormStateProvider.notifier).updateEndDate(date);
    }
  }

  Future<void> _saveCycle() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final formState = ref.read(cycleFormStateProvider);

    try {
      if (isEditing) {
        final cycle = widget.cycle!;
        await ref
            .read(cycleNotifierProvider.notifier)
            .updateCycle(
              CyclesCompanion(
                id: Value(cycle.id),
                name: Value(name),
                description: Value(cycle.description),
                startDate: Value(formState.startDate),
                endDate: Value(formState.endDate),
                isActive: Value(cycle.isActive),
                createdAt: Value(cycle.createdAt),
                updatedAt: Value(DateTime.now()),
              ),
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '周期已更新',
                style: TextStyles.body2.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              backgroundColor: AppColors.surfaceLight,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          context.pop();
        }
      } else {
        await ref
            .read(cycleNotifierProvider.notifier)
            .createCycle(
              CyclesCompanion(
                id: Value(const Uuid().v4()),
                name: Value(name),
                description: const Value(null),
                startDate: Value(formState.startDate),
                endDate: Value(formState.endDate),
                isActive: const Value(true),
                createdAt: Value(DateTime.now()),
                updatedAt: Value(DateTime.now()),
              ),
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '周期创建成功',
                style: TextStyles.body2.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              backgroundColor: AppColors.surfaceLight,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '操作失败: $e',
              style: TextStyles.body2.copyWith(
                color: AppColors.errorLight,
              ),
            ),
            backgroundColor: AppColors.surfaceLight,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }
}
