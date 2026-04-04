# Loop - 项目定制规则

> **版本**: v1.2.0
> **更新日期**: 2026-04-04
> **项目类型**: Flutter Mobile App (Android)
> **技术栈**: Flutter 3.x / Dart 3.6+ / Riverpod / Drift / go_router

---

## 0. 规则体系引用

### 基础规则（自动生效）

本项目的编码规则基于 AI 编码规则体系：

- **规则入口**: `D:\Code\.Rules\main.md`
- **规则优先级**: 本文件(定制规则) > 预设配置 > 核心规则 > 默认行为
- **规则冲突时**: 以本文件中的定制规则为准

### CRITICAL 禁令（绝对禁止）

> 以下禁令提取自核心规则，违反会导致严重问题

- NEVER 在未读取文件的情况下修改文件 — 原因：不看就改是引入 bug 的最高效方式
- NEVER 编造不确定的信息 — 原因：编造的信息比不知道更危险
- NEVER 添加未被明确要求的功能 — 原因：增加维护成本且未经需求验证
- NEVER 将授权范围自行扩大 — 原因：一次授权不等于永久授权
- NEVER 使用 setState（必须使用 Riverpod） — 原因：破坏状态管理一致性
- NEVER 直接操作数据库（必须通过 Repository） — 原因：绕过数据层抽象
- NEVER 在 build 方法中执行异步操作 — 原因：导致重复调用和资源泄漏
- NEVER 提交 .g.dart 生成文件到版本控制 — 原因：每次构建会重新生成，产生无意义差异

### 外部规则文件（必须遵守）

- **Flutter 国内网络环境配置规则**: `D:\Code\.Rules\stacks\flutter\flutter-china-mirrors.md`

---

## 一、项目概述

### 1.1 项目信息

| 属性 | 值 |
|------|-----|
| 项目名称 | Loop - 周期计划管理应用 |
| 项目类型 | 移动端应用 (个人自用) |
| 当前版本 | v0.0.1 (Alpha) |
| 目标平台 | Android 6.0+ (API 23) |
| 核心功能 | 周期计划管理、进度追踪、每日打卡、周期总结、计划模板 |
| 特点 | 纯本地应用，无需网络，支持"部分完成"进度记录、国际化(i18n) |

### 1.2 技术栈

| 层级 | 技术 | 版本 | 用途 |
|------|------|------|------|
| 框架 | Flutter | 3.x | 跨平台 UI 框架 |
| 语言 | Dart | 3.6+ | 编程语言 |
| 状态管理 | flutter_riverpod | ^2.6.1 | 响应式状态管理 |
| 路由 | go_router | ^14.8.0 | 声明式路由 |
| 数据库 | Drift + SQLite | ^2.22.1 | 本地 ORM 数据库 |
| 简单存储 | shared_preferences | ^2.3.5 | 应用设置 |
| 通知 | flutter_local_notifications | ^18.0.1 | 本地提醒 |
| 图表 | fl_chart | ^0.70.2 | 进度图表 |
| 日历 | table_calendar | ^3.1.3 | 打卡日历 |
| 动画 | flutter_animate | ^4.5.2 | 打卡动画 |
| 国际化 | flutter_localizations | SDK 内置 | 多语言支持 |
| 时区 | timezone | ^0.10.0 | 通知时区处理 |
| 字体 | MiSans + HunYuan | 自定义 | 品牌字体 |

---

## 二、目录结构规范

### 2.1 项目根目录

```
loop_app/
├── lib/
│   ├── main.dart                 # 应用入口
│   │
│   ├── core/                     # 核心模块
│   │   ├── constants/            # 常量定义
│   │   │   └── route_constants.dart
│   │   ├── theme/                # 主题配置
│   │   │   ├── app_theme.dart
│   │   │   ├── colors.dart
│   │   │   └── text_styles.dart
│   │   ├── router/               # 路由配置
│   │   │   └── app_router.dart
│   │   └── utils/                # 工具函数
│   │       └── validators.dart
│   │
│   ├── data/                     # 数据层
│   │   ├── database/             # Drift 数据库定义
│   │   │   ├── app_database.dart
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
│   │   │   │   └── plan_instances.dart
│   │   │   └── app_database.g.dart   # 生成文件
│   │   ├── extensions/           # 数据扩展
│   │   │   └── model_extensions.dart
│   │   └── repositories/         # 数据仓库
│   │       ├── cycle_repository.dart
│   │       ├── task_repository.dart
│   │       ├── check_in_repository.dart
│   │       ├── category_repository.dart
│   │       ├── plan_template_repository.dart
│   │       └── plan_instance_repository.dart
│   │
│   ├── domain/                   # 业务层
│   │   ├── entities/             # 业务实体
│   │   └── services/             # 业务服务
│   │       ├── cycle_service.dart
│   │       └── check_in_service.dart
│   │
│   ├── presentation/             # 表现层
│   │   ├── providers/            # Riverpod Providers
│   │   │   ├── cycle_provider.dart
│   │   │   ├── task_provider.dart
│   │   │   ├── check_in_provider.dart
│   │   │   ├── plan_provider.dart
│   │   │   └── settings_provider.dart
│   │   ├── pages/                # 页面
│   │   │   ├── home/
│   │   │   │   ├── home_page.dart
│   │   │   │   └── widgets/
│   │   │   ├── tasks/
│   │   │   │   ├── task_list_page.dart
│   │   │   │   ├── task_detail_page.dart
│   │   │   │   └── widgets/
│   │   │   ├── check_in/
│   │   │   │   └── check_in_page.dart
│   │   │   ├── summary/
│   │   │   │   ├── summary_page.dart
│   │   │   │   └── widgets/
│   │   │   ├── cycle/
│   │   │   │   └── cycle_form_page.dart
│   │   │   ├── plan/
│   │   │   │   ├── daily_plan_page.dart
│   │   │   │   └── plan_form_page.dart
│   │   │   ├── schedule/
│   │   │   │   └── schedule_page.dart
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
│   │   └── generated/            # 生成的本地化文件
│   │
│   └── shared/                   # 共享模块
│       ├── services/
│       │   └── notification_service.dart
│       └── extensions/
│           └── date_extensions.dart
│
├── fonts/                        # 自定义字体
│   └── ttf/                      # MiSans + HunYuan
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
| `fonts/` | 自定义字体 | MiSans (品牌)、HunYuan (装饰) |

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
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

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
// presentation/providers/task_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 数据库 Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Repository Provider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(ref.watch(databaseProvider));
});

// 任务列表 Provider (异步)
final tasksByCycleProvider = FutureProvider.family<List<Task>, String>((ref, cycleId) async {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.getTasksByCycle(cycleId);
});

// 当前周期 Provider
final currentCycleProvider = StateNotifierProvider<CycleNotifier, AsyncValue<Cycle?>>((ref) {
  return CycleNotifier(ref.watch(cycleRepositoryProvider));
});
```

### 5.2 StateNotifier 示例

```dart
// presentation/providers/check_in_provider.dart
class CheckInNotifier extends StateNotifier<AsyncValue<CheckInState>> {
  final CheckInRepository _repository;

  CheckInNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> checkIn() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));

      final yesterdayRecord = await _repository.getRecordByDate(yesterday);
      final lastRecord = await _repository.getLastRecord();

      int streakCount = 1;
      if (yesterdayRecord != null) {
        streakCount = lastRecord?.streakCount ?? 0 + 1;
      }

      await _repository.insertRecord(
        CheckInRecord(
          id: uuid.v4(),
          date: today,
          streakCount: streakCount,
          createdAt: today,
        ),
      );

      return CheckInState(checkedIn: true, streakCount: streakCount);
    });
  }
}

class CheckInState {
  final bool checkedIn;
  final int streakCount;

  CheckInState({required this.checkedIn, required this.streakCount});
}
```

---

## 六、路由规范 (go_router)

### 6.1 路由配置

```dart
// core/router/app_router.dart
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/home', name: 'home', builder: ...),
    GoRoute(path: '/tasks', name: 'tasks', builder: ..., routes: [
      GoRoute(path: ':taskId', name: 'task-detail', builder: ...),
    ]),
    GoRoute(path: '/check-in', name: 'check-in', builder: ...),
    GoRoute(path: '/summary', name: 'summary', builder: ...),
    GoRoute(path: '/cycle-form', name: 'cycle-form', builder: ...),
    GoRoute(path: '/plan', name: 'plan', builder: ..., routes: [
      GoRoute(path: 'daily', name: 'daily-plan', builder: ...),
      GoRoute(path: 'form', name: 'plan-form', builder: ...),
    ]),
    GoRoute(path: '/schedule', name: 'schedule', builder: ...),
    GoRoute(path: '/settings', name: 'settings', builder: ...),
  ],
);
```

### 6.2 路由导航

```dart
// 导航示例
context.go('/home');                           // 首页
context.go('/tasks');                          // 任务列表
context.go('/tasks/${task.id}');               // 任务详情
context.go('/check-in');                       // 打卡页
context.go('/cycle-form');                     // 创建/编辑周期
context.go('/plan/daily');                     // 每日计划
context.go('/schedule');                       // 日程页
context.pop();                                 // 返回上一页
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
// domain/services/calculation_service.dart
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
flutter pub run build_runner build --delete-conflicting-outputs
```

### 8.2 产物命名

```
格式: Loop_{status}_{version}_{date}_{seq}.apk

示例:
Loop_正式版_1.0.0_20260430_01.apk
Loop_测试版_1.0.0_20260415_01.apk
Loop_开发版_1.0.0_20260401_01.apk
```

### 8.3 版本管理

```yaml
# pubspec.yaml
version: 1.0.0+1  # version+buildNumber

# 版本号规则
# Major.Minor.Patch+Build
# 1.0.0+1  - MVP版本
# 1.1.0+2  - 新增功能
# 1.1.1+3  - Bug修复
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
// test/unit/calculation_service_test.dart
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
- [ ] 运行代码生成: `flutter pub run build_runner build`

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
- [ ] 重命名 APK
- [ ] 备份构建产物

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
