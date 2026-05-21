---
name: Loop TODO 实施计划
overview: 针对 TODO_LIST-260410 中列出的 8 项功能需求，对 Loop 计划管理应用的计划表单、日计划视图、课表导入等模块进行改进，涉及数据模型变更、UI 交互优化和业务逻辑调整。
todos:
  - id: todo-1
    content: "TODO #1：临时计划 - repeatType='none' 时隐藏活动日期区域和结束日期，修改实例生成逻辑"
    status: in_progress
  - id: todo-2
    content: "TODO #2：每周/每月活动日期差异化 - monthly 时显示 1-31 日选择器，修改 ensureInstancesForDate"
    status: pending
  - id: todo-3
    content: "TODO #3：时间范围说明文字优化 - 根据 repeatType 动态显示 subtitle"
    status: pending
  - id: todo-5
    content: "TODO #5：时间段启用开关 - 新增 enableTimeSlot 列 + 数据库迁移 + 表单开关 + 日计划视图适配"
    status: pending
  - id: todo-6a
    content: "TODO #6a：时间轴离散缩放 - 改为 7 档离散间隔(5m~2h)，含 45m 特殊档位"
    status: pending
  - id: todo-6b
    content: "TODO #6b：日期列表缩放切换视图 - 天/周/月三级缩放"
    status: pending
  - id: todo-7
    content: "TODO #7：HTML 导入后确认学期起始时间弹窗 + 周数实时刷新"
    status: pending
  - id: todo-8
    content: "TODO #8：周指示器右侧新增'第x月'显示"
    status: pending
  - id: todo-i18n
    content: 国际化：补充所有新增文案到 ARB 文件
    status: pending
  - id: todo-migration
    content: 数据库迁移：schema version +1，添加 enable_time_slot 列
    status: pending
isProject: false
---

# Loop TODO-260410 功能实施计划

## 现状概述

- 项目为 Flutter + Riverpod + Drift(SQLite) 的周期计划管理应用
- 核心文件：
  - 数据模型：[`plan_templates.dart`](loop_app/lib/data/database/tables/plan_templates.dart)、[`plan_instances.dart`](loop_app/lib/data/database/tables/plan_instances.dart)、[`timetables.dart`](loop_app/lib/data/database/tables/timetables.dart)
  - 表单 UI：[`plan_form_page.dart`](loop_app/lib/presentation/pages/plan/plan_form_page.dart)
  - 日计划视图：[`daily_plan_page.dart`](loop_app/lib/presentation/pages/plan/daily_plan_page.dart)
  - 实例生成：[`plan_instance_repository.dart`](loop_app/lib/data/repositories/plan_instance_repository.dart)
  - 课表导入：[`timetable_import_page.dart`](loop_app/lib/presentation/pages/timetable/timetable_import_page.dart)、[`timetable_provider.dart`](loop_app/lib/presentation/providers/timetable_provider.dart)

---

## TODO #1：临时计划（不重复时隐藏活动日期）

**问题**：选择"不重复"时，"活动日期"区域仍然显示星期选择器，且"时间范围"的结束日期也无意义。

**改动文件**：[`plan_form_page.dart`](loop_app/lib/presentation/pages/plan/plan_form_page.dart)

**方案**：
- 当 `_repeatType == 'none'` 时：
  - 隐藏"活动日期"整个 section（与 `daily` 类似处理，但更彻底 —— 整个 `_buildSectionCard` 不渲染）
  - "时间范围"区域隐藏 `endDate` 行，仅保留 `startDate`（即计划执行的那一天）
- `_submit()` 中：当 `repeatType == 'none'` 时，`activeDays` 设为空字符串或特殊标记（如当天的 weekday），`endDate` 设为 `null`
- `ensureInstancesForDate` 中（[`plan_instance_repository.dart`](loop_app/lib/data/repositories/plan_instance_repository.dart)）：`repeatType == 'none'` 时，仅当 `normalizedDate == normalizedStart` 时才生成实例

```dart
// plan_form_page.dart 约 371-426 行，条件修改
if (_repeatType != 'none') ...[
  const SizedBox(height: 16),
  _buildSectionCard(
    title: s.activeDate,
    // ...现有活动日期内容
  ),
],
```

---

## TODO #2：每周/每月对应不同的活动日期内容

**问题**：选择"每周"和"每月"时，活动日期区域都显示星期一到日的选择器。"每月"时应该显示 1-31 日选择。

**改动文件**：[`plan_form_page.dart`](loop_app/lib/presentation/pages/plan/plan_form_page.dart)、[`plan_instance_repository.dart`](loop_app/lib/data/repositories/plan_instance_repository.dart)

**方案**：

**UI 层**（`plan_form_page.dart`）：
- 增加 `_selectedMonthDays` 状态变量（`Set<int>`，1-31）
- 当 `_repeatType == 'weekly'`：显示现有的星期选择器（周一~周日）
- 当 `_repeatType == 'monthly'`：显示日期数字网格（1-31），使用 `Wrap` + 圆形按钮布局
- 快捷按钮：月初（1日）、月中（15日）、月末（28-31日）等

**数据层**（`plan_instance_repository.dart`）：
- `ensureInstancesForDate` 中添加 `monthly` 分支：
```dart
} else if (template.repeatType == 'monthly') {
  final activeDays = template.activeDays.split(',').map(int.parse).toList();
  if (!activeDays.contains(normalizedDate.day)) continue;
} else {
  // weekly / daily 逻辑
  final activeDays = template.activeDays.split(',').map(int.parse).toList();
  if (!activeDays.contains(weekday)) continue;
}
```

**数据模型**：`activeDays` 字段复用，但语义根据 `repeatType` 不同：
- `weekly`/`daily`：存储 1-7（星期）
- `monthly`：存储 1-31（日期）

---

## TODO #3：时间范围与重复规则的配合关系（概念性优化）

**分析**：当前逻辑已基本符合需求 —— `startDate`/`endDate` 定义总时间段，`repeatType` + `activeDays` 定义规律，`startHour`/`endHour` 定义具体时间。此条主要通过 TODO #1、#2 的实现来完善配合关系。

**额外优化**：在表单 UI 中添加说明文字，向用户解释三者关系：
- "时间范围"的 subtitle 改为动态文本，根据 repeatType 不同显示不同说明

---

## TODO #5：给"时间段"增加"是否启用时间段"开关

**改动文件**：[`plan_templates.dart`](loop_app/lib/data/database/tables/plan_templates.dart)、[`plan_form_page.dart`](loop_app/lib/presentation/pages/plan/plan_form_page.dart)、[`daily_plan_page.dart`](loop_app/lib/presentation/pages/plan/daily_plan_page.dart)、数据库迁移

**方案**：

**数据模型**：在 `PlanTemplates` 表新增列：
```dart
BoolColumn get enableTimeSlot => boolean().withDefault(const Constant(true))();
```
需添加 Drift 数据库迁移（版本号+1，`ALTER TABLE` 添加列默认值为 `true`）。

**表单 UI**：
- 在"时间段"section 顶部添加 `_buildSwitchRow` 开关
- 当关闭时，隐藏开始/结束时间选择器，时间段区域折叠
- 新增状态 `_enableTimeSlot`

**日计划视图**：
- 未启用时间段的计划不按时间定位，改为在时间表底部或顶部单独区域展示（类似全天事件）

---

## TODO #6：日程表双指缩放手势优化

**改动文件**：[`daily_plan_page.dart`](loop_app/lib/presentation/pages/plan/daily_plan_page.dart)

### 6a. 时间轴区域缩放 —— 离散时间间隔

**现状**：使用连续 `_scale`（0.5~2.0），`_hourHeight = 72 * _scale`。

**方案**：改为离散档位，每档对应一个时间间隔：

```dart
static const List<Map<String, dynamic>> _zoomLevels = [
  {'interval': 120, 'label': '2h'},   // 最小缩放
  {'interval': 60,  'label': '1h'},   // 默认
  {'interval': 45,  'label': '45m'},  // 特殊：一节课时长
  {'interval': 30,  'label': '30m'},
  {'interval': 15,  'label': '15m'},
  {'interval': 10,  'label': '10m'},
  {'interval': 5,   'label': '5m'},   // 最大缩放
];
int _currentZoomLevel = 1; // 默认 1h
```

- `onScaleUpdate` 中：累计缩放量达到阈值时切换到相邻档位
- 时间标签根据当前 interval 动态生成（如 15min 间隔时显示 `08:00`, `08:15`, `08:30`, `08:45`）
- `_hourHeight` 随 interval 联动：interval 越小，`_hourHeight` 越大

### 6b. 日期列表缩放 —— 切换天/周/月视图

**方案**：
- 在 `_buildWeekSelector` 区域添加独立的缩放手势检测
- 三个显示级别：天（单日详情，当前已有）、周（7 天条，当前已有）、月（日历月视图）
- 状态变量 `_dateViewLevel`（`day`/`week`/`month`）
- 放大（双指张开）：月 -> 周 -> 天
- 缩小（双指捏合）：天 -> 周 -> 月
- 月视图可复用或参考 `table_calendar` 依赖

---

## TODO #7：HTML 导入后确认学期起始时间

**改动文件**：[`timetable_import_page.dart`](loop_app/lib/presentation/pages/timetable/timetable_import_page.dart)、[`timetable_provider.dart`](loop_app/lib/presentation/providers/timetable_provider.dart)

**方案**：

**导入后弹出确认对话框**：
- 在 `_importFile` 成功后、跳转到详情页之前，弹出 `showDialog` 或 `showModalBottomSheet`
- 显示 HTML 解析出的 `firstWeekMonday`，允许用户通过日期选择器调整
- 用户确认后更新 Timetable 记录的 `firstWeekMonday`

**周数显示实时更新**：
- `_buildWeekIndicator` 已有此逻辑：根据 `firstWeekMonday` 计算周数，判断是否为当前周并显示"(非本周)"
- 确保 `firstWeekMonday` 更新后 provider 会 invalidate，触发 UI 刷新

**天/月视图类似处理**：与 TODO #6b 联动，在不同视图级别下也显示"非本X"提示

---

## TODO #8：日期列表上方增加"第x月"显示

**改动文件**：[`daily_plan_page.dart`](loop_app/lib/presentation/pages/plan/daily_plan_page.dart)

**方案**：

修改 `_buildWeekIndicator`，将其改为左右布局：
- 左侧：现有的"第x周"（含"非本周"后缀）
- 右侧：新增"第x月"显示

```dart
return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(weekText, style: ...),    // 左：第x周
      Text(monthText, style: ...),   // 右：第x月
    ],
  ),
);
```

月数计算：基于 `firstWeekMonday` 所在的月份为第 1 月，`_selectedDate` 所在月与之差值 +1。同样判断"非本月"。

---

## 数据库迁移注意

TODO #5 需要新增 `enableTimeSlot` 列，需在 [`app_database.dart`](loop_app/lib/data/database/app_database.dart) 中：
- 数据库 `schemaVersion` +1
- `migration` 策略中添加 `ALTER TABLE plan_templates ADD COLUMN enable_time_slot INTEGER NOT NULL DEFAULT 1`

---

## 国际化

所有新增文案需同步更新 `l10n/` 下的 ARB 文件（中文 + 英文）。
