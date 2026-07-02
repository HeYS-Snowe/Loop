# 数据库设计说明书 Database Design Document

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 文档版本 Document Version | v2.0.0 |
| 创建日期 Created Date | 2026-03-16 |
| 最后修改 Last Modified | 2026-07-01 |
| 数据库设计师 DB Designer | Snowe |
| 项目名称 Project Name | Loop - 周期计划管理应用 |
| 应用版本 App Version | 0.0.17+17 |
| 数据库技术 Database Technology | Drift ^2.22.1 (SQLite ORM) + sqlite3_flutter_libs ^0.6.0+eol |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 审核人 Reviewer | 修改内容 Description |
|-------------|---------|---------------|---------------|-------------------|
| v1.0.0 | 2026-03-16 | Snowe | - | 初始版本，基于通用模板 v1.0.0 创建 |
| v2.0.0 | 2026-07-01 | Snowe | - | 同步实际 Drift/SQLite schema：覆盖重写全部内容，移除无关的 MySQL/Redis/MongoDB 电商示例，补充 10 张真实表的完整字段定义、迁移策略与查询方法 |

---

## 目录 Table of Contents

1. [概述 Overview](#1-概述-overview)
2. [数据库选型 Database Selection](#2-数据库选型-database-selection)
3. [设计原则 Design Principles](#3-设计原则-design-principles)
4. [数据库配置 Database Configuration](#4-数据库配置-database-configuration)
5. [数据表设计 Table Design](#5-数据表设计-table-design)
6. [表关系图 Entity-Relationship](#6-表关系图-entity-relationship)
7. [索引与查询 Index and Query](#7-索引与查询-index-and-query)
8. [数据安全 Data Security](#8-数据安全-data-security)

---

## 1. 概述 Overview

### 1.1 文档目的 Document Purpose

本文档定义 Loop 周期计划管理应用的本地数据库设计，包括表结构、字段约束、外键关系、迁移策略与查询方法，为数据库开发和维护提供依据。

### 1.2 数据库概述 Database Overview

Loop 是一款纯本地移动端应用，所有数据存储在设备本地，无服务端、无网络请求、无云同步。数据持久化基于 SQLite 嵌入式数据库，通过 Drift ORM 进行访问。

| 属性 Attribute | 内容 Content |
|-------------|-----------|
| 数据库类型 Database Type | SQLite (嵌入式本地数据库) |
| ORM 框架 ORM Framework | Drift ^2.22.1 |
| SQLite 驱动 SQLite Driver | sqlite3_flutter_libs ^0.6.0+eol |
| 数据库位置 Database Location | 应用沙箱内部存储 (由 path_provider 提供) |
| Schema 版本 Schema Version | 4 |
| 数据表数量 Table Count | 10 |
| 网络依赖 Network Dependency | 无 (纯离线) |
| 多用户支持 Multi-user | 否 (单用户，个人自用) |

---

## 2. 数据库选型 Database Selection

### 2.1 选型决策 Technology Decision

Loop 选择 Drift 作为本地持久化方案，而非 sqflite、Hive 或 shared_preferences。

| 候选方案 Candidate | 类型 Type | 是否采用 Adopted | 选型理由 Reason |
|-------------------|----------|---------------|---------------|
| Drift ^2.22.1 | 关系型 ORM (SQLite) | 是 | 类型安全的 Dart API；build_runner 代码生成；支持 Stream 响应式查询；迁移策略完善；与 Riverpod 配合良好 |
| sqflite | SQLite 原生插件 | 否 | 原始 SQL 字符串拼接，无类型安全；缺乏代码生成与查询构建器；手动映射繁琐 |
| Hive | 键值/对象存储 | 否 | 非关系型，不适合本项目的多表外键关联场景；无 SQL 查询能力 |
| shared_preferences | 轻量键值存储 | 是 (辅助) | 仅用于应用设置等简单配置，不承担核心业务数据存储 |
| Isar | 嵌入式 NoSQL | 否 | 对象数据库，查询能力强但生态较新，关系建模不如 Drift 直观 |

### 2.2 选型 Drift 的核心优势 Core Advantages

| 优势 Advantage | 说明 Description |
|--------------|---------------|
| 类型安全 Type Safety | 通过 Dart 代码定义表结构，编译期检查字段类型与约束，避免运行时 SQL 错误 |
| 代码生成 Code Generation | build_runner 自动生成 `_$AppDatabase`、`Task`、`TasksCompanion` 等类型，减少手写样板代码 |
| 响应式查询 Reactive Query | `watch()` 返回 `Stream<List<T>>`，数据变更自动推送，与 Riverpod StreamProvider 无缝集成 |
| 迁移管理 Migration | 内置 `MigrationStrategy`，支持 `onCreate` / `onUpgrade`，版本化 schema 演进 |
| 查询构建器 Query Builder | 链式 API (`select`/`where`/`orderBy`/`limit`)，类型安全且可读性高 |
| 跨平台 Cross-Platform | 支持 Android / iOS / Web，通过条件导入适配平台连接 |

---

## 3. 设计原则 Design Principles

### 3.1 命名规范 Naming Conventions

| 对象类型 Object Type | 命名规则 Naming Rule | 示例 Example |
|-------------------|-------------------|------------|
| 表 Table | snake_case 复数形式 | cycles, tasks, progress_records, plan_templates |
| 数据类 Data Class | PascalCase 单数形式 (由 `@DataClassName` 注解生成) | Cycle, Task, ProgressRecord, PlanTemplate |
| 字段 Column | camelCase (Dart 层) → snake_case (SQLite 层自动转换) | cycleId → cycle_id, completedAmount → completed_amount |
| 主键 Primary Key | 统一使用 `id` 字段，UUID v4 字符串 | id (TEXT, 长度 36) |
| 外键 Foreign Key | `{引用表单数}_id` 形式 | cycleId, taskId, planTemplateId, timetableId, categoryId |
| Drift 表类 Drift Table Class | PascalCase 复数形式 | Cycles, Tasks, PlanTemplates |

### 3.2 设计原则 Design Principles

| 原则 Principle | 说明 Description |
|--------------|---------------|
| 主键设计 Primary Key | 全表统一使用 UUID v4 (TEXT, 固定 36 字符) 作为主键，由 `uuid` 包生成，避免自增整数在同步/导入场景的冲突 |
| 时间字段 Timestamp | 使用 Drift `DateTimeColumn`，Dart 层为 `DateTime` 类型，SQLite 层存储为 Unix 时间戳；创建/更新时间默认 `currentDateAndTime` |
| 外键约束 Foreign Key | 通过 `.references(TargetTable, #primaryKeyColumn)` 声明，Drift 生成 SQLite FOREIGN KEY 约束 |
| 字段约束 Field Constraint | 使用 `.check()` 添加 CHECK 约束 (如 targetAmount > 0)、`.withLength()` 限制字符串长度、`.nullable()` 允许为空 |
| 软删除 Soft Delete | 本项目不使用软删除标记，数据删除为物理删除 (DELETE)，通过 Repository 层封装 |
| 数据类生成 Data Class | 每张表通过 `@DataClassName('Xxx')` 生成对应的不可变数据类，字段为 getter |
| 默认值 Default | 业务字段尽量设置合理默认值，如完成量默认 0、状态默认 active、排序默认 0 |

---

## 4. 数据库配置 Database Configuration

### 4.1 数据库定义 Database Definition

数据库通过 `@DriftDatabase` 注解声明，注册全部 10 张表。源文件位于 `loop_app/lib/data/database/app_database.dart`。

```dart
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
}
```

### 4.2 Schema 版本与迁移策略 Schema Version and Migration

当前 `schemaVersion = 4`。迁移策略通过 `MigrationStrategy` 定义，包含 `onCreate` 和 `onUpgrade` 两个回调。

| 版本 Version | 变更内容 Change Content | 影响表 Affected Tables |
|-------------|----------------------|----------------------|
| v1 | 初始建表，创建全部基础表 | Cycles, Tasks, ProgressRecords, CheckInRecords, Categories, CycleSummaries |
| v2 | 新增计划模块 | PlanTemplates, PlanInstances |
| v3 | 新增课表模块 | Timetables, TimetableCourses |
| v4 | 给计划模板表增加时段开关列 | PlanTemplates (新增 enable_time_slot 列) |

**onCreate (首次安装):**

```dart
onCreate: (Migrator m) async {
  await m.createAll();  // 创建全部 10 张表
}
```

**onUpgrade (版本升级):**

```dart
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
}
```

### 4.3 平台连接 Platform Connection

数据库连接通过条件导入 (Conditional Import) 适配不同平台，源文件为 `database_connection.dart` (Native)、`database_connection_web.dart` (Web)、`database_connection_stub.dart` (兜底)。

```dart
import 'database_connection_stub.dart'
    if (dart.library.io) 'database_connection.dart'
    if (dart.library.js_interop) 'database_connection_web.dart';
```

---

## 5. 数据表设计 Table Design

本章逐表列出全部 10 张表的完整字段定义。字段类型映射关系如下：

| Drift 列类型 Drift Column Type | Dart 类型 Dart Type | SQLite 存储类型 SQLite Storage Type |
|------------------------------|--------------------|--------------------|
| TextColumn | String | TEXT |
| IntColumn | int | INTEGER |
| RealColumn | double | REAL |
| BoolColumn | bool | INTEGER (0/1) |
| DateTimeColumn | DateTime | INTEGER (Unix 时间戳) |

---

### 5.1 cycles (周期表)

**用途**：存储周期计划的基本信息，包括名称、时间范围、状态等。

| 字段名 Field | Drift 类型 Drift Type | SQLite 类型 SQLite Type | 约束 Constraint | 默认值 Default | 说明 Description |
|------------|---------------------|----------------------|---------------|-------------|---------------|
| id | TextColumn | TEXT | NOT NULL, 长度 36, **PK** | - | 主键，UUID v4 |
| name | TextColumn | TEXT | NOT NULL, 最大长度 30 | - | 周期名称 |
| description | TextColumn | TEXT | nullable, 最大长度 200 | NULL | 周期描述 |
| startDate | DateTimeColumn | INTEGER | NOT NULL | - | 周期开始日期 |
| endDate | DateTimeColumn | INTEGER | NOT NULL | - | 周期结束日期 |
| status | TextColumn | TEXT | NOT NULL, 最大长度 20 | 'active' | 周期状态 (active/completed/archived) |
| isActive | BoolColumn | INTEGER | NOT NULL | true (1) | 是否为当前活跃周期 |
| createdAt | DateTimeColumn | INTEGER | NOT NULL | currentDateAndTime | 创建时间 |
| updatedAt | DateTimeColumn | INTEGER | NOT NULL | currentDateAndTime | 更新时间 |

- **主键**：id
- **外键**：无 (被 tasks、cycle_summaries 引用)

---

### 5.2 tasks (任务表)

**用途**：存储周期内的具体任务，记录目标量与完成量，支持分类与重复。

| 字段名 Field | Drift 类型 Drift Type | SQLite 类型 SQLite Type | 约束 Constraint | 默认值 Default | 说明 Description |
|------------|---------------------|----------------------|---------------|-------------|---------------|
| id | TextColumn | TEXT | NOT NULL, 长度 36, **PK** | - | 主键，UUID v4 |
| cycleId | TextColumn | TEXT | NOT NULL, 长度 36, **FK** | - | 所属周期 ID，引用 cycles.id |
| name | TextColumn | TEXT | NOT NULL, 最大长度 50 | - | 任务名称 |
| description | TextColumn | TEXT | nullable, 最大长度 200 | NULL | 任务描述 |
| targetAmount | IntColumn | INTEGER | NOT NULL, CHECK > 0 | - | 目标总量 (必须为正整数) |
| completedAmount | IntColumn | INTEGER | NOT NULL | 0 | 已完成量 |
| unit | TextColumn | TEXT | nullable, 最大长度 10 | NULL | 计量单位 (如 次/页/分钟) |
| categoryId | TextColumn | TEXT | nullable, 长度 36, **FK** | NULL | 任务分类 ID，引用 categories.id |
| isRepeatable | BoolColumn | INTEGER | NOT NULL | false (0) | 是否为可重复任务 |
| repeatType | TextColumn | TEXT | nullable, 最大长度 10 | NULL | 重复类型 (如 daily/weekly) |
| isCompleted | BoolColumn | INTEGER | NOT NULL | false (0) | 任务是否已完成 |
| createdAt | DateTimeColumn | INTEGER | NOT NULL | currentDateAndTime | 创建时间 |
| updatedAt | DateTimeColumn | INTEGER | NOT NULL | currentDateAndTime | 更新时间 |

- **主键**：id
- **外键**：cycleId → cycles.id；categoryId → categories.id
- **CHECK 约束**：targetAmount > 0

---

### 5.3 progress_records (进度记录表)

**用途**：记录任务每次进度追加的明细，用于追溯完成历史。

| 字段名 Field | Drift 类型 Drift Type | SQLite 类型 SQLite Type | 约束 Constraint | 默认值 Default | 说明 Description |
|------------|---------------------|----------------------|---------------|-------------|---------------|
| id | TextColumn | TEXT | NOT NULL, 长度 36, **PK** | - | 主键，UUID v4 |
| taskId | TextColumn | TEXT | NOT NULL, 长度 36, **FK** | - | 所属任务 ID，引用 tasks.id |
| date | DateTimeColumn | INTEGER | NOT NULL | - | 进度记录日期 |
| amount | IntColumn | INTEGER | NOT NULL, CHECK > 0 | - | 本次追加的完成量 (必须为正整数) |
| note | TextColumn | TEXT | nullable, 最大长度 200 | NULL | 备注 |
| createdAt | DateTimeColumn | INTEGER | NOT NULL | currentDateAndTime | 创建时间 |

- **主键**：id
- **外键**：taskId → tasks.id
- **CHECK 约束**：amount > 0

---

### 5.4 check_in_records (打卡记录表)

**用途**：记录每日打卡信息及连续打卡天数 (streak)，用于习惯养成追踪。

| 字段名 Field | Drift 类型 Drift Type | SQLite 类型 SQLite Type | 约束 Constraint | 默认值 Default | 说明 Description |
|------------|---------------------|----------------------|---------------|-------------|---------------|
| id | TextColumn | TEXT | NOT NULL, 长度 36, **PK** | - | 主键，UUID v4 |
| date | DateTimeColumn | INTEGER | NOT NULL | - | 打卡日期 (每天仅允许一次打卡) |
| streakCount | IntColumn | INTEGER | NOT NULL | 1 | 连续打卡天数 |
| note | TextColumn | TEXT | nullable, 最大长度 200 | NULL | 打卡备注 |
| createdAt | DateTimeColumn | INTEGER | NOT NULL | currentDateAndTime | 创建时间 |

- **主键**：id
- **外键**：无 (独立表)
- **业务约束**：每天仅允许一条打卡记录 (由业务层 `getCheckInByDate` 校验)

---

### 5.5 categories (分类表)

**用途**：存储任务和计划的分类标签，支持颜色标识与排序。

| 字段名 Field | Drift 类型 Drift Type | SQLite 类型 SQLite Type | 约束 Constraint | 默认值 Default | 说明 Description |
|------------|---------------------|----------------------|---------------|-------------|---------------|
| id | TextColumn | TEXT | NOT NULL, 长度 36, **PK** | - | 主键，UUID v4 |
| name | TextColumn | TEXT | NOT NULL, 最大长度 20 | - | 分类名称 |
| color | IntColumn | INTEGER | NOT NULL | 0xFF2196F3 | 分类颜色 (ARGB 整数值，默认蓝色) |
| sortOrder | IntColumn | INTEGER | NOT NULL | 0 | 排序序号 (升序) |
| createdAt | DateTimeColumn | INTEGER | NOT NULL | currentDateAndTime | 创建时间 |

- **主键**：id
- **外键**：无 (被 tasks.categoryId、plan_templates.categoryId 引用)

---

### 5.6 cycle_summaries (周期总结表)

**用途**：存储周期结束时的统计数据，包括完成率、任务数、打卡数、最大连续天数等。

| 字段名 Field | Drift 类型 Drift Type | SQLite 类型 SQLite Type | 约束 Constraint | 默认值 Default | 说明 Description |
|------------|---------------------|----------------------|---------------|-------------|---------------|
| id | TextColumn | TEXT | NOT NULL, 长度 36, **PK** | - | 主键，UUID v4 |
| cycleId | TextColumn | TEXT | NOT NULL, 长度 36, **FK** | - | 所属周期 ID，引用 cycles.id |
| completionRate | RealColumn | REAL | NOT NULL | - | 任务完成率 (0.0 ~ 1.0) |
| totalTasks | IntColumn | INTEGER | NOT NULL | - | 周期内任务总数 |
| completedTasks | IntColumn | INTEGER | NOT NULL | - | 已完成任务数 |
| totalCheckIns | IntColumn | INTEGER | NOT NULL | - | 周期内打卡总次数 |
| maxStreak | IntColumn | INTEGER | NOT NULL | - | 周期内最大连续打卡天数 |
| summary | TextColumn | TEXT | nullable | NULL | 文字总结内容 |
| createdAt | DateTimeColumn | INTEGER | NOT NULL | currentDateAndTime | 创建时间 |

- **主键**：id
- **外键**：cycleId → cycles.id

---

### 5.7 plan_templates (计划模板表)

**用途**：存储每日计划的模板定义，包含重复规则、时段配置、目标量等，是计划模块的核心配置表。

| 字段名 Field | Drift 类型 Drift Type | SQLite 类型 SQLite Type | 约束 Constraint | 默认值 Default | 说明 Description |
|------------|---------------------|----------------------|---------------|-------------|---------------|
| id | TextColumn | TEXT | NOT NULL, 长度 36, **PK** | - | 主键，UUID v4 |
| name | TextColumn | TEXT | NOT NULL, 最大长度 50 | - | 计划名称 |
| description | TextColumn | TEXT | nullable, 最大长度 200 | NULL | 计划描述 |
| categoryId | TextColumn | TEXT | nullable, 长度 36, **FK** | NULL | 计划分类 ID，引用 categories.id |
| dailyTargetAmount | IntColumn | INTEGER | NOT NULL | 0 | 每日目标量 |
| unit | TextColumn | TEXT | nullable, 最大长度 20 | NULL | 计量单位 |
| enableQuantityTracking | BoolColumn | INTEGER | NOT NULL | true (1) | 是否启用数量追踪 |
| repeatType | TextColumn | TEXT | NOT NULL, 最大长度 20 | 'none' | 重复类型 (none/daily/weekly/monthly) |
| repeatInterval | IntColumn | INTEGER | NOT NULL | 1 | 重复间隔 (每 N 天/周/月) |
| activeDays | TextColumn | TEXT | NOT NULL | '1,2,3,4,5,6,7' | 生效星期 (逗号分隔，1=周一 ... 7=周日) |
| startHour | IntColumn | INTEGER | NOT NULL | 8 | 时段开始小时 (0-23) |
| startMinute | IntColumn | INTEGER | NOT NULL | 0 | 时段开始分钟 (0-59) |
| endHour | IntColumn | INTEGER | NOT NULL | 9 | 时段结束小时 (0-23) |
| endMinute | IntColumn | INTEGER | NOT NULL | 0 | 时段结束分钟 (0-59) |
| colorValue | IntColumn | INTEGER | NOT NULL | 0xFF2196F3 | 计划颜色 (ARGB 整数值，默认蓝色) |
| enableTimeSlot | BoolColumn | INTEGER | NOT NULL | true (1) | 是否启用时段限制 (v4 新增列) |
| isActive | BoolColumn | INTEGER | NOT NULL | true (1) | 模板是否启用 |
| startDate | DateTimeColumn | INTEGER | NOT NULL | - | 模板生效开始日期 |
| endDate | DateTimeColumn | INTEGER | nullable | NULL | 模板生效结束日期 (NULL 表示无截止) |
| sortOrder | IntColumn | INTEGER | NOT NULL | 0 | 排序序号 (升序) |
| createdAt | DateTimeColumn | INTEGER | NOT NULL | currentDateAndTime | 创建时间 |
| updatedAt | DateTimeColumn | INTEGER | NOT NULL | currentDateAndTime | 更新时间 |

- **主键**：id
- **外键**：categoryId → categories.id
- **版本说明**：`enable_time_slot` 列由 schema v4 通过 `ALTER TABLE` 新增

---

### 5.8 plan_instances (计划实例表)

**用途**：存储基于计划模板生成的每日具体实例，记录当天的目标量与实际完成量。

| 字段名 Field | Drift 类型 Drift Type | SQLite 类型 SQLite Type | 约束 Constraint | 默认值 Default | 说明 Description |
|------------|---------------------|----------------------|---------------|-------------|---------------|
| id | TextColumn | TEXT | NOT NULL, 长度 36, **PK** | - | 主键，UUID v4 |
| planTemplateId | TextColumn | TEXT | NOT NULL, 长度 36, **FK** | - | 所属计划模板 ID，引用 plan_templates.id |
| date | DateTimeColumn | INTEGER | NOT NULL | - | 实例日期 (该计划实例对应的日期) |
| targetAmount | IntColumn | INTEGER | NOT NULL | 0 | 当日目标量 |
| completedAmount | IntColumn | INTEGER | NOT NULL | 0 | 当日已完成量 |
| isCompleted | BoolColumn | INTEGER | NOT NULL | false (0) | 当日是否已完成 |
| note | TextColumn | TEXT | nullable, 最大长度 500 | NULL | 当日备注 |
| createdAt | DateTimeColumn | INTEGER | NOT NULL | currentDateAndTime | 创建时间 |
| updatedAt | DateTimeColumn | INTEGER | NOT NULL | currentDateAndTime | 更新时间 |

- **主键**：id
- **外键**：planTemplateId → plan_templates.id

---

### 5.9 timetables (课表表)

**用途**：存储教务课表的元信息，支持学期、周次、起始周等配置，可通过教务系统 HTML 智能导入。

| 字段名 Field | Drift 类型 Drift Type | SQLite 类型 SQLite Type | 约束 Constraint | 默认值 Default | 说明 Description |
|------------|---------------------|----------------------|---------------|-------------|---------------|
| id | TextColumn | TEXT | NOT NULL, 长度 36, **PK** | - | 主键，UUID v4 |
| name | TextColumn | TEXT | NOT NULL, 最大长度 50 | - | 课表名称 |
| academicYear | IntColumn | INTEGER | NOT NULL | - | 学年 (如 2026) |
| semester | IntColumn | INTEGER | NOT NULL | - | 学期 (1 或 2) |
| firstWeekMonday | DateTimeColumn | INTEGER | NOT NULL | - | 第一周周一的日期 (周次计算基准) |
| totalWeeks | IntColumn | INTEGER | NOT NULL | 20 | 总周数 |
| currentWeek | IntColumn | INTEGER | NOT NULL | 1 | 当前周次 |
| source | TextColumn | TEXT | nullable, 最大长度 20 | NULL | 数据来源 (如 manual/import) |
| createdAt | DateTimeColumn | INTEGER | NOT NULL | currentDateAndTime | 创建时间 |
| updatedAt | DateTimeColumn | INTEGER | NOT NULL | currentDateAndTime | 更新时间 |

- **主键**：id
- **外键**：无 (被 timetable_courses.timetableId 引用)

---

### 5.10 timetable_courses (课表课程表)

**用途**：存储课表中的具体课程信息，包括课程名、教师、地点、上课节次、生效周次等。

| 字段名 Field | Drift 类型 Drift Type | SQLite 类型 SQLite Type | 约束 Constraint | 默认值 Default | 说明 Description |
|------------|---------------------|----------------------|---------------|-------------|---------------|
| id | TextColumn | TEXT | NOT NULL, 长度 36, **PK** | - | 主键，UUID v4 |
| timetableId | TextColumn | TEXT | NOT NULL, 长度 36, **FK** | - | 所属课表 ID，引用 timetables.id |
| courseName | TextColumn | TEXT | NOT NULL, 最大长度 100 | - | 课程名称 |
| teacherName | TextColumn | TEXT | nullable, 最大长度 50 | NULL | 授课教师姓名 |
| location | TextColumn | TEXT | nullable, 最大长度 100 | NULL | 上课地点 (教室) |
| weekday | IntColumn | INTEGER | NOT NULL, CHECK 1-7 | - | 星期几 (1=周一 ... 7=周日) |
| startPeriod | IntColumn | INTEGER | NOT NULL, CHECK >= 1 | - | 开始节次 |
| endPeriod | IntColumn | INTEGER | NOT NULL, CHECK >= 1 | - | 结束节次 |
| weekRanges | TextColumn | TEXT | NOT NULL, 最大长度 200 | - | 生效周次范围 (如 "1-16" 或 "1,3,5,7-15") |
| colorHex | TextColumn | TEXT | nullable, 最大长度 7 | NULL | 课程颜色 (十六进制，如 "#FF5722") |
| createdAt | DateTimeColumn | INTEGER | NOT NULL | currentDateAndTime | 创建时间 |
| updatedAt | DateTimeColumn | INTEGER | NOT NULL | currentDateAndTime | 更新时间 |

- **主键**：id
- **外键**：timetableId → timetables.id
- **CHECK 约束**：weekday 介于 1-7；startPeriod >= 1；endPeriod >= 1

---

## 6. 表关系图 Entity-Relationship

### 6.1 关系总览 Relationship Overview

Loop 数据库共 10 张表，形成以 cycles 为核心的周期任务体系、以 plan_templates 为核心的计划体系、以 timetables 为核心的课表体系，三类通过 categories 分类表松耦合关联。

```
                         ┌──────────────┐
                         │  categories  │
                         │  (分类表)     │
                         └──────┬───────┘
                          ▲     ▲     ▲
                          │     │     │
              ┌───────────┘     │     └───────────┐
              │                 │                 │
┌─────────────┴──────┐  ┌───────┴────────┐  ┌─────┴──────────┐
│      cycles        │  │ plan_templates │  │    tasks        │
│    (周期表)         │  │  (计划模板表)   │  │   (任务表)      │
│  PK id             │  │  PK id         │  │  PK id          │
└────────┬───────────┘  └────────┬───────┘  └────────┬────────┘
         │ 1                     │ 1                 │ 1
         │                       │                   │
         ├─────── N ─────────────┼───────────────────┤
         │                       │                   │
         ▼                       ▼                   ▼
┌─────────────────┐    ┌──────────────────┐  ┌──────────────────┐
│ cycle_summaries │    │  plan_instances  │  │ progress_records │
│  (周期总结表)     │    │   (计划实例表)    │  │  (进度记录表)     │
│  PK id          │    │  PK id           │  │  PK id           │
│  FK cycleId     │    │  FK planTemplateId│  │  FK taskId       │
└─────────────────┘    └──────────────────┘  └──────────────────┘


┌──────────────┐         ┌───────────────────┐
│  timetables  │  1 ── N │ timetable_courses  │
│  (课表表)     │────────│   (课表课程表)      │
│  PK id       │         │   PK id            │
└──────────────┘         │   FK timetableId   │
                         └───────────────────┘

┌──────────────────┐
│ check_in_records │  (独立表，无外键)
│  (打卡记录表)     │
│  PK id           │
└──────────────────┘
```

### 6.2 关系明细 Relationship Details

| 关系 Relationship | 基数 Cardinality | 说明 Description |
|-----------------|----------------|---------------|
| cycles → tasks | 1 : N | 一个周期包含多个任务，tasks.cycleId 引用 cycles.id |
| cycles → cycle_summaries | 1 : 1 | 一个周期对应一条总结记录 (业务层保证)，cycle_summaries.cycleId 引用 cycles.id |
| tasks → progress_records | 1 : N | 一个任务有多条进度记录，progress_records.taskId 引用 tasks.id |
| categories → tasks | 1 : N | 一个分类下可有多个任务 (可选关联)，tasks.categoryId 引用 categories.id |
| categories → plan_templates | 1 : N | 一个分类下可有多个计划模板 (可选关联)，plan_templates.categoryId 引用 categories.id |
| plan_templates → plan_instances | 1 : N | 一个模板生成多个每日实例，plan_instances.planTemplateId 引用 plan_templates.id |
| timetables → timetable_courses | 1 : N | 一个课表包含多门课程，timetable_courses.timetableId 引用 timetables.id |
| check_in_records | 独立 | 打卡记录表，无外键关联，按日期独立存储 |

---

## 7. 索引与查询 Index and Query

### 7.1 索引策略 Index Strategy

Drift 自动为主键创建索引。对于外键字段和高频查询字段，通过 Drift 查询构建器的 `where` 条件进行过滤。由于本项目为单用户本地应用，数据量有限，未显式创建额外索引，依赖 SQLite 主键索引即可满足性能需求。

| 索引类型 Index Type | 字段 Field | 说明 Description |
|------------------|----------|---------------|
| 主键索引 Primary Key | 各表 id | 全表主键自动索引 |
| 查询过滤 Query Filter | tasks.cycleId | 按周期查询任务 (getTasksByCycle) |
| 查询过滤 Query Filter | progress_records.taskId | 按任务查询进度 (getProgressByTask) |
| 查询过滤 Query Filter | plan_instances.planTemplateId | 按模板查询实例 |
| 查询过滤 Query Filter | timetable_courses.timetableId | 按课表查询课程 (getCoursesByTimetable) |
| 查询过滤 Query Filter | check_in_records.date | 按日期查询打卡 (getCheckInByDate) |
| 排序 Order By | categories.sortOrder | 分类按序号升序排列 |
| 排序 Order By | plan_templates.sortOrder | 计划模板按序号升序排列 |
| 排序 Order By | check_in_records.date DESC | 打卡记录按日期降序排列 |

### 7.2 Drift 查询模式 Query Patterns

Drift 提供类型安全的链式查询 API，支持 `select` / `update` / `insert` / `delete` 四类操作，以及 `watch()` 响应式流查询。

**一次性查询 (Future)：**

```dart
// 查询指定周期的全部任务
Future<List<Task>> getTasksByCycle(String cycleId) {
  return (select(tasks)..where((t) => t.cycleId.equals(cycleId))).get();
}

// 查询单条记录
Future<Cycle?> getCycleById(String id) {
  return (select(cycles)..where((c) => c.id.equals(id))).getSingleOrNull();
}
```

**响应式流查询 (Stream) - 与 Riverpod StreamProvider 集成：**

```dart
// 监听任务变化，数据变更自动推送
Stream<List<Task>> watchTasksByCycle(String cycleId) {
  return (select(tasks)..where((t) => t.cycleId.equals(cycleId))).watch();
}

// 监听打卡记录 (按日期降序)
Stream<List<CheckInRecord>> watchAllCheckIns() {
  return (select(checkInRecords)..orderBy([(t) => OrderingTerm.desc(t.date)]))
      .watch();
}
```

**插入与更新：**

```dart
// 插入记录
Future<String> insertCycle(CyclesCompanion cycle) async {
  await into(cycles).insert(cycle);
  return cycle.id.value;
}

// 更新记录
Future<void> updateTaskProgress(String taskId, int amount) async {
  await (update(tasks)..where((t) => t.id.equals(taskId))).write(
    TasksCompanion(
      completedAmount: Value(amount),
      updatedAt: Value(DateTime.now()),
    ),
  );
}
```

**批量插入：**

```dart
// 批量插入课程
Future<void> insertCourses(List<TimetableCoursesCompanion> courses) async {
  await batch((b) {
    b.insertAll(timetableCourses, courses);
  });
}
```

### 7.3 关键查询方法清单 Key Query Methods

以下为 `app_database.dart` 中定义的全部查询方法：

| 模块 Module | 方法名 Method | 返回类型 Return Type | 说明 Description |
|------------|-------------|--------------------|---------------|
| Cycle | getAllCycles | Future\<List\<Cycle\>\> | 获取全部周期 |
| Cycle | watchAllCycles | Stream\<List\<Cycle\>\> | 监听全部周期 (响应式) |
| Cycle | getCycleById | Future\<Cycle?\> | 按 ID 获取周期 |
| Cycle | getActiveCycle | Future\<Cycle?\> | 获取当前活跃周期 (status='active') |
| Cycle | insertCycle | Future\<String\> | 插入周期，返回 ID |
| Cycle | updateCycle | Future\<void\> | 更新周期 |
| Cycle | deleteCycle | Future\<void\> | 删除周期 |
| Task | getTasksByCycle | Future\<List\<Task\>\> | 获取指定周期的全部任务 |
| Task | watchTasksByCycle | Stream\<List\<Task\>\> | 监听指定周期的任务 (响应式) |
| Task | getTaskById | Future\<Task?\> | 按 ID 获取任务 |
| Task | insertTask | Future\<String\> | 插入任务，返回 ID |
| Task | updateTask | Future\<void\> | 更新任务 |
| Task | updateTaskProgress | Future\<void\> | 更新任务完成进度 |
| Task | deleteTask | Future\<void\> | 删除任务 |
| Progress | getProgressByTask | Future\<List\<ProgressRecord\>\> | 获取指定任务的进度记录 |
| Progress | insertProgressRecord | Future\<String\> | 插入进度记录，返回 ID |
| CheckIn | getAllCheckIns | Future\<List\<CheckInRecord\>\> | 获取全部打卡记录 (按日期降序) |
| CheckIn | watchAllCheckIns | Stream\<List\<CheckInRecord\>\> | 监听全部打卡记录 (响应式) |
| CheckIn | getCheckInByDate | Future\<CheckInRecord?\> | 按日期获取打卡记录 |
| CheckIn | getLastCheckIn | Future\<CheckInRecord?\> | 获取最近一次打卡记录 |
| CheckIn | insertCheckIn | Future\<String\> | 插入打卡记录，返回 ID |
| Category | getAllCategories | Future\<List\<Category\>\> | 获取全部分类 (按 sortOrder 升序) |
| Category | watchAllCategories | Stream\<List\<Category\>\> | 监听全部分类 (响应式) |
| Category | insertCategory | Future\<String\> | 插入分类，返回 ID |
| Category | deleteCategory | Future\<void\> | 删除分类 |
| Summary | getSummaryByCycle | Future\<CycleSummary?\> | 按周期获取总结 |
| Summary | insertCycleSummary | Future\<String\> | 插入周期总结，返回 ID |
| PlanTemplate | getAllPlanTemplates | Future\<List\<PlanTemplate\>\> | 获取全部计划模板 (按 sortOrder 升序) |
| PlanTemplate | watchAllPlanTemplates | Stream\<List\<PlanTemplate\>\> | 监听全部计划模板 (响应式) |
| PlanTemplate | getPlanTemplateById | Future\<PlanTemplate?\> | 按 ID 获取计划模板 |
| Timetable | getAllTimetables | Future\<List\<Timetable\>\> | 获取全部课表 |
| Timetable | watchAllTimetables | Stream\<List\<Timetable\>\> | 监听全部课表 (响应式) |
| Timetable | getTimetableById | Future\<Timetable?\> | 按 ID 获取课表 |
| Timetable | getActiveTimetable | Future\<Timetable?\> | 获取当前课表 (第一条) |
| Timetable | insertTimetable | Future\<String\> | 插入课表，返回 ID |
| Timetable | updateTimetable | Future\<void\> | 更新课表 |
| Timetable | deleteTimetable | Future\<void\> | 删除课表 (级联删除关联课程) |
| Course | getCoursesByTimetable | Future\<List\<TimetableCourse\>\> | 获取指定课表的全部课程 |
| Course | watchCoursesByTimetable | Stream\<List\<TimetableCourse\>\> | 监听指定课表的课程 (响应式) |
| Course | getCoursesByWeekday | Future\<List\<TimetableCourse\>\> | 按星期获取课程 |
| Course | insertCourse | Future\<String\> | 插入单条课程，返回 ID |
| Course | insertCourses | Future\<void\> | 批量插入课程 |
| Course | updateCourse | Future\<void\> | 更新课程 |
| Course | deleteCourse | Future\<void\> | 删除课程 |
| Data | clearAllData | Future\<void\> | 清空全部数据 (按外键依赖顺序删除) |
| Data | exportToJson | Future\<Map\<String, dynamic\>\> | 导出全部数据为 JSON |

---

## 8. 数据安全 Data Security

### 8.1 数据存储特性 Storage Characteristics

| 特性 Characteristic | 说明 Description |
|------------------|---------------|
| 存储位置 Storage Location | 应用沙箱内部存储，其他应用无法直接访问 |
| 网络传输 Network Transfer | 无，数据永不离开设备 |
| 服务端同步 Server Sync | 无，纯本地应用 |
| 用户账户 User Account | 无，单用户个人应用，无需登录 |
| 敏感数据 Sensitive Data | 不收集身份证、银行卡等敏感信息；数据均为用户自填的计划/任务/课表内容 |

### 8.2 数据清理 Data Clearing

通过 `clearAllData()` 方法提供一键清空功能，按外键依赖顺序依次删除各表数据，避免违反外键约束：

```dart
Future<void> clearAllData() async {
  await delete(planInstances).go();
  await delete(planTemplates).go();
  await delete(timetableCourses).go();
  await delete(timetables).go();
  await delete(progressRecords).go();
  await delete(tasks).go();
  await delete(checkInRecords).go();
  await delete(cycleSummaries).go();
  await delete(cycles).go();
  await delete(categories).go();
}
```

删除顺序遵循依赖关系：先删除子表 (引用方)，再删除父表 (被引用方)。

### 8.3 数据导出 Data Export

通过 `exportToJson()` 方法支持全量数据导出为 JSON 格式，包含 schema 版本号和导出时间戳，可用于数据备份或迁移：

```dart
Future<Map<String, dynamic>> exportToJson() async {
  return {
    'schemaVersion': schemaVersion,
    'exportedAt': DateTime.now().toIso8601String(),
    'cycles': ...,
    'tasks': ...,
    'checkInRecords': ...,
    'categories': ...,
    'cycleSummaries': ...,
    'planTemplates': ...,
    'planInstances': ...,
    'timetables': ...,
    'timetableCourses': ...,
  };
}
```

### 8.4 安全建议 Security Recommendations

| 项目 Item | 现状 Status | 建议 Recommendation |
|----------|-----------|-------------------|
| 数据库文件加密 Database Encryption | 未加密 | 当前为个人自用 Alpha 版本，数据敏感度低；后续如需增强可引入 SQLCipher |
| 卸载数据清除 Data on Uninstall | 由系统保证 | Android 卸载应用时自动清除沙箱内数据库文件 |
| 备份安全 Backup Security | 导出 JSON 明文 | 导出文件由用户自行保管，建议存放在安全位置 |

---

## 附录 Appendix

### 附录 A：数据表清单 Table List

| 序号 # | 表名 Table | 中文名 CN | 用途 Usage | 引入版本 Introduced |
|-------|----------|---------|----------|------------------|
| 1 | cycles | 周期表 | 存储周期计划基本信息 | v1 |
| 2 | tasks | 任务表 | 存储周期内任务 | v1 |
| 3 | progress_records | 进度记录表 | 记录任务进度追加明细 | v1 |
| 4 | check_in_records | 打卡记录表 | 记录每日打卡与连续天数 | v1 |
| 5 | categories | 分类表 | 任务/计划分类标签 | v1 |
| 6 | cycle_summaries | 周期总结表 | 存储周期结束统计数据 | v1 |
| 7 | plan_templates | 计划模板表 | 存储每日计划模板配置 | v2 |
| 8 | plan_instances | 计划实例表 | 存储计划每日生成实例 | v2 |
| 9 | timetables | 课表表 | 存储教务课表元信息 | v3 |
| 10 | timetable_courses | 课表课程表 | 存储课表具体课程 | v3 |

### 附录 B：源文件索引 Source File Index

| 文件 File | 路径 Path | 说明 Description |
|----------|---------|---------------|
| 数据库主文件 Database Main | `loop_app/lib/data/database/app_database.dart` | schema 定义、迁移策略、查询方法 |
| Cycles 表 | `loop_app/lib/data/database/tables/cycles.dart` | 周期表定义 |
| Tasks 表 | `loop_app/lib/data/database/tables/tasks.dart` | 任务表定义 |
| ProgressRecords 表 | `loop_app/lib/data/database/tables/progress_records.dart` | 进度记录表定义 |
| CheckInRecords 表 | `loop_app/lib/data/database/tables/check_in_records.dart` | 打卡记录表定义 |
| Categories 表 | `loop_app/lib/data/database/tables/categories.dart` | 分类表定义 |
| CycleSummaries 表 | `loop_app/lib/data/database/tables/cycle_summaries.dart` | 周期总结表定义 |
| PlanTemplates 表 | `loop_app/lib/data/database/tables/plan_templates.dart` | 计划模板表定义 |
| PlanInstances 表 | `loop_app/lib/data/database/tables/plan_instances.dart` | 计划实例表定义 |
| Timetables 表 | `loop_app/lib/data/database/tables/timetables.dart` | 课表表定义 |
| TimetableCourses 表 | `loop_app/lib/data/database/tables/timetable_courses.dart` | 课表课程表定义 |
| 生成文件 Generated | `loop_app/lib/data/database/app_database.g.dart` | build_runner 生成的类型与查询实现 |

---

**文档结束 End of Document**
