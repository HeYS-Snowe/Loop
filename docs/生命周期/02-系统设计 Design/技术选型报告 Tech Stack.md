# 技术选型报告 Technology Selection Report

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 文档版本 Document Version | v1.0.0 |
| 创建日期 Created Date | 2026-03-16 |
| 最后修改 Last Modified | 2026-03-16 |
| 技术负责人 Tech Lead | Snowe |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 审核人 Reviewer | 修改内容 Description |
|-------------|---------|---------------|---------------|-------------------|
| v1.0.0 | 2026-03-16 | Snowe | | 初始版本 Initial Version |

---

## 目录 Table of Contents

1. [选型概述 Selection Overview](#1-选型概述-selection-overview)
2. [选型原则 Selection Principles](#2-选型原则-selection-principles)
3. [移动端技术选型 Mobile Selection](#3-移动端技术选型-mobile-selection)
4. [数据存储选型 Data Storage Selection](#4-数据存储选型-data-storage-selection)
5. [第三方库选型 Third-Party Libraries](#5-第三方库选型-third-party-libraries)
6. [开发工具选型 Development Tools](#6-开发工具选型-development-tools)
7. [选型汇总 Selection Summary](#7-选型汇总-selection-summary)

---

## 1. 选型概述 Selection Overview

### 1.1 选型目标 Selection Goals

| 目标维度 Goal Dimension | 说明 Description |
|---------------------|---------------|
| 业务匹配 Business Fit | 满足周期计划管理App的所有功能需求 |
| 团队能力 Team Capability | 学习曲线可控，适合个人开发者 |
| 成本控制 Cost | 零成本开发，使用开源/免费工具 |
| 生态支持 Ecosystem | Flutter社区活跃，文档完善，第三方库丰富 |
| 稳定性 Stability | Flutter框架成熟稳定，Google官方维护 |

### 1.2 选型流程 Selection Process

```
需求分析 → 方案调研 → 对比评估 → PoC验证 → 决策落地
   │          │          │         │         │
需求文档   调研报告   评分矩阵   验证报告   决策文档
```

### 1.3 项目技术需求 Project Technical Requirements

| 需求类型 Requirement Type | 具体需求 Specific Requirement |
|------------------------|---------------------------|
| 平台 Platform | Android (v1.0)，后续可扩展iOS |
| 数据存储 Data Storage | 本地数据库，支持离线使用 |
| UI框架 UI Framework | Material Design风格 |
| 通知系统 Notification | 本地通知提醒 |
| 状态管理 State Management | 响应式状态管理 |

---

## 2. 选型原则 Selection Principles

### 2.1 评估维度 Evaluation Dimensions

| 维度 Dimension | 权重 Weight | 说明 Description |
|--------------|-----------|---------------|
| 功能性 Functionality | 30% | 是否满足功能需求 |
| 学习成本 Learning Curve | 25% | 团队上手难度 |
| 生态社区 Ecosystem | 20% | 社区活跃度、文档质量 |
| 性能 Performance | 15% | 运行性能表现 |
| 成本 Cost | 10% | 开发和维护成本 |

### 2.2 评分标准 Scoring Criteria

| 分数 Score | 评价 Evaluation |
|----------|--------------|
| 5分 Excellent | 完全满足，表现优异 |
| 4分 Good | 满足需求，表现良好 |
| 3分 Average | 基本满足，表现一般 |
| 2分 Fair | 部分满足，存在不足 |
| 1分 Poor | 不满足需求 |

---

## 3. 移动端技术选型 Mobile Selection

### 3.1 跨平台框架对比 Cross-Platform Framework Comparison

| 对比项 Comparison | Flutter | React Native | 原生开发(Kotlin) |
|-----------------|---------|-------------|----------------|
| **功能性 Functionality (30%)** | | | |
| UI组件 UI Components | 5 | 4 | 5 |
| 性能表现 Performance | 5 | 4 | 5 |
| 原生能力 Native Access | 4 | 4 | 5 |
| **学习成本 Learning Curve (25%)** | | | |
| 语言熟悉度 Language Familiarity | 4(Dart类似JS) | 5(React) | 3(Kotlin) |
| 框架复杂度 Framework Complexity | 4 | 3 | 4 |
| 文档质量 Documentation | 5 | 4 | 4 |
| **生态社区 Ecosystem (20%)** | | | |
| 社区活跃度 Activity | 5 | 5 | 4 |
| 第三方库 Libraries | 4 | 5 | 4 |
| 官方支持 Official Support | 5(Google) | 5(Meta) | 5(Google) |
| **性能 Performance (15%)** | | | |
| 运行时性能 Runtime | 5 | 4 | 5 |
| 包体积 Bundle Size | 3 | 4 | 5 |
| **成本 Cost (10%)** | | | |
| 开发效率 Development Speed | 5 | 4 | 3 |
| 跨平台能力 Cross-Platform | 5 | 5 | 2 |
| **加权总分 Weighted Total** | **4.55** | **4.25** | **4.05** |

**选择结果 Decision:** **Flutter**

### 3.2 选择Flutter的理由 Rationale for Flutter

| 理由 Rationale | 详细说明 Description |
|--------------|-------------------|
| 高性能 | Skia渲染引擎，接近原生性能 |
| 热重载 | Hot Reload提升开发效率 |
| 统一UI | 一套代码，iOS/Android一致体验 |
| 丰富的Widget | Material Design和Cupertino组件丰富 |
| Dart语言 | 类型安全，异步支持好，语法简洁 |
| 学习价值 | Flutter技能市场需求大 |

### 3.3 Flutter版本选择 Flutter Version Selection

| 版本类型 Version Type | 版本号 Version | 选择 Selection |
|-------------------|------------|--------------|
| Flutter SDK | 3.22+ | ✅ 选择稳定版 |
| Dart SDK | 3.4+ | ✅ 随Flutter版本 |
| 最低Android版本 | API 23 (Android 6.0) | ✅ 兼顾覆盖率 |

---

## 4. 数据存储选型 Data Storage Selection

### 4.1 本地数据库对比 Local Database Comparison

| 对比项 Comparison | SQLite (sqflite) | Drift | Hive | SharedPreferences |
|-----------------|-----------------|-------|------|------------------|
| **功能性 Functionality** | | | | |
| 关系型数据库 | ✅ 是 | ✅ 是 | ❌ NoSQL | ❌ Key-Value |
| 复杂查询 | 5 | 5 | 2 | 1 |
| 事务支持 | 5 | 5 | 2 | 1 |
| **易用性 Usability** | | | | |
| 类型安全 | 2 | 5 | 4 | 3 |
| 学习曲线 | 3 | 3 | 5 | 5 |
| 代码生成 | ❌ 否 | ✅ 是 | ✅ 可选 | ❌ 否 |
| **性能 Performance** | | | | |
| 读写速度 | 4 | 4 | 5 | 5 |
| 大数据量支持 | 5 | 5 | 3 | 1 |
| **适用场景 Use Case** | | | | |
| 复杂数据关系 | ✅ 适合 | ✅ 适合 | ❌ 不适合 | ❌ 不适合 |
| 简单设置存储 | ❌ 过重 | ❌ 过重 | ✅ 适合 | ✅ 适合 |
| **总分 Total** | **20** | **24** | **16** | **11** |

**选择结果 Decision:** **Drift (SQLite封装)** + **SharedPreferences**

### 4.2 数据存储方案 Data Storage Solution

| 数据类型 Data Type | 存储方案 Storage Solution | 说明 Notes |
|-----------------|------------------------|----------|
| 核心业务数据 | Drift (SQLite) | 任务、进度、打卡等 |
| 应用设置 | SharedPreferences | 主题、提醒设置等 |
| 周期总结缓存 | Drift | 总结报告数据 |

### 4.3 数据库设计概要 Database Design Summary

| 数据表 Table | 用途 Purpose | 主要字段 Key Fields |
|-----------|------------|------------------|
| cycles | 周期数据 | id, type, start_date, end_date |
| tasks | 任务数据 | id, cycle_id, name, target_amount, completed_amount |
| progress_records | 进度记录 | id, task_id, date, amount |
| check_in_records | 打卡记录 | id, date, streak_count |
| categories | 分类数据 | id, name, color, icon |
| cycle_summaries | 周期总结 | id, cycle_id, completion_rate, stats_json |

---

## 5. 第三方库选型 Third-Party Libraries

### 5.1 核心依赖库 Core Dependencies

| 类别 Category | 库名 Library | 版本 Version | 用途 Purpose |
|-------------|------------|------------|------------|
| 状态管理 State | flutter_riverpod | ^2.4.0 | 响应式状态管理 |
| 数据库 Database | drift | ^2.14.0 | SQLite ORM |
| 数据库驱动 DB Driver | sqlite3_flutter_libs | ^0.5.0 | SQLite原生库 |
| 本地存储 Local Storage | shared_preferences | ^2.2.0 | 简单数据存储 |
| 通知 Notification | flutter_local_notifications | ^16.0.0 | 本地通知 |
| 路由 Routing | go_router | ^13.0.0 | 声明式路由 |
| 日志 Logging | logger | ^2.0.0 | 日志记录 |
| 时间处理 DateTime | intl | ^0.18.0 | 日期格式化 |

### 5.2 UI相关库 UI Libraries

| 类别 Category | 库名 Library | 版本 Version | 用途 Purpose |
|-------------|------------|------------|------------|
| 图表 Charts | fl_chart | ^0.66.0 | 进度图表、统计图表 |
| 日历 Calendar | table_calendar | ^3.0.0 | 打卡日历视图 |
| 图标 Icons | flutter_svg | ^2.0.0 | SVG图标支持 |
| 动画 Animation | flutter_animate | ^4.3.0 | 打卡动画效果 |

### 5.3 工具库 Utility Libraries

| 类别 Category | 库名 Library | 版本 Version | 用途 Purpose |
|-------------|------------|------------|------------|
| UUID生成 | uuid | ^4.2.0 | 唯一ID生成 |
| 文件路径 | path_provider | ^2.1.0 | 文件路径获取 |
| 权限管理 | permission_handler | ^11.0.0 | 通知权限 |
| 数据备份 | share_plus | ^7.2.0 | 数据导出分享 |

### 5.4 开发依赖库 Development Dependencies

| 类别 Category | 库名 Library | 版本 Version | 用途 Purpose |
|-------------|------------|------------|------------|
| 代码生成 Code Gen | build_runner | ^2.4.0 | 代码生成工具 |
| Drift生成 Drift Gen | drift_dev | ^2.14.0 | Drift代码生成 |
| 测试 Testing | flutter_test | SDK | 单元测试 |
| Mock测试 Mocking | mockito | ^5.4.0 | Mock测试 |

---

## 6. 开发工具选型 Development Tools

### 6.1 IDE选择 IDE Selection

| 对比项 Comparison | VS Code | Android Studio |
|-----------------|---------|---------------|
| 启动速度 | 5 | 3 |
| Flutter插件支持 | 5 | 5 |
| 代码智能提示 | 5 | 4 |
| 调试功能 | 5 | 5 |
| 内存占用 | 5 | 3 |
| 轻量级 | 5 | 2 |
| **总分 Total** | **30** | **22** |

**选择结果 Decision:** **VS Code**

### 6.2 开发工具清单 Development Tools List

| 工具类型 Tool Type | 工具名称 Tool Name | 用途 Purpose |
|------------------|-----------------|------------|
| IDE | VS Code | 代码编辑、调试 |
| 版本控制 | Git + GitHub | 代码版本管理 |
| Flutter插件 | Flutter Extension | Flutter开发支持 |
| Dart插件 | Dart Extension | Dart语言支持 |
| 模拟器 | Android Emulator | 应用测试 |
| 真机调试 | Android Device | 实机测试 |

### 6.3 VS Code扩展 VS Code Extensions

| 扩展名称 Extension Name | 用途 Purpose |
|----------------------|------------|
| Flutter | Flutter开发核心插件 |
| Dart | Dart语言支持 |
| Awesome Flutter Snippets | 代码片段 |
| Error Lens | 错误提示增强 |
| GitLens | Git增强 |
| Pubspec Assist | 依赖管理辅助 |

---

## 7. 选型汇总 Selection Summary

### 7.1 技术栈全景图 Tech Stack Overview

```
┌────────────────────────────────────────────────────────────────┐
│                       Loop App 技术架构                        │
├────────────────────────────────────────────────────────────────┤
│                         表现层 Presentation                    │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ Flutter  │  │ Material │  │ fl_chart │  │flutter_animate│  │
│  │ Widgets  │  │ Design   │  │  图表    │  │   动画    │      │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘      │
├────────────────────────────────────────────────────────────────┤
│                         业务层 Business                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ Riverpod │  │ Services │  │ Providers│  │  Models  │      │
│  │ 状态管理 │  │ 业务服务 │  │ 数据提供 │  │ 数据模型 │      │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘      │
├────────────────────────────────────────────────────────────────┤
│                         数据层 Data Layer                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │  Drift   │  │ Shared   │  │ Repository│ │  本地通知 │      │
│  │ SQLite   │  │ Preferences│ │  数据仓库 │ │          │      │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘      │
├────────────────────────────────────────────────────────────────┤
│                       基础设施 Infrastructure                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ Flutter  │  │  Dart    │  │ Android  │  │   Git    │      │
│  │ SDK 3.22 │  │ SDK 3.4  │  │ API 23+  │  │ + GitHub │      │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘      │
└────────────────────────────────────────────────────────────────┘
```

### 7.2 最终技术选型 Final Technology Stack

| 层级 Layer | 技术选型 Technology | 版本 Version | 说明 Notes |
|----------|-------------------|------------|----------|
| **框架层 Framework** | | | |
| 跨平台框架 | Flutter | 3.22+ | Google官方框架 |
| 编程语言 | Dart | 3.4+ | Flutter官方语言 |
| **UI层 UI Layer** | | | |
| UI组件 | Material Design | 3 | Flutter内置 |
| 图表库 | fl_chart | ^0.66.0 | 统计图表 |
| 日历组件 | table_calendar | ^3.0.0 | 打卡日历 |
| **状态管理 State** | | | |
| 状态管理 | flutter_riverpod | ^2.4.0 | 响应式状态管理 |
| 路由管理 | go_router | ^13.0.0 | 声明式路由 |
| **数据层 Data** | | | |
| 本地数据库 | Drift + SQLite | ^2.14.0 | ORM + SQLite |
| 简单存储 | shared_preferences | ^2.2.0 | 设置存储 |
| **功能层 Features** | | | |
| 本地通知 | flutter_local_notifications | ^16.0.0 | 任务提醒 |
| 日期处理 | intl | ^0.18.0 | 日期格式化 |
| UUID生成 | uuid | ^4.2.0 | 唯一ID |
| **开发工具 Dev Tools** | | | |
| IDE | VS Code | Latest | 代码编辑 |
| 版本控制 | Git + GitHub | Latest | 代码管理 |
| 包管理 | pub.dev | - | Dart包管理 |

### 7.3 项目结构 Project Structure

```
loop_app/
├── lib/
│   ├── main.dart                 # 应用入口
│   ├── app.dart                  # App配置
│   ├── core/                     # 核心模块
│   │   ├── constants/            # 常量定义
│   │   ├── theme/                # 主题配置
│   │   └── utils/                # 工具函数
│   ├── data/                     # 数据层
│   │   ├── database/             # 数据库定义
│   │   ├── models/               # 数据模型
│   │   └── repositories/         # 数据仓库
│   ├── domain/                   # 业务层
│   │   ├── entities/             # 业务实体
│   │   └── services/             # 业务服务
│   ├── presentation/             # 表现层
│   │   ├── providers/            # 状态管理
│   │   ├── pages/                # 页面
│   │   └── widgets/              # 组件
│   └── router/                   # 路由配置
├── test/                         # 测试目录
├── pubspec.yaml                  # 依赖配置
└── README.md                     # 项目说明
```

### 7.4 技术风险与应对 Tech Risks & Mitigation

| 风险 Risk | 影响 Impact | 概率 Probability | 应对措施 Mitigation |
|----------|-----------|----------------|------------------|
| Flutter学习曲线 | 开发效率初期较低 | 中 | 提前学习基础，参考官方示例 |
| Drift ORM学习成本 | 数据层开发变慢 | 低 | 阅读官方文档，参考示例项目 |
| 第三方包兼容性 | 功能实现受阻 | 低 | 选择维护活跃的包，准备备选方案 |
| Android版本兼容 | 部分设备不可用 | 低 | 设置合理最低版本，充分测试 |

---

## 附录 Appendix

### 附录A：环境配置指南 Environment Setup Guide

#### Flutter环境安装

```bash
# 1. 下载Flutter SDK
# 访问 https://flutter.dev/docs/get-started/install

# 2. 配置环境变量
export PATH="$PATH:[FLUTTER_GIT_DIRECTORY]/flutter/bin"

# 3. 验证安装
flutter doctor

# 4. 创建项目
flutter create loop_app
cd loop_app
```

#### VS Code配置

1. 安装Flutter插件
2. 安装Dart插件
3. 配置Flutter SDK路径
4. 启用Flutter热重载

### 附录B：参考文档 References

| 文档 Document | 链接 Link |
|-------------|---------|
| Flutter官方文档 | https://flutter.dev/docs |
| Dart官方文档 | https://dart.dev/guides |
| Drift文档 | https://drift.simonbinder.eu |
| Riverpod文档 | https://riverpod.dev |
| Material Design | https://material.io/design |

### 附录C：学习资源 Learning Resources

| 资源 Resource | 链接 Link | 说明 Description |
|-------------|---------|----------------|
| Flutter中文网 | https://flutter.cn | 中文文档和教程 |
| Flutter Cookbook | https://flutter.dev/docs/cookbook | 实用代码示例 |
| Flutter Samples | https://flutter.github.io/samples | 示例应用 |
| DartPad | https://dartpad.dev | 在线Dart/Flutter练习 |

---

## 审批与签署 Approvals

| 角色 Role | 姓名 Name | 签名 Signature | 日期 Date |
|----------|---------|--------------|---------|
| 技术负责人 Tech Lead | Snowe | | 2026-03-16 |
| 项目经理 Project Manager | Snowe | | 2026-03-16 |

---

**文档结束 End of Document**
