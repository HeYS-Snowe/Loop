# Loop - 项目定制规则

> **版本**: v1.3.0
> **更新日期**: 2026-06-26
> **项目类型**: Flutter Mobile App (Android)
> **技术栈**: Flutter 3.x / Dart 3.6+ / Riverpod 3.x / Drift / go_router

---

## 0. 规则体系引用

### 基础规则（自动生效）

本项目的编码规则基于 AI 编码规则体系：

- **规则入口**: `D:\Code\.Rules\main.md`
- **规则优先级**: 本文件(定制规则) > 预设配置 > 核心规则 > 默认行为
- **规则冲突时**: 以本文件中的定制规则为准

### CRITICAL 禁令（绝对禁止）

> 以下禁令提取自核心规则，违反会导致严重问题

- NEVER 在未读取文件内容的情况下修改文件 — 原因：不看就改是引入 bug 的最高效方式
- NEVER 编造不确定的信息 — 原因：编造的信息比不知道更危险
- NEVER 添加未被明确要求的功能 — 原因：增加维护成本且未经需求验证
- NEVER 将授权范围自行扩大 — 原因：一次授权不等于永久授权
- NEVER 使用 setState（必须使用 Riverpod） — 原因：破坏状态管理一致性
- NEVER 直接操作数据库（必须通过 Repository） — 原因：绕过数据层抽象
- NEVER 在 build 方法中执行异步操作 — 原因：导致重复调用和资源泄漏
- NEVER 提交 .g.dart 生成文件到版本控制 — 原因：每次构建会重新生成，产生无意义差异

### 必须遵守

- 先说结论再说理由
- 先看再改，理解上下文后再修改
- 每次变更后自动运行相关测试
- 敏感数据使用安全存储（flutter_secure_storage / 环境变量）

### 外部规则文件（必须遵守）

- **Flutter 国内网络环境配置规则**: `D:\Code\.Rules\stacks\flutter\flutter-china-mirrors.md`

---

## 一、项目概述

### 1.1 项目信息

| 属性 | 值 |
|------|-----|
| 项目名称 | Loop - 周期计划管理应用 |
| 项目类型 | 移动端应用 (个人自用) |
| 当前版本 | v0.0.13+13 (Alpha) |
| 目标平台 | Android 6.0+ (API 23) |
| 核心功能 | 周期计划管理、进度追踪、每日打卡、周期总结、计划模板、教务课表导入 |
| 特点 | 纯本地应用，无需网络，支持"部分完成"进度记录、计划编辑范围(仅本次/未来/过去/全部)、教务课表 HTML 智能解析、国际化(i18n) |

### 1.2 技术栈

| 层级 | 技术 | 版本 | 用途 |
|------|------|------|------|
| 框架 | Flutter | 3.x | 跨平台 UI 框架 |
| 语言 | Dart | 3.6+ | 编程语言 |
| 状态管理 | flutter_riverpod | ^3.3.1 | 响应式状态管理 (AsyncNotifier 范式) |
| 路由 | go_router | ^17.2.0 | 声明式路由 (StatefulShellRoute) |
| 数据库 | drift | ^2.22.1 | 本地 ORM 数据库 |
| SQLite 驱动 | sqlite3_flutter_libs | ^0.6.0+eol | SQLite 原生库 |
| 简单存储 | shared_preferences | ^2.3.5 | 应用设置 |
| 通知 | flutter_local_notifications | ^22.0.0 | 本地提醒 |
| 时区 | timezone | ^0.11.0 | 通知时区处理 |
| 图表 | fl_chart | ^1.2.0 | 进度图表 |
| 日历 | table_calendar | ^3.1.3 | 打卡日历 |
| 动画 | flutter_animate | ^4.5.2 | 打卡动画 |
| 唯一 ID | uuid | ^4.5.1 | 实体 ID 生成 |
| 国际化 | intl + flutter_localizations | ^0.20.2 / SDK | 多语言支持 (zh/en) |
| 文件路径 | path_provider / path | ^2.1.5 / ^1.9.1 | 本地路径访问 |
| 文件选择 | file_picker | ^11.0.1 | 课表 HTML 文件/文件夹导入 |
| 权限 | permission_handler | ^12.0.0 | 运行时权限申请 |
| 字体 | MiSans | 自定义 | 品牌字体 (8 种字重 100-800) |

---

## 二、目录结构规范

### 2.1 项目根目录

```
loop_app/
├── lib/
│   ├── main.dart                 # 应用入口
│   ├── app.dart                  # MaterialApp 配置 (主题/语言/路由)
│   │
│   ├── core/                     # 核心模块
│   │   ├── constants/            # 常量定义
│   │   │   ├── palette_colors.dart       # 调色板常量
│   │   │   ├── route_constants.dart      # 路由路径常量
│   │   │   └── time_slot_constants.dart  # 课表时段常量
│   │   ├── theme/                # 主题配置
│   │   │   ├── app_theme.dart
│   │   │   ├── colors.dart
│   │   │   └── text_styles.dart
│   │   ├── router/               # 路由配置
│   │   │   └── app_router.dart   # StatefulShellRoute + 自定义转场 + 边缘滑动
│   │   └── utils/                # 工具函数
│   │       ├── date_utils.dart
│   │       └── validators.dart
│   │
│   ├── data/                     # 数据层
│   │   ├── database/             # Drift 数据库定义
│   │   │   ├── app_database.dart        # schemaVersion 4
│   │   │   ├── database_connection.dart
│   │   │   ├── database_connection_stub.dart
│   │   │   ├── database_connection_web.dart
│   │   │   ├── tables/
│   │   │   │   ├── cycles.dart
│   │   │   │   ├── tasks.dart
│   │   │   │   ├── progress_records.dart
│   │   │   │   ├── check_in_records.dart
│   │   │   │   ├── categories.dart
│   │   │   │   ├── cycle_summaries.dart
│   │   │   │   ├── plan_templates.dart
│   │   │   │   ├── plan_instances.dart
│   │   │   │   ├── timetables.dart          # 课表
│   │   │   │   └── timetable_courses.dart   # 课表课程
│   │   │   └── app_database.g.dart   # 生成文件
│   │   ├── extensions/           # 数据扩展
│   │   │   └── model_extensions.dart
│   │   ├── models/               # 纯数据模型
│   │   │   └── check_in_record.dart
│   │   └── repositories/         # 数据仓库
│   │       ├── cycle_repository.dart
│   │       ├── task_repository.dart
│   │       ├── check_in_repository.dart
│   │       ├── category_repository.dart
│   │       ├── plan_template_repository.dart
│   │       ├── plan_instance_repository.dart
│   │       └── timetable_repository.dart
│   │
│   ├── domain/                   # 业务层
│   │   └── services/             # 业务服务
│   │       ├── cycle_service.dart
│   │       ├── check_in_service.dart
│   │       └── timetable_html_parser.dart  # 教务系统 HTML 智能解析
│   │
│   ├── presentation/             # 表现层
│   │   ├── providers/            # Riverpod Providers
│   │   │   ├── cycle_provider.dart
│   │   │   ├── task_provider.dart
│   │   │   ├── check_in_provider.dart
│   │   │   ├── plan_provider.dart
│   │   │   ├── timetable_provider.dart
│   │   │   └── settings_provider.dart
│   │   ├── pages/                # 页面
│   │   │   ├── home/
│   │   │   │   ├── home_page.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── check_in_card.dart
│   │   │   │       ├── cycle_card.dart
│   │   │   │       └── quick_stats_card.dart
│   │   │   ├── tasks/
│   │   │   │   ├── task_list_page.dart
│   │   │   │   ├── task_detail_page.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── add_task_dialog.dart
│   │   │   │       ├── edit_task_dialog.dart
│   │   │   │       └── task_card.dart
│   │   │   ├── check_in/
│   │   │   │   └── check_in_page.dart
│   │   │   ├── summary/
│   │   │   │   ├── summary_page.dart
│   │   │   │   └── summary_card.dart
│   │   │   ├── cycle/
│   │   │   │   └── cycle_form_page.dart
│   │   │   ├── plan/
│   │   │   │   ├── daily_plan_page.dart
│   │   │   │   └── plan_form_page.dart
│   │   │   ├── timetable/                # 课表模块
│   │   │   │   ├── timetable_list_page.dart
│   │   │   │   ├── timetable_detail_page.dart
│   │   │   │   ├── timetable_import_page.dart
│   │   │   │   └── course_form_page.dart
│   │   │   └── settings/
│   │   │       └── settings_page.dart
│   │   └── widgets/              # 共享组件
│   │       └── common/
│   │           ├── animated_widgets.dart
│   │           ├── glass_card.dart
│   │           ├── gradient_decorations.dart
│   │           ├── loop_bottom_nav.dart
│   │           ├── loop_time_picker.dart
│   │           └── particle_background.dart
│   │
│   ├── l10n/                     # 国际化
│   │   ├── app_zh.arb            # 模板语言 (中文)
│   │   ├── app_en.arb            # 英文
│   │   └── generated/            # 生成的本地化文件 (output-class: S)
│   │
│   └── shared/                   # 共享模块
│       ├── services/
│       │   └── notification_service.dart
│       └── extensions/
│           └── date_extensions.dart
│
├── fonts/                        # 自定义字体
│   └── ttf/                      # MiSans (8 种字重)
│
├── test/                         # 测试目录
├── docs/                         # 项目文档
├── pubspec.yaml                  # 依赖配置
├── analysis_options.yaml         # 代码分析配置
├── l10n.yaml                     # 国际化配置
└── README.md
```

### 2.2 目录说明

| 目录 | 用途 | 说明 |
|------|------|------|
| `core/` | 核心模块 | 常量、主题、路由、工具函数 |
| `data/` | 数据层 | 数据库定义、扩展、仓库 |
| `domain/` | 业务层 | 业务实体、服务 |
| `presentation/` | 表现层 | Providers、页面、共享组件 |
| `l10n/` | 国际化 | 多语言支持 (zh/en) |
| `shared/` | 共享模块 | 跨层服务、扩展方法 |
| `fonts/` | 自定义字体 | MiSans (品牌字体，8 种字重 100-800) |

---

## 三、代码规范

### 3.1 命名规范

```yaml
命名约定:
  类名: PascalCase              # TaskRepository, CheckInPage
  变量: camelCase               # taskList, completedAmount
  常量: camelCase               # maxTaskNameLength
  文件: snake_case.dart         # task_repository.dart
  私有成员: _前缀                # _taskList, _database
  Provider: xxxProvider         # taskProvider, cycleProvider
  表名: snake_case              # cycles, progress_records
```

### 3.2 Dart 代码规范

```dart
// ✅ 正确示例
class TaskRepository {
  final AppDatabase _database;

  TaskRepository(this._database);

  Future<List<Task>> getTasksByCycleId(String cycleId) async {
    return await _database.getTasksByCycle(cycleId);
  }

  Future<void> updateProgress(String taskId, int amount) async {
    await _database.updateTaskProgress(taskId, amount);
  }
}

// ❌ 错误示例
class taskRepo {  // 类名应 PascalCase
  var db;  // 应明确类型
  getTasks(id) => db.tasks.where((t) => t.cycleId == id);  // 缺少类型注解
}
```

### 3.3 Flutter Widget 规范

```dart
// ✅ 正确示例 - 使用 const 构造函数
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
  });

  final Task task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(task.name),
        subtitle: Text('${task.completedAmount}/${task.targetAmount}'),
        trailing: ProgressIndicator(progress: task.progress),
        onTap: onTap,
      ),
    );
  }
}

// ❌ 错误示例
class TaskCard extends StatelessWidget {
  TaskCard({Key? key, this.task});  // 缺少 const, required

  Task? task;  // 应为 final, required

  @override
  Widget build(BuildContext context) {
    return Container(  // 过度嵌套
      child: Container(
        child: Card(
          child: ListTile(...),
        ),
      ),
    );
  }
}
```

---

## 四、数据库规范 (Drift)

### 4.1 表定义示例

```dart
// data/database/tables/tasks.dart
import 'package:drift/drift.dart';
import 'cycles.dart';
import 'categories.dart';

@DataClassName('Task')
class Tasks extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get cycleId => text().withLength(min: 36, max: 36).references(Cycles, #id)();
  TextColumn get name => text().withLength(max: 50)();
  IntColumn get targetAmount => integer().check(targetAmount.isBiggerThanValue(0))();
  IntColumn get completedAmount => integer().withDefault(const Constant(0))();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  BoolColumn get isRepeatable => boolean().withDefault(const Constant(false))();
  TextColumn get repeatType => text().nullable().withLength(max: 10)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
```

### 4.2 数据库访问模式

```dart
// data/database/app_database.dart
@DriftDatabase(tables: [
  Cycles,
  Tasks,
  ProgressRecords,
  CheckInRecords,
  Categories,
  CycleSummaries,
  PlanTemplates,
  PlanInstances,
  Timetables,
  TimetableCourses,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  // 迁移策略: v2 加计划表 / v3 加课表表 / v4 给 plan_templates 加 enable_time_slot
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async => m.createAll(),
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(planTemplates);
        await m.createTable(planInstances);
      }
      if (from < 3) {
        await m.createTable(timetables);
        await m.createTable(timetableCourses);
      }
      if (from < 4) {
        await customStatement(
          'ALTER TABLE plan_templates ADD COLUMN enable_time_slot INTEGER NOT NULL DEFAULT 1',
        );
      }
    },
  );

  // 查询方法
  Future<List<Task>> getTasksByCycle(String cycleId) {
    return (select(tasks)..where((t) => t.cycleId.equals(cycleId))).get();
  }

  // 监听查询 (用于 Riverpod)
  Stream<List<Task>> watchTasksByCycle(String cycleId) {
    return (select(tasks)..where((t) => t.cycleId.equals(cycleId))).watch();
  }

  // 更新方法
  Future<void> updateTaskProgress(String taskId, int amount) async {
    await (update(tasks)..where((t) => t.id.equals(taskId))).write(
      TasksCompanion(
        completedAmount: Value(amount),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
```

---

## 五、状态管理规范 (Riverpod)

### 5.1 Provider 定义

```dart
// presentation/providers/cycle_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 数据库 Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Repository Provider (依赖注入)
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(ref.watch(databaseProvider));
});

// 查询型 Provider - 用 FutureProvider / StreamProvider
final cyclesProvider = FutureProvider<List<Cycle>>((ref) async {
  return ref.watch(cycleRepositoryProvider).getAllCycles();
});

final activeCycleProvider = FutureProvider<Cycle?>((ref) async {
  return ref.watch(cycleRepositoryProvider).getActiveCycle();
});

// 带变更逻辑的 Provider - 用 AsyncNotifier (Riverpod 3.x)
final planTemplateNotifierProvider =
    AsyncNotifierProvider<PlanTemplateNotifier, List<PlanTemplate>>(
  PlanTemplateNotifier.new,
);
```

### 5.2 AsyncNotifier 示例 (Riverpod 3.x)

```dart
// presentation/providers/settings_provider.dart
class SettingsNotifier extends AsyncNotifier<SettingsState> {
  @override
  Future<SettingsState> build() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsState(
      enableNotifications: prefs.getBool('notifications_enabled') ?? true,
      defaultCycleDays: prefs.getInt('default_cycle_days') ?? 30,
    );
  }

  Future<void> updateNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
    final current = state.value ?? const SettingsState();
    state = AsyncValue.data(current.copyWith(enableNotifications: enabled));
  }
}

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
```

---

## 六、路由规范 (go_router)

### 6.1 路由配置

```dart
// core/router/app_router.dart
final appRouter = GoRouter(
  initialLocation: RouteConstants.home,
  routes: [
    // 底部导航 4 个 Tab (各分支独立保活，StatefulShellRoute.indexedStack)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithNavBar(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [/* /home */]),
        StatefulShellBranch(routes: [/* /daily-plan */]),
        StatefulShellBranch(routes: [/* /summary */]),
        StatefulShellBranch(routes: [/* /settings */]),
      ],
    ),
    // 全屏路由 (带自定义转场 LoopPageTransition)
    GoRoute(path: '/tasks', name: 'tasks', ...),
    GoRoute(path: '/create-cycle', name: 'create-cycle', ...),
    GoRoute(path: '/edit-cycle', name: 'edit-cycle', ...),
    GoRoute(path: '/create-plan', name: 'create-plan', ...),
    GoRoute(path: '/edit-plan', name: 'edit-plan', ...),
    GoRoute(path: '/timetables', name: 'timetables', ...),
    GoRoute(path: '/timetable-detail', name: 'timetable-detail', ...),
    GoRoute(path: '/timetable-import', name: 'timetable-import', ...),
    GoRoute(path: '/course-form', name: 'course-form', ...),
  ],
);

// ScaffoldWithNavBar: 自定义边缘滑动切换 Tab (左右边缘 28px + 速度判定，无 setState)
```

### 6.2 路由导航

```dart
// 导航示例
context.go('/home');              // 首页
context.go('/daily-plan');        // 每日计划
context.go('/summary');           // 周期总结
context.go('/settings');          // 设置
context.go('/tasks');             // 任务列表
context.go('/timetables');        // 课表列表
context.push('/create-cycle');    // 创建周期 (push 入栈)
context.pop();                    // 返回上一页
```

---

## 七、业务规则

### 7.1 核心业务规则

| 规则ID | 规则描述 | 触发条件 | 处理逻辑 |
|--------|----------|----------|----------|
| BR-001 | 任务目标量必须为正整数 | 创建/编辑任务 | 验证 targetAmount > 0 |
| BR-002 | 每日完成量不能超过剩余量 | 记录进度 | 自动限制为剩余量 |
| BR-003 | 连续打卡中断后归零 | 打卡时检查 | 昨天未打卡则重置为1 |
| BR-004 | 周期结束自动生成总结 | 周期结束时间 | 触发统计计算 |
| BR-005 | 重复任务自动创建 | 新周期开始 | 复制任务到新周期 |
| BR-006 | 每天只能打卡一次 | 打卡操作 | 检查今日是否已打卡 |

### 7.2 验证规则

```dart
// core/utils/validators.dart
class TaskValidator {
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
```

### 7.3 计算规则

```dart
// 计算逻辑示例 (完成率 / 周期完成率 / 连续打卡天数)
class CalculationService {
  // 完成率计算
  static double calculateProgress(int completed, int target) {
    if (target <= 0) return 0;
    return (completed / target).clamp(0.0, 1.0);
  }

  // 周期完成率
  static double calculateCycleCompletion(List<Task> tasks) {
    if (tasks.isEmpty) return 0;
    final completed = tasks.where((t) => t.isCompleted).length;
    return completed / tasks.length;
  }

  // 连续打卡天数
  static int calculateStreak(List<CheckInRecord> records) {
    if (records.isEmpty) return 0;

    final sortedRecords = records..sort((a, b) => b.date.compareTo(a.date));
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    // 检查今天或昨天是否打卡
    if (!sortedRecords.any((r) =>
      _isSameDay(r.date, today) || _isSameDay(r.date, yesterday))) {
      return 0;
    }

    int streak = 1;
    for (int i = 1; i < sortedRecords.length; i++) {
      final diff = sortedRecords[i - 1].date.difference(sortedRecords[i].date).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
```

---

## 八、构建与部署规范

### 8.1 构建命令

```bash
# 开发调试
flutter run

# 构建 Debug APK
flutter build apk --debug

# 构建 Release APK
flutter build apk --release

# 构建 App Bundle (用于上架)
flutter build appbundle --release

# 运行测试
flutter test

# 代码生成 (Drift)
dart run build_runner build
```

### 8.2 产物命名与输出

```
格式: Loop_{status}_{version}_{date}_{seq}.apk

- status: alpha / beta / release / dev / debug
- version: 如 0.0.13
- date: YYYYMMDD
- seq: 01, 02, ...

示例: Loop_alpha_0.0.13_20260626_01.apk

> 详细命名与归档流程见 `docs/TODO/DEV_COMMANDS.md`
```

**产物输出目录**: 项目根目录下的 `builds/`（不在 `build/` 内，不受 `flutter clean` 影响）

```
构建流程:
  build/app/outputs/flutter-apk/app-release.apk  (Flutter 原始输出)
  → 重命名为 Loop_正式版_0.0.2_20260406_02.apk
  → 移动到 D:\Code\Project\Loop\builds\           (持久化存放)
```

### 8.3 版本管理

```yaml
# pubspec.yaml
version: 0.0.13+13  # Major.Minor.Patch+BuildNumber (Flutter 标准格式)

# 版本号规则
# Major.Minor.Patch+BuildNumber
# 0.0.13+13  - 当前 Alpha 版本
# 1.0.0+1    - MVP 版本
# 1.1.0+2    - 新增功能
# 1.1.1+3    - Bug 修复
```

---

## 九、测试规范

### 9.1 测试策略

| 测试类型 | 覆盖范围 | 工具 |
|----------|----------|------|
| 单元测试 | 业务逻辑、计算函数 | flutter_test |
| Widget测试 | UI组件 | flutter_test |
| 集成测试 | 完整流程 | integration_test |

### 9.2 测试示例

```dart
// 计算逻辑测试示例
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalculationService', () {
    test('calculateProgress returns correct percentage', () {
      expect(CalculationService.calculateProgress(50, 100), 0.5);
      expect(CalculationService.calculateProgress(100, 100), 1.0);
      expect(CalculationService.calculateProgress(150, 100), 1.0); // clamp
      expect(CalculationService.calculateProgress(0, 100), 0.0);
    });

    test('calculateProgress handles division by zero', () {
      expect(CalculationService.calculateProgress(50, 0), 0.0);
    });
  });
}
```

---

## 十、UI 设计规范

### 10.1 颜色方案

```dart
// core/theme/colors.dart
class AppColors {
  // 主色调 - 蓝色系
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryLight = Color(0xFFBBDEFB);
  static const Color primaryDark = Color(0xFF1976D2);

  // 成功/完成 - 绿色
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFC8E6C9);

  // 警告 - 橙色
  static const Color warning = Color(0xFFFF9800);

  // 错误 - 红色
  static const Color error = Color(0xFFF44336);

  // 进度条渐变
  static const LinearGradient progressGradient = LinearGradient(
    colors: [primary, success],
  );
}
```

### 10.2 组件规范

```yaml
按钮:
  圆角: 8dp
  最小高度: 48dp
  内边距: 16dp

卡片:
  圆角: 12dp
  阴影: elevation 2
  内边距: 16dp

进度条:
  高度: 8dp
  圆角: 4dp
  动画: 300ms

输入框:
  圆角: 8dp
  边框: 1dp
  标签位置: 浮动
```

---

## 十一、检查清单

### 开发前

- [ ] 确认 Flutter 环境: `flutter doctor`
- [ ] 拉取最新代码
- [ ] 安装依赖: `flutter pub get`
- [ ] 运行代码生成: `dart run build_runner build`

### 提交前

- [ ] 代码格式化: `dart format .`
- [ ] 静态分析: `flutter analyze`
- [ ] 运行测试: `flutter test`
- [ ] 检查 TODO 注释
- [ ] 更新 CHANGELOG

### 发布前

- [ ] 更新版本号
- [ ] 运行完整测试
- [ ] 构建 Release APK
- [ ] 真机测试
- [ ] 重命名 APK 并移动到 `builds/` 目录

---

## 十二、禁止事项

```yaml
禁止:
  - 使用 setState (必须使用 Riverpod)
  - 在 build 方法中执行异步操作
  - 硬编码字符串 (使用常量)
  - 直接操作数据库 (必须通过 Repository)
  - 忽略空安全警告
  - 提交 .g.dart 生成文件到版本控制 (除首次)
  - 在循环中创建 Widget
  - 使用 var 声明变量 (明确类型)
  - 使用 emoji 表情 (代码、注释、提交信息、文档中全部禁止)
```

### 禁止 Emoji 规则

```yaml
适用范围:
  代码文件: 禁止在代码中添加 emoji
  注释: 禁止在注释中使用 emoji
  提交信息: 禁止在 git commit message 中使用 emoji
  文档: 所有项目文档中禁止使用 emoji

替代方案:
  提交信息: 使用约定式前缀 (feat: / fix: / refactor: 等)
  状态标记: 使用纯文本标记 ([DONE] / [TODO] / [WIP] / [IMPORTANT])
  表情含义: 用文字描述替代

例外情况:
  用户界面字符串: 允许 (由产品需求决定)
```

---

## 十三、最佳实践

### 13.1 性能优化

- 使用 `const` 构造函数
- 使用 `ListView.builder` 替代 `Column` + `map`
- 避免不必要的 Widget 重建
- 使用 `select` 精确订阅 Provider 状态

### 13.2 代码组织

- 每个页面独立目录，包含 widgets 子目录
- 相关功能放在一起
- 共享组件放 `presentation/widgets/common/`
- 工具函数放 `core/utils/`

### 13.3 错误处理

```dart
// 使用 AsyncValue 处理异步错误
class TaskList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksByCycleProvider('current'));

    return tasksAsync.when(
      data: (tasks) => TaskListView(tasks: tasks),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorView(message: error.toString()),
    );
  }
}
```

---

## 变更记录

| 版本 | 日期 | 变更内容 |
|------|------|----------|
| v1.0.0 | 2026-03-26 | 初始版本，基于 AI-Rules 规则体系生成 |
| v1.1.0 | 2026-04-02 | 适配规则体系 v3.1.0，新增 CRITICAL 禁令 + 规则分层引用 |
| v1.2.0 | 2026-04-04 | 同步项目现状：新增 plan 模块、schedule 页面、l10n、自定义字体、版本号更新 |
| v1.2.1 | 2026-04-10 | 同步规则体系：新增"必须遵守"章节，修正禁令措辞 |
| v1.3.0 | 2026-06-26 | 同步至 v0.0.13+13：Riverpod 3.x / go_router 17 / fl_chart 1.x；新增 timetable 课表模块；schemaVersion 升至 4；移除不存在的 schedule/entities/HunYuan |

> **补充规则** (源自 AI-Rules v3.0.0):

### 变更后自动测试

AI 在执行以下操作后，必须自动运行测试以验证功能正常：

```yaml
触发条件:
  - 修改了 Dart 源代码
  - 修改了 pubspec.yaml 依赖
  - 修改了 Drift 数据库定义
  - 修改了路由/状态管理配置
  - 修复了 Bug
  - 任何可能影响已有功能的操作

测试范围:
  直接测试: 被修改的功能/模块
  关联测试:
    - 调用被修改代码的上层页面/Provider
    - 被修改代码的下游 Repository/Service
    - 共享同一数据模型的其他模块

执行要求:
  1. 识别变更影响范围
  2. 运行 flutter test
  3. 全部通过后才视为变更完成
  4. 若测试失败，立即修复，不可跳过
```

---

*此规则由 AI-Rules 规则体系 + Loop 项目定制需求自动生成*
*规则即模板，模板即规则*
