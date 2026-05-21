---
alwaysApply: false
description:
---
# 项目规则 - Loop (Project Rules)

> 项目名称：Loop - 周期计划管理应用
> 版本：v1.3.0
> 更新日期：2026-03-28

---

## 引用外部规则

> **以下规则文件必须同时遵守，与本文件具有同等效力**

- **Flutter 国内网络环境配置规则**: `D:\Code\.Rules\flutter-china-mirrors.md`
  - 适用于所有 Flutter 项目的国内镜像配置标准
  - 包含全局初始化、项目级配置、构建失败诊断、下载重试等完整规范
  - **AI 必须在新项目创建后自动检查并应用该规则中的行为规范**

---

## 项目概述

Loop 是一款专注于周期计划管理的移动应用，帮助用户设定周期性目标，追踪每日进度，并通过打卡机制培养良好习惯。

### 技术栈

- **前端框架**：Flutter 3.22+
- **状态管理**：Riverpod 2.x
- **路由管理**：go_router 13.x
- **本地数据库**：Drift 2.x
- **本地通知**：flutter_local_notifications 16.x

---

## 项目结构

```
Loop/
├── loop_app/               # Flutter 应用
│   ├── lib/
│   │   ├── core/          # 核心配置
│   │   ├── data/          # 数据层
│   │   │   └── database/
│   │   │       ├── app_database.dart          # 数据库主文件（条件导入）
│   │   │       ├── database_connection.dart   # Native 端（Android/iOS/Windows/macOS）
│   │   │       ├── database_connection_web.dart # Web 端（WasmDatabase）
│   │   │       └── database_connection_stub.dart # Stub（未支持平台）
│   │   ├── domain/        # 领域层
│   │   └── presentation/  # 展示层
│   ├── scripts/
│   │   ├── init_flutter_env.ps1   # 全局环境初始化（只运行一次）
│   │   ├── setup_project.ps1      # 新项目配置（每个新项目复制并运行）
│   │   ├── build_apk.ps1          # APK 构建脚本
│   │   └── rename_apk.ps1         # APK 重命名脚本
│   └── build/             # 构建输出（flutter clean 会删除）
├── builds/                # 命名后产物持久化存放（不受 flutter clean 影响）
└── .trae/
    └── rules/
        └── project_rules.md   # 本文件
```

---

## 开发规范

### Flutter 开发规范

1. **状态管理**
   - 使用 Riverpod 的 `Provider` 和 `StateNotifier`
   - 遵循单向数据流

2. **路由管理**
   - 路由配置在 `lib/core/router/`
   - 使用 `go_router` 声明式路由

3. **本地存储**
   - 结构化数据使用 `Drift` (SQLite)
   - 数据库连接使用条件导入（`dart.library.io` / `dart.library.js_interop`）
   - 简单配置使用 `shared_preferences`

### 版本号规范

四段式版本号（Major.Minor.Patch.Build）:
- 主版本：不兼容的 API 修改
- 次版本：向下兼容的功能性新增
- 修订版本：向下兼容的问题修正
- 构建序号：每次构建递增（版本号第四位）

---

## 常见操作

### 启动开发环境

```bash
cd loop_app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### 构建发布版本

```powershell
cd loop_app\scripts
.\build_apk.ps1 -BuildType release -Status release
```

**重要**：构建完成后会自动调用版本管家进行文件重命名！

---

## 代码提交规范

### Commit Message 格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

**类型 (type)**：
- `feat`: 新功能
- `fix`: 修复 bug
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 重构
- `test`: 测试相关
- `chore`: 构建/工具链相关

---

## 注意事项

1. **构建产物管理**
   - 每次构建后必须调用版本管家进行文件重命名
   - 重命名后的产物移动到项目根目录的 `builds/`（不受 `flutter clean` 影响）
   - 不再使用 `backup/` 目录备份，改为移动到 `builds/` 持久化存放

2. **版本号更新**
   - 修改版本号后，同步更新 `pubspec.yaml`
   - 遵循语义化版本规范

3. **敏感信息**
   - 禁止提交敏感信息到代码仓库
   - 使用环境变量或本地配置文件管理敏感数据

4. **国内网络环境**
   - Android Gradle 镜像已通过全局 init.d 配置，无需项目级处理
   - Windows sqlite3 已配置全局缓存引用，无需项目内下载
   - Web CanvasKit 已通过 flutter_bootstrap.js 配置 CDN
   - Drift 数据库已配置跨平台条件导入
