import 'package:loop_app/l10n/generated/app_localizations.dart';

class TaskValidator {
  static String? validateName(S s, String? value) {
    if (value == null || value.isEmpty) return s.taskNameRequired;
    if (value.length > 50) return s.taskNameTooLong;
    return null;
  }

  static String? validateTargetAmount(S s, String? value) {
    final amount = int.tryParse(value ?? '');
    if (amount == null || amount <= 0) return s.targetMustBePositive;
    return null;
  }
}

class CycleValidator {
  static String? validateName(S s, String? value) {
    if (value == null || value.isEmpty) return s.cycleNameRequired;
    if (value.length > 30) return s.cycleNameTooLong;
    return null;
  }

  static String? validateDateRange(S s, DateTime? start, DateTime? end) {
    if (start == null || end == null) return s.selectDateRange;
    if (end.isBefore(start)) return s.endDateBeforeStart;
    return null;
  }
}

class CategoryValidator {
  static String? validateName(S s, String? value) {
    if (value == null || value.isEmpty) return s.categoryNameRequired;
    if (value.length > 20) return s.categoryNameTooLong;
    return null;
  }
}
