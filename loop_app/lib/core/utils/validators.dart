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
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final amount = int.tryParse(value);
    if (amount == null || amount < 0) {
      return '目标量必须为非负整数';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value != null && value.length > 200) {
      return '描述不能超过200字符';
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

  static String? validateDescription(String? value) {
    if (value != null && value.length > 200) {
      return '描述不能超过200字符';
    }
    return null;
  }

  static String? validateDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null) {
      return '请选择开始日期';
    }
    if (endDate != null && endDate.isBefore(startDate)) {
      return '结束日期不能早于开始日期';
    }
    return null;
  }
}

class PlanValidator {
  PlanValidator._();

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入计划名称';
    }
    if (value.length > 50) {
      return '计划名称不能超过50字符';
    }
    return null;
  }

  static String? validateTargetAmount(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final amount = int.tryParse(value);
    if (amount == null || amount < 0) {
      return '目标量必须为非负整数';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value != null && value.length > 200) {
      return '描述不能超过200字符';
    }
    return null;
  }
}
