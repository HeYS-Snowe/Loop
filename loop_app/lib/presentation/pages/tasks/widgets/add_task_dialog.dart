import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('添加任务', style: TextStyles.heading4),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '任务名称 *',
                  hintText: '例如：背单词',
                ),
                style: TextStyles.body1,
                validator: TaskValidator.validateName,
                maxLength: 50,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '描述（可选）',
                  hintText: '任务描述',
                ),
                style: TextStyles.body1,
                maxLines: 2,
                maxLength: 200,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _targetAmountController,
                      decoration: const InputDecoration(
                        labelText: '目标数量',
                        hintText: '0',
                      ),
                      style: TextStyles.body1,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: TaskValidator.validateTargetAmount,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: const InputDecoration(
                        labelText: '单位（可选）',
                        hintText: '个/分钟',
                      ),
                      style: TextStyles.body1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text('可重复', style: TextStyles.body2),
                subtitle: Text(
                  '在新周期中自动创建',
                  style: TextStyles.caption,
                ),
                value: _isRepeatable,
                onChanged: (value) {
                  setState(() => _isRepeatable = value);
                },
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('取消', style: TextStyles.buttonSmall),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('添加'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addTask() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final targetAmount = int.tryParse(_targetAmountController.text) ?? 0;
    final unit = _unitController.text.trim();

    try {
      await ref.read(taskNotifierProvider.notifier).createTask(
            cycleId: widget.cycleId,
            name: name,
            description: description.isEmpty ? null : description,
            targetAmount: targetAmount,
            unit: unit.isEmpty ? null : unit,
            isRepeatable: _isRepeatable,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('任务创建成功')),
        );
        ref.read(tasksNotifierProvider(widget.cycleId).notifier).refresh();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('创建失败: $e')),
        );
      }
    }
  }
}
