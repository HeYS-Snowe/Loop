# Loop TODO 进度对照文档

> 本文档汇总 Loop 项目当前功能实现进度，对照 260331 与 260410 两份 TODO 清单，逐项核实代码实现状态。

---

## 一、文档信息

| 属性 | 内容 |
|------|------|
| 整理日期 | 2026-07-01 |
| 整理人 | Snowe |
| 对应版本 | 0.0.17+17 |
| 核实方式 | 逐项阅读源代码核实，非凭推测判断 |
| 涉及清单 | TODO_LIST-260331（12 项）、TODO_LIST-260410（8 项想法） |

---

## 二、进度总览

### 2.1 统计汇总

| 清单 | 总数 | 已完成 | 部分完成 | 未开始 |
|------|------|--------|----------|--------|
| TODO_LIST-260331 | 12 | 12 | 0 | 0 |
| TODO_LIST-260410 | 8 | 8 | 0 | 0 |

### 2.2 结论

两份 TODO 清单所列功能均已实现。260410 的 8 项想法（含课表时间补充说明对应的 TimeSlotConstants）在 0.0.17+17 版本中全部落地。当前唯一明确待办为 260331-Todo1 中提及的 PDF 课表导入（第二阶段，未列入 260410 清单）。

---

## 三、已完成功能清单（260331 全部 12 项）

| 编号 | 标题 | 状态 | 完成说明 | 对应版本 |
|------|------|------|----------|----------|
| 260331-Todo1 | 引入课表功能 | [DONE] | 课表数据层、业务层、展示层完整实现；HTML 导入（含文件夹导入权限修复）已完成；手动创建已完成。PDF 导入为第二阶段，尚未实现 | 0.0.13+13 |
| 260331-Todo2 | 创建计划时时间段与课表冲突提示 | [DONE] | PlanFormPage 实现实时冲突检测（FutureBuilder）与提交拦截对话框；遍历活跃课表课程进行时间重叠判断 | 0.0.13+13 |
| 260331-Todo3 | 日计划双指缩放时间间隔 | [DONE] | 日程区域 GestureDetector onScaleUpdate 动态调整时间轴高度（0.5x~2.0x），仅响应双指操作 | 0.0.13+13 |
| 260331-Todo4 | 导航栏高度闪烁修复 | [DONE] | 导航栏重构为 loop_bottom_nav.dart，固定高度 + AnimatedContainer 过渡动画 | 0.0.13+13 |
| 260331-Todo5 | 课表课程在日计划页面显示 | [DONE] | coursesForDateProvider 按日期获取课程并计算周次；_CourseCard 组件显示课程信息；颜色按课程名哈希分配 | 0.0.13+13 |
| 260331-Todo6 | 日计划页面双区域滑动切换日期 | [DONE] | 上方周选择器 PageView 切换星期，下方日程区域 PageView 切换日期，双向同步含防抖标志 | 0.0.13+13 |
| 260331-Todo7 | 时间轴范围扩展防遮挡 | [DONE] | 时间轴从 06:00-23:00 扩展为 05:00-24:00，ScrollView 上下添加 padding | 0.0.13+13 |
| 260331-Todo8 | 周次指示器"第x周(非本周)" | [DONE] | 周选择器上方显示周次，基于 firstWeekMonday 计算，本周高亮、非本周灰色标注 | 0.0.13+13 |
| 260331-Todo9 | 时间段卡片上下排列 | [DONE] | 开始/结束时间从左右排列改为上下排列，中间渐变分隔线 + 时长文字 | 0.0.13+13 |
| 260331-Todo10 | 统计页面打卡卡片布局优化 | [DONE] | 打卡卡片重新设计，GlassCard + 脉冲动画圆形按钮，右侧空白问题已解决 | 0.0.13+13 |
| 260331-Todo11 | 边缘滑动切换导航页面 | [DONE] | ScaffoldWithNavBar 添加边缘滑动检测，左右边缘 28px + 速度阈值触发 tab 切换 | 0.0.13+13 |
| 260331-Todo12 | 计划编辑功能（含修改范围） | [DONE] | PlanEditScope 枚举、批量更新方法、编辑入口、范围选择对话框（本次/未来/过去/全部）、路由适配、i18n | 0.0.13+13（2026-04-07 完成） |

---

## 四、260410 想法清单实现状态（逐项 8 条）

以下逐项对照源代码核实。状态标记说明：[DONE] 已完成 / [PARTIAL] 部分完成 / [TODO] 未开始。

### 4.1 临时计划问题：不重复时不用选活动日期

| 属性 | 内容 |
|------|------|
| 状态 | [DONE] |
| 想法内容 | 选择"不重复"时，不用选择"活动日期"；时间范围的结束日期也无意义 |
| 核实依据 | plan_form_page.dart 第 370 行：`if (!{'none', 'daily', 'interval'}.contains(_repeatType))` 仅在非 none/daily/interval 时渲染活动日期区域；第 441 行：`if (_repeatType != 'none')` 仅在非 none 时渲染结束日期；第 437 行：none 时日期标签变为"计划日期"而非"开始日期"；第 1084-1085 行：none 时 activeDays 取起始日期的 weekday；第 1100 行：none 时 effectiveEndDate 为 null；plan_instance_repository.dart 第 61-62 行：none 时仅当 normalizedDate == normalizedStart 才生成实例 |
| 说明 | 表单 UI 与实例生成逻辑均已适配"不重复"场景，活动日期区域和结束日期完全隐藏 |

### 4.2 重复规则中每周/每月对应不同活动日期

| 属性 | 内容 |
|------|------|
| 状态 | [DONE] |
| 想法内容 | "每周"和"每月"应分别对应星期选择与日期(1-31)选择 |
| 核实依据 | plan_form_page.dart 第 377-378 行：monthly 时调用 `_buildMonthDaySelector()` 渲染 1-31 日期网格，weekly 时渲染星期选择器；第 47 行：`_selectedMonthDays` 状态变量；第 75-88 行：编辑模式按 repeatType 加载不同数据；第 1088-1090 行：submit 时 monthly 的 activeDays 取 _selectedMonthDays；plan_instance_repository.dart 第 69-74 行：monthly 分支按 `normalizedDate.day` 匹配，weekly 分支按 weekday 匹配 |
| 说明 | monthly 提供月初/月中/月末快捷按钮，weekly 提供工作日/每天/周末快捷按钮 |

### 4.3 时间范围 + 重复规则 + 活动日期 + 时间段配合

| 属性 | 内容 |
|------|------|
| 状态 | [DONE] |
| 想法内容 | 时间范围规划时间段，重复规则与活动日期确定规律，时间段确定具体时间 |
| 核实依据 | plan_form_page.dart 第 433 行：`_getTimeRangeSubtitle(s)` 根据 repeatType 动态显示说明文字；第 862-877 行：none/daily/weekly/monthly/interval 各有独立的说明文案（timeRangeDescNone 等）；plan_instance_repository.dart 完整实现 none/interval/monthly/weekly 四种重复类型的实例生成逻辑 |
| 说明 | 四要素（时间范围、重复规则、活动日期、时间段）的配合关系已通过动态说明文字和实例生成逻辑完整落地 |

### 4.4 给时间段增加"是否启用时间段"开关

| 属性 | 内容 |
|------|------|
| 状态 | [DONE] |
| 想法内容 | 时间段 section 增加启用/禁用开关，关闭后计划作为全天事件 |
| 核实依据 | plan_templates.dart 第 21 行：`enableTimeSlot => boolean().withDefault(const Constant(true))()` 字段已定义；app_database.dart schemaVersion 4 迁移添加该列；plan_form_page.dart 第 230-235 行：时间段 section 顶部有 `_buildSwitchRow` 开关；第 236 行：`if (_enableTimeSlot)` 控制时间选择器显隐；daily_plan_page.dart 第 748 行：按 `template.enableTimeSlot` 区分定时/全天实例；第 759 行：`_buildAllDaySection` 在顶部单独展示未启用时间段的计划 |
| 说明 | 数据模型、表单交互、日计划视图三层均已适配 |

### 4.5 日计划手势缩放：时间间隔 + 日期列表天/周/月

| 属性 | 内容 |
|------|------|
| 状态 | [DONE] |
| 想法内容 | 日程区域双指缩放时间间隔（含 45 分钟特殊档位）；日期列表双指缩放切换天/周/月显示程度 |
| 核实依据（时间轴缩放） | daily_plan_page.dart 第 35-44 行：`_zoomLevels` 定义 7 档离散间隔（120m/60m/45m/30m/15m/10m/5m），含 45m 特殊档位；第 238-303 行：Listener 双指缩放手势处理，含缩放锚点保持和 AnimationController 平滑过渡（200ms）；第 883-915 行：时间标签根据当前 interval 动态生成 |
| 核实依据（日期列表缩放） | daily_plan_page.dart 第 22 行：`_DateViewLevel { day, week, month }` 枚举；第 381-412 行：`_buildWeekSelector` 包含 GestureDetector onScaleUpdate，放大 day<-week<-month、缩小 month<-week<-day；第 414-477 行：`_buildDayView` 单日视图；第 479-579 行：`_buildWeekView` 周视图；第 581-727 行：`_buildMonthView` 月历视图 |
| 说明 | 在 260331 连续缩放基础上升级为 7 档离散缩放（含 45 分钟档位）；日期列表三级缩放已完整实现，月视图含月份切换和日期点选 |

### 4.6 HTML 导入后确认学期起始时间，实时更新周次显示

| 属性 | 内容 |
|------|------|
| 状态 | [DONE] |
| 想法内容 | HTML 导入后向用户确认学期起始时间，实时更新"第x周"显示，非本周加"(非本周)" |
| 核实依据（导入确认） | timetable_import_page.dart 第 660 行：导入成功后调用 `_showSemesterStartConfirmDialog`；第 717-812 行：弹窗显示解析出的 firstWeekMonday，内置 DatePicker 允许用户调整，确认后更新 Timetable 记录并 invalidate activeTimetableProvider |
| 核实依据（周次显示） | daily_plan_page.dart 第 305-379 行：`_buildWeekIndicator` 基于 firstWeekMonday 计算当前显示日期所属学期周次，本周显示"第x周"（主色高亮），非本周显示"第x周(非本周)"（灰色） |
| 说明 | 导入确认弹窗为 barrierDismissible: false 强制确认；周次显示在课表存在时才显示 |

### 4.7 日期列表上方左边"第x周"右边"第x月"

| 属性 | 内容 |
|------|------|
| 状态 | [DONE] |
| 想法内容 | 日期列表上方左侧显示"第x周"，右侧新增"第x月"，非当周/月时加后缀 |
| 核实依据 | daily_plan_page.dart 第 332-344 行：基于 firstWeekMonday 计算 monthNumber（月份差值 +1）和 currentMonthNumber，判断 isCurrentMonth；第 346-374 行：`Row(mainAxisAlignment: spaceBetween)` 左侧 weekText、右侧 monthText，使用 monthFormat / monthFormatNotCurrent 国际化字符串 |
| 说明 | 周次为主色、月份为强调色(accent)区分；monthNumber <= 0 时不显示月份 |

### 4.8 补充：一节课时间说明（45 分钟，作息时间）

| 属性 | 内容 |
|------|------|
| 状态 | [DONE] |
| 想法内容 | 一节课 45 分钟，课间 10/20 分钟，上午 8:20-12:00 四节，下午 14:00-17:40 四节，偶有晚八(18:30-20:00) |
| 核实依据 | time_slot_constants.dart：periodTimeSlots 定义 10 个节次时间段：第 1-4 节 8:20-12:00（每节 45 分钟，课间 10 分钟，第 2-3 节间 20 分钟），第 5-8 节 14:00-17:40（同样结构），第 9-10 节 18:30-20:00（晚课） |
| 说明 | 节次时间定义与想法描述完全一致；课程卡片和冲突检测均依赖此常量 |

---

## 五、当前未完成 / 待办

经逐项代码核实，260331 与 260410 两份清单所列功能均已实现。以下为超出两份清单范围、但在项目中明确提及的待办项：

| 编号 | 待办项 | 来源 | 状态 | 说明 |
|------|--------|------|------|------|
| PENDING-1 | PDF 课表导入 | 260331-Todo1 备注 | [TODO] | 260331-Todo1 明确标注"PDF 导入未实现（第二阶段）"。当前仅支持 HTML 文件/文件夹导入。第二阶段实现 |

---

## 六、下一阶段建议

基于当前实现现状，建议按以下优先级推进后续工作：

| 优先级 | 建议事项 | 理由 |
|--------|----------|------|
| 高 | PDF 课表导入功能 | 260331 明确规划的第二阶段功能，当前仅支持 HTML 导入，PDF 是教务系统导出的常见格式 |
| 中 | 周期(Cycle)与计划(Plan)模块的深度联动 | 当前 Cycle 模块与 Plan 模块相对独立，可考虑将计划关联到周期内，实现更紧密的进度追踪 |
| 中 | 数据备份与恢复 | 作为纯本地应用，当前缺乏数据导出/导入机制，存在数据丢失风险 |
| 低 | 课表多学期管理 | 当前支持多课表，但学期切换、历史课表归档等体验可进一步优化 |
| 低 | 日计划时间轴性能优化 | 当缩放至最小间隔(5 分钟)时，时间标签和网格线数量较多，可考虑视口虚拟化 |

---

## 附：核实涉及的源文件清单

| 文件 | 核实内容 |
|------|----------|
| loop_app/lib/presentation/pages/plan/daily_plan_page.dart | 手势缩放、日期列表三级视图、周次/月份指示器、全天事件区域 |
| loop_app/lib/presentation/pages/plan/plan_form_page.dart | 临时计划隐藏活动日期、monthly 日期选择器、时间段开关、动态说明文字、冲突检测 |
| loop_app/lib/data/repositories/plan_instance_repository.dart | none/monthly/weekly/interval 四种重复类型实例生成逻辑 |
| loop_app/lib/presentation/pages/timetable/timetable_import_page.dart | HTML 导入后学期起始时间确认弹窗 |
| loop_app/lib/data/database/tables/plan_templates.dart | enableTimeSlot 字段定义 |
| loop_app/lib/core/constants/time_slot_constants.dart | 10 节次时间定义（8:20 起，45 分钟/节） |
| loop_app/pubspec.yaml | 版本号 0.0.17+17 确认 |

---

*本文档基于源代码逐项核实生成，整理日期 2026-07-01*
