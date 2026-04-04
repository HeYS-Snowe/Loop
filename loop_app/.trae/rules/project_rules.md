# 项目规则 - Loop (Project Rules)

> 项目名称：Loop - 周期计划管理应用
> 版本：v1.0.0
> 更新日期：2026-03-26

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

## 构建后自动处理

### 核心规则：构建完成后调用"版本管家"

**触发时机**：每次执行构建命令后自动触发

```bash
# 构建命令示例
flutter build apk --release
flutter build apk --debug
flutter build appbundle --release
```

**自动处理流程**：

1. **检测构建完成**
   - 当 `build/app/outputs/flutter-apk/` 目录下生成新的 APK 文件时触发
   - 或当 `build/app/outputs/bundle/` 目录下生成新的 AAB 文件时触发

2. **调用版本管家智能体**
   ```
   @version-manager
   ```

---

## 项目结构

```
Loop/
├── loop_app/               # Flutter 应用
│   ├── lib/
│   │   ├── core/          # 核心配置
│   │   ├── data/          # 数据层
│   │   ├── domain/        # 领域层
│   │   └── presentation/  # 展示层
│   ├── scripts/           # 构建脚本
│   │   ├── build_apk.ps1      # APK构建脚本
│   │   └── rename_apk.ps1     # APK重命名脚本
│   └── build/             # 构建输出
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
   - 简单配置使用 `shared_preferences`

### 版本号规范

遵循语义化版本控制（Semantic Versioning）:
- 主版本：不兼容的 API 修改
- 次版本：向下兼容的功能性新增
- 修订版本：向下兼容的问题修正

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

```bash
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
   - 原始构建文件会自动备份到 `backup/` 目录

2. **版本号更新**
   - 修改版本号后，同步更新 `pubspec.yaml`
   - 遵循语义化版本规范

3. **敏感信息**
   - 禁止将 API 密钥、数据库密码等提交到代码仓库
   - 本地应用，无需网络配置

---

*本规则文件由 Trae 自动管理，构建后触发版本管家*
