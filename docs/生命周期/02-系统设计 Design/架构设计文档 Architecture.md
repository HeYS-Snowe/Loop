# 架构设计文档 Architecture Design Document

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 文档版本 Document Version | v2.0.0 |
| 创建日期 Created Date | 2026-03-16 |
| 最后修改 Last Modified | 2026-07-01 |
| 架构师 Architect | Snowe |
| 项目 Project | Loop - 周期计划管理应用 |
| 技术栈 Tech Stack | Flutter 3.x / Dart 3.6+ / Riverpod 3.x / Drift / go_router 17 |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 审核人 Reviewer | 修改内容 Description |
|-------------|---------|---------------|---------------|-------------------|
| v1.0.0 | 2026-03-16 | Snowe | - | 初始版本,基于通用模板生成 |
| v2.0.0 | 2026-07-01 | Snowe | - | 同步实际 Flutter 分层架构:重写分层/状态/路由/数据/UI/i18n 各章节,移除企业级电商空模板内容(网关层/HTTPS/Redis/K8s 等) |

---

## 目录 Table of Contents

1. [架构概述 Architecture Overview](#1-架构概述-architecture-overview)
2. [架构原则 Architecture Principles](#2-架构原则-architecture-principles)
3. [逻辑架构 Logical Architecture](#3-逻辑架构-logical-architecture)
4. [目录结构 Directory Structure](#4-目录结构-directory-structure)
5. [状态管理架构 State Management](#5-状态管理架构-state-management)
6. [路由架构 Routing Architecture](#6-路由架构-routing-architecture)
7. [数据架构 Data Architecture](#7-数据架构-data-architecture)
8. [UI 架构 UI Architecture](#8-ui-架构-ui-architecture)
9. [国际化架构 Internationalization](#9-国际化架构-internationalization)
10. [安全与可靠性 Security and Reliability](#10-安全与可靠性-security-and-reliability)

---

## 1. 架构概述 Architecture Overview

### 1.1 产品定位 Product Positioning

Loop 是一款**个人自用的纯本地周期计划管理应用**,核心能力覆盖周期计划管理、进度追踪、每日打卡、周期总结、计划模板与教务课表导入。

| 属性 Attribute | 内容 Content |
|--------------|-------------|
| 部署形态 Deployment | 纯本地移动应用,无服务端、无网络依赖 |
| 目标平台 Target Platform | Android 6.0+ (API 23) 为主,工程同时含 iOS / macOS / Windows / Web 目录 |
| 数据存储 Storage | 本地 SQLite(经 Drift ORM),无远程 API |
| 当前版本 Version | 0.0.17+17 (Alpha) |
| 开发者 Developer | Snowe |

### 1.2 架构目标 Architecture Goals

| 目标维度 Goal Dimension | 目标描述 Target Description |
|---------------------|--------------------------|
| 离线可用 Offline-First | 零网络依赖,所有数据本地读写,任意环境可用 |
| 响应式 UI Reactive UI | 数据变更通过 Riverpod + Drift Stream 自动驱动界面刷新 |
| 数据一致性 Consistency | 单一数据源(AppDatabase),Repository 统一封装,避免状态分裂 |
| 视觉一致性 Visual Coherence | 暗色主题 + 玻璃拟态 + 粒子背景的统一设计语言 |
| 国际化 I18n | 6 种语言(zh/en/de/fr/ja/ko)开箱即用 |
| 可维护性 Maintainability | 严格分层与单一职责,表现层不跨层访问数据库 |

### 1.3 架构视图 Architecture Views

| 视图类型 View Type | 说明 Description |
|-----------------|---------------|
| 逻辑架构视图 Logical View | core / data / domain / presentation / shared 五层职责划分 |
| 状态视图 State View | Riverpod Provider 注入与 AsyncNotifier 变更流 |
| 路由视图 Routing View | go_router StatefulShellRoute 四 Tab + 全屏路由 |
| 数据视图 Data View | UI -> Provider -> Repository -> Drift -> SQLite |

---

## 2. 架构原则 Architecture Principles

### 2.1 核心设计原则 Core Design Principles

| 原则 Principle | 说明 Description | 应用示例 Example |
|--------------|---------------|--------------|
| 分层 Layered | 按职责严格分层,层间通过依赖注入解耦 | core/data/domain/presentation/shared 五层 |
| 单一职责 SRP | 每个模块/类专注一件事 | TaskRepository 只管 Task 数据访问 |
| 依赖方向 DI | 单向依赖,高层不反向依赖低层 | presentation -> domain -> data |
| 响应式 Reactive | 状态变化自动传播到视图 | Riverpod watch + Drift Stream |
| 纯本地 Local-First | 数据不出端,优先本地存储 | 全程无网络层 |

### 2.2 分层总览 Layered Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    表现层 Presentation Layer                     │
│   pages (8模块)  │  providers (Riverpod)  │  widgets/common     │
└──────────────────────────────┬──────────────────────────────────┘
                               │ 依赖注入 (ref.watch)
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                      业务层 Domain Layer                        │
│            services (CycleService / CheckInService /            │
│                   TimetableHtmlParser)                          │
└──────────────────────────────┬──────────────────────────────────┘
                               │ 调用
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                       数据层 Data Layer                         │
│  repositories (7个)  │  database (Drift 10表)  │  models/exts   │
└──────────────────────────────┬──────────────────────────────────┘
                               │ 原生调用
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                 核心层 / 共享层 Core & Shared                    │
│   core (constants/theme/router/utils)  │  shared (services/ext) │
└─────────────────────────────────────────────────────────────────┘
```

### 2.3 强制约束 Hard Constraints

| 约束 Constraint | 说明 Description |
|--------------|---------------|
| 禁止 setState | 全局使用 Riverpod,UI 层不得调用 setState 管理业务状态 |
| 禁止跨层直连数据库 | 表现层不得直接访问 AppDatabase,必须经 Repository |
| build 方法禁止异步 | 不在 Widget build 中执行 Future,异步逻辑放 Provider/Notifier |
| 编辑既有文件优先 | 不擅自新增模块,遵循现有目录约定 |
| 生成文件不入库 | app_database.g.dart 等由 build_runner 生成,不提交版本控制 |

---

## 3. 逻辑架构 Logical Architecture

### 3.1 分层架构图 Layered Architecture Diagram

```
┌──────────────────────────────────────────────────────────────────────────┐
│                            表现层 Presentation                            │
│                                                                          │
│   ┌────────────────────┐  ┌────────────────────┐  ┌──────────────────┐  │
│   │      pages         │  │     providers      │  │  widgets/common  │  │
│   │ home / tasks /     │  │ Riverpod 3.x       │  │ GlassCard        │  │
│   │ check_in / summary │  │ FutureProvider     │  │ LoopBottomNav    │  │
│   │ cycle / plan /     │  │ StreamProvider     │  │ ParticleBg       │  │
│   │ timetable / set    │  │ AsyncNotifier      │  │ LoopTimePicker   │  │
│   └────────────────────┘  └─────────┬──────────┘  └──────────────────┘  │
│                                     │ ref.watch / ref.read              │
└─────────────────────────────────────┼────────────────────────────────────┘
                                      │
                ┌─────────────────────┴──────────────────────┐
                │ (部分跨层: provider 也可直接依赖 repository) │
                ▼                                              ▼
┌──────────────────────────────────────────┐   ┌──────────────────────────┐
│              业务层 Domain               │   │        数据层 Data       │
│                                          │   │                          │
│  ┌───────────────┐  ┌─────────────────┐  │   │ ┌──────────────────────┐ │
│  │ CycleService  │  │ CheckInService  │  │   │ │ 7 Repository         │ │
│  │ (周期业务)    │  │ (打卡业务)      │  │   │ │ cycle/task/check_in  │ │
│  └───────────────┘  └─────────────────┘  │   │ │ category/plan_tmpl   │ │
│  ┌─────────────────────────────────────┐ │   │ │ plan_instance/timetbl│ │
│  │ TimetableHtmlParser (教务HTML解析)  │ │   │ └──────────────────────┘ │
│  └─────────────────────────────────────┘ │   │ ┌──────────────────────┐ │
└──────────────────────────────────────────┘   │ │ AppDatabase (Drift)  │ │
                                               │ │ 10 Tables            │ │
                                               │ │ schemaVersion = 4    │ │
                                               │ └──────────┬───────────┘ │
                                               └────────────┼─────────────┘
                                                            │
                                                            ▼
                                               ┌──────────────────────────┐
                                               │  SQLite (sqlite3_flutter │
                                               │  _libs) 本地数据库文件    │
                                               └──────────────────────────┘
```

### 3.2 各层职责 Layer Responsibilities

#### 表现层 Presentation Layer (`lib/presentation/`)

| 子模块 Submodule | 职责 Responsibility |
|---------------|-------------------|
| pages | 8 大功能模块的页面(home/tasks/check_in/summary/cycle/plan/timetable/settings),每个模块独立目录并含 widgets 子目录 |
| providers | 6 个 provider 文件,定义 35+ 个 Riverpod Provider/Notifier,负责状态管理与业务编排 |
| widgets/common | 6 个跨页面共享组件:GlassCard/LoopBottomNav/ParticleBackground/LoopTimePicker/gradient_decorations/animated_widgets |

#### 业务层 Domain Layer (`lib/domain/`)

| 服务 Service | 职责 Responsibility |
|-----------|-------------------|
| CycleService | 周期业务编排,组合 CycleRepository 与 TaskRepository,提供 CycleWithTasks 完成率计算 |
| CheckInService | 打卡业务逻辑,连续打卡(streak)计算、每日唯一打卡校验 |
| TimetableHtmlParser | 教务系统课表 HTML 智能解析,提取学年/学期/首周周一/总周数/课程列表,支持文件与文件夹两种导入源 |

#### 数据层 Data Layer (`lib/data/`)

| 子模块 Submodule | 职责 Responsibility |
|---------------|-------------------|
| database | Drift 数据库定义(AppDatabase),10 张表,封装 get/watch/insert/update/delete,含迁移策略与 exportToJson |
| repositories | 7 个仓库,封装单一领域的数据访问,持有 Uuid 生成主键,委托 AppDatabase 执行 |
| models | 纯数据模型(如 CheckInRecord、CreatePlanTemplateParams) |
| extensions | 数据扩展方法(如 model_extensions 的 CycleWithTasks、progress 计算扩展) |

#### 核心层 Core Layer (`lib/core/`)

| 子模块 Submodule | 职责 Responsibility |
|---------------|-------------------|
| constants | 路由常量(RouteConstants)、调色板(PaletteColors)、课表时段(TimeSlotConstants) |
| theme | 暗色主题(AppTheme.darkTheme)、颜色(AppColors)、文字样式(TextStyles) |
| router | go_router 配置(appRouter)、自定义转场(LoopPageTransition)、ScaffoldWithNavBar(边缘滑动) |
| utils | 日期工具、校验器(TaskValidator 等) |

#### 共享层 Shared Layer (`lib/shared/`)

| 子模块 Submodule | 职责 Responsibility |
|---------------|-------------------|
| services | NotificationService(flutter_local_notifications 本地提醒) |
| extensions | 跨层扩展方法(如 date_extensions) |

### 3.3 依赖关系 Dependency Relationships

```
presentation ──▶ domain ──▶ data ──▶ (Drift/SQLite)
     │              │          │
     └──────────────┴──────────┴──▶ core / shared
```

- 表现层通过 `ref.watch(xxxProvider)` 订阅状态,通过 `ref.read(notifier).method()` 触发变更
- Provider 在创建时注入 Repository(`ref.watch(repositoryProvider)`),Repository 注入 AppDatabase
- 业务服务(CycleService)可选,简单的 CRUD 由 Provider 直接调用 Repository;跨领域编排才走 Service
- core 与 shared 是横向依赖,被任意层引用

---

## 4. 目录结构 Directory Structure

### 4.1 lib 目录树 lib Directory Tree

```
loop_app/lib/
├── main.dart                          # 应用入口:初始化通知 + ProviderScope
├── app.dart                           # LoopApp (MaterialApp.router 配置)
│
├── core/                              # 核心层
│   ├── constants/
│   │   ├── palette_colors.dart        # 调色板常量
│   │   ├── route_constants.dart       # 路由路径常量 (14 个)
│   │   └── time_slot_constants.dart   # 课表时段常量
│   ├── theme/
│   │   ├── app_theme.dart             # AppTheme.darkTheme (仅暗色)
│   │   ├── colors.dart                # AppColors 色板 + 渐变
│   │   └── text_styles.dart           # TextStyles 文字样式
│   ├── router/
│   │   └── app_router.dart            # GoRouter + LoopPageTransition + ScaffoldWithNavBar
│   └── utils/
│       ├── date_utils.dart            # 日期工具
│       └── validators.dart            # TaskValidator 校验器
│
├── data/                              # 数据层
│   ├── database/
│   │   ├── app_database.dart          # @DriftDatabase 10 表, schemaVersion 4
│   │   ├── app_database.g.dart        # [生成] 不入库
│   │   ├── database_connection.dart   # io 平台连接
│   │   ├── database_connection_stub.dart  # 桩连接
│   │   ├── database_connection_web.dart   # web 平台连接
│   │   └── tables/                    # 10 张表定义
│   │       ├── cycles.dart
│   │       ├── tasks.dart
│   │       ├── progress_records.dart
│   │       ├── check_in_records.dart
│   │       ├── categories.dart
│   │       ├── cycle_summaries.dart
│   │       ├── plan_templates.dart
│   │       ├── plan_instances.dart
│   │       ├── timetables.dart
│   │       └── timetable_courses.dart
│   ├── extensions/
│   │   └── model_extensions.dart      # 数据模型扩展
│   ├── models/
│   │   ├── check_in_record.dart
│   │   └── create_plan_template_params.dart
│   └── repositories/                  # 7 个仓库
│       ├── cycle_repository.dart
│       ├── task_repository.dart
│       ├── check_in_repository.dart
│       ├── category_repository.dart
│       ├── plan_template_repository.dart
│       ├── plan_instance_repository.dart
│       └── timetable_repository.dart
│
├── domain/                            # 业务层
│   └── services/
│       ├── cycle_service.dart         # 周期业务编排
│       ├── check_in_service.dart      # 打卡业务
│       └── timetable_html_parser.dart # 教务 HTML 解析
│
├── presentation/                      # 表现层
│   ├── providers/                     # 6 个 provider 文件
│   │   ├── cycle_provider.dart        # database + 各 repository + cycleService 注入
│   │   ├── task_provider.dart
│   │   ├── check_in_provider.dart
│   │   ├── plan_provider.dart         # PlanEditScope + 计划模板/实例
│   │   ├── timetable_provider.dart
│   │   └── settings_provider.dart     # SettingsState + SharedPreferences
│   ├── pages/                         # 8 大功能模块
│   │   ├── home/                      # 首页 (home_page + widgets/)
│   │   ├── tasks/                     # 任务 (list/detail/widgets)
│   │   ├── check_in/                  # 打卡
│   │   ├── summary/                   # 周期总结
│   │   ├── cycle/                     # 周期表单
│   │   ├── plan/                      # 每日计划 + 计划表单
│   │   ├── timetable/                 # 课表 (list/detail/import/course_form)
│   │   └── settings/                  # 设置
│   └── widgets/common/                # 6 个共享组件
│       ├── animated_widgets.dart
│       ├── glass_card.dart            # 玻璃拟态卡片
│       ├── gradient_decorations.dart
│       ├── loop_bottom_nav.dart       # 自定义底部导航
│       ├── loop_time_picker.dart
│       └── particle_background.dart   # 粒子背景
│
├── l10n/                              # 国际化
│   ├── app_zh.arb                     # 中文模板
│   ├── app_en.arb                     # 英文
│   ├── app_de.arb / app_fr.arb / app_ja.arb / app_ko.arb
│   └── generated/                     # 生成本地化 (output-class: S)
│       ├── app_localizations.dart
│       └── app_localizations_{zh,en,de,fr,ja,ko}.dart
│
└── shared/                            # 共享模块
    ├── services/
    │   └── notification_service.dart  # 本地通知
    └── extensions/
        └── date_extensions.dart       # 日期扩展
```

### 4.2 目录职责速查 Directory Cheatsheet

| 目录 Directory | 用途 Usage | 依赖方向 Dependency |
|--------------|----------|------------------|
| core/ | 常量、主题、路由、工具 | 被所有层引用 |
| data/ | 数据库、仓库、模型 | 被 domain/presentation 引用 |
| domain/ | 业务服务 | 被 presentation 引用,依赖 data |
| presentation/ | 页面、状态、共享组件 | 依赖 domain/data/core |
| shared/ | 跨层服务与扩展 | 被任意层引用 |
| l10n/ | 国际化资源与生成代码 | 被 presentation 引用 |

---

## 5. 状态管理架构 State Management

### 5.1 Riverpod 范式 Riverpod Patterns

Loop 采用 Riverpod 3.x,严格遵循以下四类 Provider 范式:

| Provider 类型 Type | 用途 Usage | 项目示例 Example |
|------------------|----------|----------------|
| Provider | 无状态依赖注入(创建 Repository / Database / Service 单例) | databaseProvider / cycleRepositoryProvider / cycleServiceProvider |
| FutureProvider / FutureProvider.family | 一次性异步查询,读取数据 | cyclesProvider / tasksByCycleProvider(cycleId) / planInstancesByDateProvider(date) |
| StreamProvider | 响应式流查询(配合 Drift watch) | (查询型,数据变更自动刷新) |
| AsyncNotifier / AsyncNotifierProvider | 带变更逻辑的状态容器,管理增删改 | PlanTemplateNotifier / TaskNotifier / SettingsNotifier / TimetableNotifier |
| NotifierProvider | 同步简单状态 | taskFilterProvider (筛选模式 0/1/2) |

### 5.2 依赖注入链 Dependency Injection Chain

```
databaseProvider (Provider<AppDatabase>)
        │
        ▼  ref.watch(databaseProvider)
cycleRepositoryProvider (Provider<CycleRepository>)
taskRepositoryProvider  (Provider<TaskRepository>)
checkInRepositoryProvider
categoryRepositoryProvider
planTemplateRepositoryProvider
planInstanceRepositoryProvider
timetableRepositoryProvider
        │
        ▼  ref.watch(repoProvider)
cycleServiceProvider (Provider<CycleService>)   # 组合多 repo
        │
        ▼
各查询型 Provider / AsyncNotifier
```

注入根 `databaseProvider` 定义在 `cycle_provider.dart` 中,被全项目复用。所有 Repository 通过 `ref.watch(databaseProvider)` 获取同一 AppDatabase 实例,保证单一数据源。

### 5.3 数据流向 Data Flow(以 Plan 模块为例)

```
┌──────────────────────────────────────────────────────────────────────┐
│ DailyPlanPage (ConsumerWidget)                                       │
│   ref.watch(planInstancesByDateProvider(date))  ── 读取当日实例       │
│   ref.read(planInstanceNotifierProvider.notifier).toggleComplete(id) │
└──────────────────────────────┬───────────────────────────────────────┘
                               │ ref.read / ref.watch
                               ▼
┌──────────────────────────────────────────────────────────────────────┐
│ PlanInstanceNotifier (AsyncNotifier<List<PlanInstance>>)             │
│   build(): ensureInstancesForDate -> getInstancesByDate              │
│   toggleComplete(id): completeInstance / uncompleteInstance          │
│   变更后 ref.invalidateSelf() 触发重建                                │
└──────────────────────────────┬───────────────────────────────────────┘
                               │ 调用
                               ▼
┌──────────────────────────────────────────────────────────────────────┐
│ PlanInstanceRepository                                               │
│   completeInstance / uncompleteInstance / updateInstance             │
│   updateInstancesByTemplateExcludeDate (按编辑范围批量更新)           │
└──────────────────────────────┬───────────────────────────────────────┘
                               │ 委托
                               ▼
┌──────────────────────────────────────────────────────────────────────┐
│ AppDatabase (Drift) -> update(planInstances)..write(...)             │
└──────────────────────────────────────────────────────────────────────┘
```

### 5.4 计划编辑范围 Plan Edit Scope

`plan_provider.dart` 定义了 `PlanEditScope` 枚举,体现"计划编辑范围"业务规则:

| 范围 Scope | 含义 Meaning | 处理 Handling |
|----------|------------|--------------|
| thisOnly | 仅本次 | 只更新当前实例,不影响模板与其他实例 |
| future | 未来 | updateInstancesByTemplateExcludeDate(排除当前日期) |
| past | 过去 | updateInstancesByTemplateBeforeDate(当前日期之前) |
| all | 全部 | updateAllInstancesByTemplate(模板下所有实例) |

该逻辑由 `PlanTemplateNotifier.updateTemplateWithScope` 编排,是 Loop 区别于普通 CRUD 的核心业务能力。

### 5.5 状态消费约定 State Consumption Convention

UI 层统一使用 `AsyncValue.when` 处理异步状态:

```dart
final tasksAsync = ref.watch(tasksByCycleProvider(cycleId));
return tasksAsync.when(
  data: (tasks) => TaskListView(tasks: tasks),
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (error, stack) => ErrorView(message: error.toString()),
);
```

变更类操作通过 `ref.read(xxxNotifierProvider.notifier).method()` 触发,Notifier 内部完成数据写入后调用 `ref.invalidateSelf()` 使相关 Provider 重建,从而驱动界面刷新。

---

## 6. 路由架构 Routing Architecture

### 6.1 路由总体结构 Routing Structure

Loop 使用 go_router 17,核心由 `StatefulShellRoute.indexedStack`(底部导航四 Tab)与多个全屏 `GoRoute`(自定义转场)组成:

```
appRouter (GoRouter, initialLocation: /home)
│
├── StatefulShellRoute.indexedStack ── ScaffoldWithNavBar (4 Tab 独立保活)
│   ├── Branch 0: /home           (HomePage)
│   ├── Branch 1: /daily-plan     (DailyPlanPage)
│   ├── Branch 2: /summary        (SummaryPage)
│   └── Branch 3: /settings       (SettingsPage)
│
├── /tasks (全屏, LoopPageTransition)
│   └── /tasks/task-detail/:taskId (嵌套子路由)
├── /create-cycle      (全屏)
├── /edit-cycle        (全屏, extra: Cycle)
├── /create-plan       (全屏)
├── /edit-plan         (全屏, extra: PlanTemplate | (template, currentDate))
├── /timetables        (全屏)
├── /timetable-detail  (全屏, query: id)
├── /timetable-import  (全屏)
└── /course-form       (全屏, query: timetableId, courseId?)

errorBuilder -> 页面不存在 + 返回首页
```

### 6.2 路由清单 Route Table

| 路由名称 Name | 路径 Path | 类型 Type | 参数 Params | 页面 Page |
|-------------|---------|---------|-----------|---------|
| home | /home | Tab(保活) | - | HomePage |
| daily-plan | /daily-plan | Tab(保活) | - | DailyPlanPage |
| summary | /summary | Tab(保活) | - | SummaryPage |
| settings | /settings | Tab(保活) | - | SettingsPage |
| tasks | /tasks | 全屏 | - | TaskListPage |
| task-detail | /tasks/task-detail/:taskId | 嵌套全屏 | path: taskId | TaskDetailPage |
| create-cycle | /create-cycle | 全屏 | - | CycleFormPage |
| edit-cycle | /edit-cycle | 全屏 | extra: Cycle | CycleFormPage(cycle) |
| create-plan | /create-plan | 全屏 | - | PlanFormPage |
| edit-plan | /edit-plan | 全屏 | extra: PlanTemplate | PlanFormPage(template) |
| timetables | /timetables | 全屏 | - | TimetableListPage |
| timetable-detail | /timetable-detail | 全屏 | query: id | TimetableDetailPage(timetableId) |
| timetable-import | /timetable-import | 全屏 | - | TimetableImportPage |
| course-form | /course-form | 全屏 | query: timetableId, courseId? | CourseFormPage |

### 6.3 自定义转场 LoopPageTransition

全屏路由统一使用 `LoopPageTransition`(CustomTransitionPage),实现品牌化的进入动画:

| 属性 Attribute | 值 Value |
|-------------|---------|
| transitionDuration | 400ms |
| reverseTransitionDuration | 300ms |
| 正向曲线 Forward Curve | Curves.easeOutCubic |
| 反向曲线 Reverse Curve | Curves.easeInCubic |
| 动画组合 Combo | SlideTransition(Offset 0.08 -> 0) + FadeTransition(0 -> 1) |

转场通过 `_LoopTransition` Widget 组合实现:页面从右侧 8% 偏移滑入并同时淡入,营造轻量进入感。

### 6.4 边缘滑动切换 Tab Edge Swipe

`ScaffoldWithNavBar` 实现"左右边缘滑动切换底部 Tab",无需 setState 管理业务状态:

| 参数 Parameter | 值 Value | 说明 Description |
|-------------|---------|----------------|
| _edgeWidth | 28.0 px | 左右边缘识别热区宽度 |
| _minVelocity | 300.0 px/s | 触发切换的最小水平速度阈值 |
| 手势监听 Listener | PointerDown/Move/Up/Cancel | 通过 Listener 原生指针事件实现 |
| 速度计算 Velocity | VelocityTracker | 累积指针位置计算释放时速度 |

切换逻辑:

- 仅单指针(_activePointers == 1)时识别边缘起点
- 左边缘 + velocityX > 0(向右滑)+ 非首 Tab -> `goBranch(currentIndex - 1)`
- 右边缘 + velocityX < 0(向左滑)+ 非末 Tab -> `goBranch(currentIndex + 1)`
- 速度阈值过滤误触;再次点击当前 Tab 时 `initialLocation: true` 回到分支根

### 6.5 导航 API Navigation API

```dart
context.go('/home');              // 切换 Tab
context.push('/create-cycle');    // 全屏路由入栈
context.push('/edit-plan');       // 携带 extra
context.pop();                    // 返回上一页
```

---

## 7. 数据架构 Data Architecture

### 7.1 纯本地数据链 Pure Local Data Chain

Loop 是离线优先应用,数据链全程不触网:

```
┌──────────┐  watch/read   ┌────────────┐  调用     ┌──────────────┐
│   UI     │ ────────────▶ │  Provider  │ ────────▶ │  Repository  │
│ (Widget) │ ◀──────────── │ (Riverpod) │ ◀──────── │  (7 个仓库)  │
└──────────┘  状态推送      └────────────┘  返回      └──────┬───────┘
                                                              │ 委托
                                                              ▼
                                                   ┌────────────────────┐
                                                   │  AppDatabase (Drift)│
                                                   │  schemaVersion = 4  │
                                                   └──────────┬─────────┘
                                                              │ 原生
                                                              ▼
                                                   ┌────────────────────┐
                                                   │  SQLite 本地文件     │
                                                   │  (sqlite3_flutter   │
                                                   │   _libs)            │
                                                   └────────────────────┘
```

无网络层、无远程 API、无缓存层、无消息队列。所有读写直接落本地 SQLite。

### 7.2 数据库表 Database Tables

AppDatabase 注册 10 张表,schemaVersion = 4:

| 表 Table | 用途 Usage |
|---------|----------|
| Cycles | 周期(名称/起止日期/状态) |
| Tasks | 任务(目标量/完成量/分类/重复) |
| ProgressRecords | 任务进度记录明细 |
| CheckInRecords | 每日打卡记录 |
| Categories | 任务分类 |
| CycleSummaries | 周期总结 |
| PlanTemplates | 计划模板(dailyTargetAmount / enable_time_slot) |
| PlanInstances | 计划每日实例(completedAmount / isCompleted) |
| Timetables | 课表(学年/学期/首周周一/总周数/当前周) |
| TimetableCourses | 课表课程(星期/节次/周次范围) |

### 7.3 Drift 响应式查询 Drift Reactive Query

Drift 同时提供 `Future`(一次性)与 `Stream`(响应式)两种查询,前者用于 FutureProvider,后者用于 StreamProvider:

```dart
// 一次性查询 (AppDatabase)
Future<List<Task>> getTasksByCycle(String cycleId) =>
    (select(tasks)..where((t) => t.cycleId.equals(cycleId))).get();

// 响应式流查询 (AppDatabase)
Stream<List<Task>> watchTasksByCycle(String cycleId) =>
    (select(tasks)..where((t) => t.cycleId.equals(cycleId))).watch();
```

Stream 查询在底层数据变更时自动推送新快照,UI 订阅后无需手动刷新。Repository 层(`watchTasksByCycle`)透传该能力。

### 7.4 Repository 职责 Repository Responsibilities

7 个 Repository 是数据访问的唯一入口,职责包括:

- 封装单一领域的 CRUD,屏蔽 Drift 细节
- 生成 UUID 主键(`Uuid().v4()`)
- 实现领域校验(如 TaskRepository.addProgress 的 `clamp(0, targetAmount)` 与自动完成判定)
- 提供查询型 Future 与响应型 Stream 双形态

表现层与业务层禁止绕过 Repository 直接操作 AppDatabase。

### 7.5 数据导入导出 Import / Export

AppDatabase 内置 `exportToJson()`,将全部 10 表序列化为带 schemaVersion 与 exportedAt 的 JSON Map,供数据备份使用;同时提供 `clearAllData()` 按外键依赖顺序清空全部表。教务课表数据通过 TimetableHtmlParser 解析后,经 TimetableRepository.importCourses 批量入库。

---

## 8. UI 架构 UI Architecture

### 8.1 暗色主题 Dark Theme Only

Loop 仅提供暗色主题(`AppTheme.darkTheme`),无 lightTheme。app.dart 中 `theme: AppTheme.darkTheme` 固定使用:

| 主题维度 Dimension | 配置 Configuration |
|--------------|----------------|
| brightness | Brightness.dark |
| fontFamily | MiSans(品牌字体) |
| colorScheme | ColorScheme.dark(primary 青绿 / accent 青 / warmAccent 暖橘) |
| 背景层级 | backgroundDeep 0xFF0A0E1A -> background 0xFF0F1423 -> surface 0xFF161B2E -> card 0xFF1A2038 |
| 主色 Primary | 0xFF00E5A0(青绿) |
| 强调色 Accent | 0xFF00BCD4(青) |
| 暖强调色 | 0xFFFF6B4A(橘) |

系统 UI 样式(SystemChrome)同样配置为透明状态栏 + 暗色系统导航栏(0xFF0A0E1A),与主题融为一体。

### 8.2 色彩与渐变 Colors and Gradients

AppColors 定义完整的暗色色板与多组渐变:

| 渐变 Gradient | 色值 Colors | 用途 Usage |
|-------------|----------|----------|
| primaryGradient | 0xFF00E5A0 -> 0xFF00BCD4 | 主品牌渐变 |
| warmGradient | 0xFFFF6B4A -> 0xFFFFD54F | 暖色强调 |
| progressGradient | 0xFF00E5A0 -> 0xFF00BCD4 | 进度条 |
| glowPrimary / glowWarm | RadialGradient 发光 | 辉光效果 |

### 8.3 玻璃拟态 GlassCard

`GlassCard` 是全项目核心容器组件,实现玻璃拟态(Glassmorphism)视觉:

| 特性 Feature | 实现 Implementation |
|-----------|------------------|
| 背景模糊 BackdropFilter | ImageFilter.blur(sigmaX/Y, 默认 24) |
| 玻璃边框 | AppColors.glassBorder(0x30FFFFFF),宽度 0.5 |
| 按压反馈 | AnimatedScale 0.97,GestureDetector 监听 |
| 渐变背景 | surface/card 半透明对角渐变 |
| 角标高亮 | showCornerAccent 右上角青绿渐变 |
| Web 降级 | kIsWeb 时不做模糊(性能考虑) |

### 8.4 粒子背景 ParticleBackground

`ParticleBackground` 提供动态粒子背景:

| 特性 Feature | 实现 Implementation |
|-----------|------------------|
| 粒子数 particleCount | 默认 30 |
| 动画驱动 | AnimationController + SingleTickerProviderStateMixin,30s repeat |
| 随机种子 | Random(42) 固定种子,保证可复现 |
| 生命周期 | WidgetsBindingObserver 监听前后台切换 |

### 8.5 自定义底部导航 LoopBottomNav

`LoopBottomNav` 取代默认 BottomNavigationBar,实现品牌化导航:

| 特性 Feature | 实现 Implementation |
|-----------|------------------|
| 4 个 Tab | home / dailyPlan / statistics / settings |
| 选中高亮 | AnimatedContainer 圆形辉光(primary 12% 透明) |
| 图标切换 | AnimatedSwitcher + ValueKey(isSelected) |
| 文字动画 | AnimatedDefaultTextStyle(字号/字重/颜色过渡) |
| 容器样式 | surface 92% 透明 + 顶部玻璃边框 |

### 8.6 字体 Font

使用自定义品牌字体 MiSans(8 种字重 100-800),在 pubspec.yaml 与 ThemeData.fontFamily 中统一声明,通过 fonts/ttf 目录提供字形文件。

### 8.7 共享组件清单 Shared Widgets

| 组件 Widget | 职责 Responsibility |
|----------|-------------------|
| GlassCard | 玻璃拟态容器(模糊/渐变/按压反馈) |
| LoopBottomNav | 自定义底部导航 |
| ParticleBackground | 动态粒子背景 |
| LoopTimePicker | 时间选择器 |
| gradient_decorations | 渐变装饰 |
| animated_widgets | 通用动画组件 |

---

## 9. 国际化架构 Internationalization

### 9.1 支持语言 Supported Languages

Loop 支持 6 种语言:

| 语言 Language | 代码 Code | ARB 文件 ARB File |
|-------------|---------|-----------------|
| 中文(模板)Chinese | zh | app_zh.arb |
| 英文 English | en | app_en.arb |
| 德文 Deutsch | de | app_de.arb |
| 法文 Francais | fr | app_fr.arb |
| 日文 Japanese | ja | app_ja.arb |
| 韩文 Korean | ko | app_ko.arb |

### 9.2 配置 Configuration

l10n.yaml 配置如下:

| 配置项 Key | 值 Value |
|----------|---------|
| arb-dir | lib/l10n |
| template-arb-file | app_zh.arb(中文为模板语言) |
| output-localization-file | app_localizations.dart |
| output-class | S |
| output-dir | lib/l10n/generated |

### 9.3 访问方式 Access Pattern

通过生成类 `S` 访问本地化字符串:

```dart
// 在 Widget 中
final s = S.of(context)!;
Text(s.home);
Text(s.dailyPlan);

// MaterialApp.router 配置
MaterialApp.router(
  localizationsDelegates: S.localizationsDelegates,
  supportedLocales: S.supportedLocales,
  locale: locale,  // 来自 SettingsState.locale
);
```

### 9.4 语言切换 Locale Switching

语言由 `SettingsNotifier` 管理,用户在设置页切换语言后:

1. `updateLocale(locale)` 写入 SharedPreferences('locale')
2. 更新 SettingsState.locale
3. app.dart 中 `ref.watch(settingsProvider)` 读取新 locale 并传入 MaterialApp.router
4. 默认语言为中文(Locale('zh')),未设置时回退

---

## 10. 安全与可靠性 Security and Reliability

### 10.1 纯本地数据安全 Local-Only Security

Loop 作为纯本地应用,安全模型与企业级网络应用截然不同:

| 维度 Dimension | 策略 Strategy |
|-------------|-------------|
| 数据传输 | 无网络通信,不存在传输层泄露风险 |
| 数据存储 | 全部数据存放于应用沙箱内 SQLite 文件,受 Android 应用沙箱隔离保护 |
| 敏感权限 | 仅申请本地通知(flutter_local_notifications)与文件读取(课表导入)权限,按需申请 |
| 第三方数据 | 教务课表 HTML 仅在本地解析,解析结果存本地,不上传任何服务器 |

### 10.2 数据库迁移可靠性 Database Migration Reliability

Drift 的 MigrationStrategy 保证版本升级安全:

```
onUpgrade:
  from < 2  -> 创建 plan_templates / plan_instances 表
  from < 3  -> 创建 timetables / timetable_courses 表
  from < 4  -> ALTER TABLE plan_templates ADD COLUMN enable_time_slot
```

迁移采用增量式判断(`if (from < N)`),保证从任意旧版本逐步升级到最新 schemaVersion(4)而不会遗漏中间步骤或重复执行已完成的迁移。onCreate 直接 createAll 建立全部表。

### 10.3 数据完整性 Data Integrity

| 机制 Mechanism | 说明 Description |
|-------------|----------------|
| 主键约束 | 所有表 id 为 UUID(text 长度 36),Uuid().v4() 生成 |
| 外键引用 | Drift references 约束(如 Tasks.cycleId -> Cycles.id) |
| 完成量约束 | TaskRepository.addProgress 用 clamp(0, targetAmount) 防止越界 |
| 删除顺序 | deleteTimetable 先删子表(timetableCourses)再删主表,clearAllData 按依赖顺序清空 |
| 唯一打卡 | 每日唯一打卡由 getCheckInByDate 日期范围查询保障 |

### 10.4 状态一致性 State Consistency

Riverpod 的 `ref.invalidateSelf()` 机制保证状态一致性:Notifier 在完成数据写入后主动失效自身,触发依赖该 Provider 的查询型 Provider 重新求值,UI 自动获得最新数据,避免状态与数据库脱节。

---

**文档结束 End of Document**
