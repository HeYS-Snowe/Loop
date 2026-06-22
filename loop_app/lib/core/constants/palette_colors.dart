import 'package:flutter/material.dart';

/// 内容调色板常量（计划卡片、课程表等可选项颜色）
///
/// 与 [core/theme/colors.dart] 中的 `AppColors` 区分：
/// - `AppColors` 负责主题色（背景、表面、文字等系统级配色）
/// - `PaletteColors` 负责用户可选的内容配色（计划卡片、课程颜色等）
class PaletteColors {
  PaletteColors._();

  /// 计划卡片预设颜色（用于计划表单的颜色选择器）
  static const List<Color> planCardColors = [
    Color(0xFF2196F3),
    Color(0xFFE91E63),
    Color(0xFF4CAF50),
    Color(0xFF9C27B0),
    Color(0xFFFF9800),
    Color(0xFF00BCD4),
    Color(0xFFF44336),
    Color(0xFF3F51B5),
    Color(0xFF8BC34A),
    Color(0xFFFF5722),
    Color(0xFF607D8B),
    Color(0xFF795548),
  ];

  /// 课程表展示颜色（用于日计划页面的课程卡片自动着色）
  static const List<Color> courseColors = [
    Color(0xFF4A90D9),
    Color(0xFF00BFA5),
    Color(0xFFFF7043),
    Color(0xFFAB47BC),
    Color(0xFF42A5F5),
    Color(0xFFFFCA28),
    Color(0xFF66BB6A),
    Color(0xFFEF5350),
  ];

  /// 课程表单颜色选择器预设颜色（用于课程编辑表单）
  static const List<Color> coursePickerColors = [
    Color(0xFF00E5A0),
    Color(0xFF00BCD4),
    Color(0xFFFF6B4A),
    Color(0xFFFFD54F),
    Color(0xFF00E676),
    Color(0xFFFF5252),
    Color(0xFF9C27B0),
    Color(0xFF00BCD4),
    Color(0xFF795548),
    Color(0xFF607D8B),
    Color(0xFFE91E63),
    Color(0xFF3F51B5),
  ];

  /// 根据索引获取计划卡片颜色（循环使用，边界安全）
  static Color planCardColorAt(int index) =>
      planCardColors[index % planCardColors.length];

  /// 根据索引获取课程表展示颜色（循环使用，边界安全）
  static Color courseColorAt(int index) =>
      courseColors[index % courseColors.length];
}
