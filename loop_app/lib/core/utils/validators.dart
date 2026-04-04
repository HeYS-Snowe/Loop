class TaskValidator {
  TaskValidator._();

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入任务名称';
    }
    if (value.length > 50) {
      return '任务名称不能超过50字符';
    }
    return null;
  }

  static String? validateTargetAmount(String? value) {
    final amount = int.tryParse(value ?? '');
    if (amount == null || amount <= 0) {
      return '目标量必须大于0';
    }
    return null;
  }
}

class CycleValidator {
  CycleValidator._();

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入周期名称';
    }
    if (value.length > 30) {
      return '周期名称不能超过30字符';
    }
    return null;
  }

  static String? validateDuration(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return '请选择开始和结束日期';
    }
    if (endDate.isBefore(startDate)) {
      return '结束日期不能早于开始日期';
    }
    return null;
  }
}

class CategoryValidator {
  CategoryValidator._();

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入分类名称';
    }
    if (value.length > 20) {
      return '分类名称不能超过20字符';
    }
    return null;
  }
}
