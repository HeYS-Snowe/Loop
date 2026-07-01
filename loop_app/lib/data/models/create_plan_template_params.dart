/// 创建计划模板的参数对象
///
/// 将创建模板所需的全部参数封装为单一对象，
/// 避免方法签名过长导致可读性差、维护成本高的问题。
class CreatePlanTemplateParams {
  final String name;
  final String? description;
  final String? categoryId;
  final int dailyTargetAmount;
  final String? unit;
  final bool enableQuantityTracking;
  final String repeatType;
  final int repeatInterval;
  final String activeDays;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final int colorValue;
  final bool enableTimeSlot;
  final bool isActive;
  final DateTime startDate;
  final DateTime? endDate;
  final int sortOrder;

  const CreatePlanTemplateParams({
    required this.name,
    this.description,
    this.categoryId,
    this.dailyTargetAmount = 0,
    this.unit,
    this.enableQuantityTracking = true,
    this.repeatType = 'none',
    this.repeatInterval = 1,
    this.activeDays = '1,2,3,4,5,6,7',
    this.startHour = 8,
    this.startMinute = 0,
    this.endHour = 9,
    this.endMinute = 0,
    this.colorValue = 0xFF2196F3,
    this.enableTimeSlot = true,
    this.isActive = true,
    required this.startDate,
    this.endDate,
    this.sortOrder = 0,
  });

  /// 创建副本并修改部分字段
  CreatePlanTemplateParams copyWith({
    String? name,
    String? description,
    String? categoryId,
    int? dailyTargetAmount,
    String? unit,
    bool? enableQuantityTracking,
    String? repeatType,
    int? repeatInterval,
    String? activeDays,
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    int? colorValue,
    bool? enableTimeSlot,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    int? sortOrder,
  }) {
    return CreatePlanTemplateParams(
      name: name ?? this.name,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      dailyTargetAmount: dailyTargetAmount ?? this.dailyTargetAmount,
      unit: unit ?? this.unit,
      enableQuantityTracking:
          enableQuantityTracking ?? this.enableQuantityTracking,
      repeatType: repeatType ?? this.repeatType,
      repeatInterval: repeatInterval ?? this.repeatInterval,
      activeDays: activeDays ?? this.activeDays,
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      endHour: endHour ?? this.endHour,
      endMinute: endMinute ?? this.endMinute,
      colorValue: colorValue ?? this.colorValue,
      enableTimeSlot: enableTimeSlot ?? this.enableTimeSlot,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
