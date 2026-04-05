import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loop_app/core/theme/colors.dart';
import 'package:loop_app/core/theme/text_styles.dart';
import 'package:loop_app/core/utils/validators.dart';
import 'package:loop_app/data/database/app_database.dart';
import 'package:loop_app/l10n/generated/app_localizations.dart';
import 'package:loop_app/presentation/providers/cycle_provider.dart';
import 'package:loop_app/presentation/widgets/common/gradient_decorations.dart';

class CycleFormPage extends ConsumerStatefulWidget {
  final Cycle? cycle;

  const CycleFormPage({
    super.key,
    this.cycle,
  });

  @override
  ConsumerState<CycleFormPage> createState() => _CycleFormPageState();
}

class _CycleFormPageState extends ConsumerState<CycleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isSubmitting = false;

  bool get _isEditMode => widget.cycle != null;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    if (_isEditMode) {
      _nameController.text = widget.cycle!.name;
      _descriptionController.text = widget.cycle!.description ?? '';
      _startDate = widget.cycle!.startDate;
      _endDate = widget.cycle!.endDate;
    } else {
      _startDate = now;
      _endDate = now.add(const Duration(days: 6));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(
        title: Text(_isEditMode ? S.of(context)!.editCycle : S.of(context)!.createCycle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GradientDecoration(
              style: GradientStyle.meshGradient,
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              top: true,
              bottom: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 140),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildNameField(),
                      const SizedBox(height: 20),
                      _buildDescriptionField(),
                      const SizedBox(height: 28),
                      _buildDateSection(),
                      const SizedBox(height: 28),
                      _buildDurationPreset(),
                      const SizedBox(height: 40),
                      _buildSubmitButton(),
                      const SizedBox(height: 24),
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

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            S.of(context)!.cycleName,
            style: TextStyles.label,
          ),
        ),
        TextFormField(
          controller: _nameController,
          style: TextStyles.body1,
          decoration: InputDecoration(
            hintText: S.of(context)!.cycleNameHint,
            hintStyle: TextStyles.body1.copyWith(color: AppColors.textHint),
            prefixIcon: const Icon(Icons.edit_note_rounded, size: 20),
          ),
          validator: (v) => CycleValidator.validateName(S.of(context)!, v),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            S.of(context)!.descOptional,
            style: TextStyles.label,
          ),
        ),
        TextFormField(
          controller: _descriptionController,
          style: TextStyles.body1,
          decoration: InputDecoration(
            hintText: S.of(context)!.cycleDescHint,
            hintStyle: TextStyles.body1.copyWith(color: AppColors.textHint),
            prefixIcon: const Icon(Icons.description_rounded, size: 20),
          ),
          maxLines: 3,
          maxLength: 200,
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context)!.cycleTime,
          style: TextStyles.heading4,
        ),
        const SizedBox(height: 16),
        _buildDateTile(
          icon: Icons.calendar_today_rounded,
          label: S.of(context)!.startDate,
          date: _startDate,
          onTap: () => _selectDate(isStart: true),
        ),
        const SizedBox(height: 12),
        _buildDateTile(
          icon: Icons.event_available_rounded,
          label: S.of(context)!.endDate,
          date: _endDate,
          onTap: () => _selectDate(isStart: false),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryMuted.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Text(
                S.of(context)!.totalDays(_endDate.difference(_startDate).inDays + 1),
                style: TextStyles.body2.copyWith(
                  color: AppColors.primaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateTile({
    required IconData icon,
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    final s = S.of(context)!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyles.caption,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s.dateYearMonthDay(date.year, date.month, date.day),
                      style: TextStyles.body1,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationPreset() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context)!.quickSelectCycle,
          style: TextStyles.heading4,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildPresetChip(S.of(context)!.oneWeek, 7),
            _buildPresetChip(S.of(context)!.twoWeeks, 14),
            _buildPresetChip(S.of(context)!.threeWeeks, 21),
            _buildPresetChip(S.of(context)!.oneMonth, 30),
            _buildPresetChip(S.of(context)!.twoMonths, 60),
            _buildPresetChip(S.of(context)!.threeMonths, 90),
          ],
        ),
      ],
    );
  }

  Widget _buildPresetChip(String label, int days) {
    final isSelected = _endDate.difference(_startDate).inDays + 1 == days &&
        _startDate == DateTime.now();

    return GestureDetector(
      onTap: () {
        setState(() {
          _startDate = DateTime.now();
          _endDate = DateTime.now().add(Duration(days: days - 1));
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.surfaceLight.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.4)
                : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyles.body2.copyWith(
            color:
                isSelected ? AppColors.primaryLight : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.backgroundDeep,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  _isEditMode ? S.of(context)!.saveChanges : S.of(context)!.createCycle,
                  style: TextStyles.button,
                ),
        ),
      ),
    );
  }

  Future<void> _selectDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: isStart ? DateTime(2024) : _startDate,
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.backgroundDeep,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: AppColors.surface,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 6));
          }
        } else {
          _endDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _startDate = _endDate.subtract(const Duration(days: 6));
          }
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final durationError = CycleValidator.validateDateRange(S.of(context)!, _startDate, _endDate);
    if (durationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(durationError),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final service = ref.read(cycleServiceProvider);
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();

      if (_isEditMode) {
        final updated = Cycle(
          id: widget.cycle!.id,
          name: name,
          description: description.isEmpty ? null : description,
          startDate: _startDate,
          endDate: _endDate,
          status: widget.cycle!.status,
          isActive: widget.cycle!.isActive,
          createdAt: widget.cycle!.createdAt,
          updatedAt: DateTime.now(),
        );
        await service.updateCycle(updated);
      } else {
        await service.createCycle(
          name: name,
          description: description.isEmpty ? null : description,
          startDate: _startDate,
          endDate: _endDate,
        );
      }

      ref.invalidate(cyclesProvider);
      ref.invalidate(activeCycleProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode ? S.of(context)!.cycleUpdated : S.of(context)!.cycleCreatedSuccess,
              style: TextStyles.body2.copyWith(color: AppColors.textPrimary),
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context)!.operationFailed(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
