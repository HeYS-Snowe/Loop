import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../providers/task_provider.dart';

class AddTaskDialog extends ConsumerStatefulWidget {
  final String cycleId;

  const AddTaskDialog({
    super.key,
    required this.cycleId,
  });

  @override
  ConsumerState<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends ConsumerState<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _unitController = TextEditingController();
  bool _isRepeatable = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(
            color: AppColors.glassBorder.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: kIsWeb
            ? Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: _buildFormContent(),
              )
            : BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 20,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  ),
                  child: _buildFormContent(),
                ),
              ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('添加任务', style: TextStyles.heading3),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            style: TextStyles.body1,
            decoration: InputDecoration(
              labelText: '任务名称',
              prefixIcon: const Icon(Icons.edit_note_rounded, size: 20),
            ),
            validator: TaskValidator.validateName,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            style: TextStyles.body1,
            decoration: InputDecoration(
              labelText: '描述（可选）',
              prefixIcon: const Icon(Icons.description_rounded, size: 20),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _targetAmountController,
                  style: TextStyles.body1,
                  decoration: InputDecoration(
                    labelText: '目标数量',
                    prefixIcon: const Icon(Icons.flag_rounded, size: 20),
                  ),
                  keyboardType: TextInputType.number,
                  validator: TaskValidator.validateTargetAmount,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _unitController,
                  style: TextStyles.body1,
                  decoration: InputDecoration(
                    labelText: '单位（可选）',
                    prefixIcon: const Icon(Icons.straighten_rounded, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: SwitchListTile(
              title: Text('可重复', style: TextStyles.body1),
              subtitle: Text(
                '在新周期中自动创建',
                style: TextStyles.body2,
              ),
              value: _isRepeatable,
              onChanged: (value) {
                setState(() {
                  _isRepeatable = value;
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  '取消',
                  style: TextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
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
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: const Text('添加'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();
      final targetAmount = int.parse(_targetAmountController.text);
      final unit = _unitController.text.trim();

      await ref.read(taskNotifierProvider(widget.cycleId).notifier).createTask(
            name: name,
            description: description.isEmpty ? null : description,
            targetAmount: targetAmount,
            unit: unit.isEmpty ? null : unit,
            isRepeatable: _isRepeatable,
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('任务创建成功',
                style: TextStyles.body2.copyWith(color: AppColors.textPrimary)),
          ),
        );
      }
    }
  }
}
