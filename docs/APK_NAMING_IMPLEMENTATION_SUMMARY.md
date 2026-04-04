# APK 命名规范实施总结

## 完成日期
2026-01-10

## 背景说明

由于项目在 Trae IDE 中的历史任务和历史消息有大量丢失（约 4-5 个任务历史消息内容），为了更好地管理 APK 版本和构建历史，建立了一套完整的 APK 命名规范和自动化工具。

## 已完成的工作

### 1. 创建完整的 APK 命名规范文档

**文件位置**：`docs/APK_NAMING_CONVENTION.md`

**内容包括**：
- 命名规则概述和基本格式
- 命名元素详解（程序名、状态类型、版本号、构建日期、构建序号）
- 9 种状态类型的详细说明
- 版本号管理规范（语义化版本控制）
- 构建序号管理规则
- 命名规则应用场景
- 命名规则最佳实践
- 自动化脚本说明
- 命名规则更新记录
- 附录（状态类型对照表、常见问题、参考资料）

### 2. 创建自动化构建和重命名脚本

#### 2.1 构建脚本
**文件位置**：`mindcare_app/scripts/build_apk.ps1`

**功能**：
- 一键构建并重命名 APK
- 支持多种构建类型（debug、release、profile）
- 支持 9 种状态类型
- 自动读取版本号
- 自动生成构建日期和序号
- 自动备份原文件
- 显示构建信息和文件信息

**使用示例**：
```powershell
# 构建正式版
.\build_apk.ps1 -BuildType release -Status release

# 构建修复版
.\build_apk.ps1 -BuildType release -Status fix

# 构建测试版
.\build_apk.ps1 -BuildType release -Status beta
```

#### 2.2 重命名脚本
**文件位置**：`mindcare_app/scripts/rename_apk.ps1`

**功能**：
- 重命名现有 APK 文件
- 支持批量重命名
- 支持自定义状态类型和版本号
- 自动生成构建日期和序号
- 自动备份原文件
- 跳过已重命名的文件

**使用示例**：
```powershell
# 重命名所有 APK
.\rename_apk.ps1 -All

# 重命名为指定状态
.\rename_apk.ps1 -Status release

# 重命名为指定版本
.\rename_apk.ps1 -Version 1.0.0
```

### 3. 创建快速参考文档

**文件位置**：`mindcare_app/scripts/README.md`

**内容包括**：
- 快速开始指南
- 常用场景示例
- 脚本参数说明
- 命名规则说明
- 输出文件位置
- 版本号管理
- 常见问题解答
- 最佳实践
- 相关文档链接

### 4. 更新主 README 文档

**文件位置**：`README.md`

**更新内容**：
- 在 3.5.4 节"构建生产版本"后添加了 3.5.5 节"APK 命名规范"
- 包含命名格式、命名示例、状态类型说明
- 添加了自动化构建和重命名的使用方法
- 添加了详细文档的链接
- 调整了后续章节编号

### 5. 重命名现有 APK 文件

**操作**：将 `app-release.apk` 重命名为 `MindCareAI_fix_1.0.0_20260110_01.apk`

**原因**：这是修复网络权限问题的版本，因此使用 "fix" 状态类型

**文件信息**：
- 文件名：`MindCareAI_fix_1.0.0_20260110_01.apk`
- 文件大小：57.4 MB
- 构建日期：2026-01-10
- 构建序号：01

## 命名规则详解

### 基本格式
```
{程序名}_{状态类型}_{版本号}_{构建日期}_{构建序号}.apk
```

### 命名示例
```
MindCareAI_release_1.0.0_20260110_01.apk    # 正式版
MindCareAI_beta_1.0.1_20260110_02.apk       # 测试版
MindCareAI_fix_1.0.0_20260110_01.apk        # 修复版
MindCareAI_hotfix_1.0.0_20260110_01.apk     # 紧急修复版
MindCareAI_feature_1.1.0_20260110_01.apk     # 功能版
```

### 状态类型说明

| 状态类型 | 英文标识 | 完整性 | 用途 |
|---------|---------|--------|------|
| 正式版 | release | ✅ 完全体 | 正式发布版本，经过完整测试 |
| 候选版 | rc | ✅ 接近完全体 | 候选发布版本，准备发布前的最终测试 |
| 修复版 | fix | ✅ 完全体 | 针对正式版的问题修复 |
| 紧急修复版 | hotfix | ✅ 完全体 | 针对严重问题的紧急修复 |
| 测试版 | beta | ⚠️ 非完全体 | 公开测试版本，功能基本完整 |
| 功能版 | feature | ⚠️ 非完全体 | 包含新功能开发的版本 |
| 内测版 | alpha | ❌ 非完全体 | 内部测试版本，功能开发中 |
| 开发版 | dev | ❌ 非完全体 | 日常开发过程中的构建 |
| 调试版 | debug | ❌ 非完全体 | 用于调试的构建版本 |

## 使用指南

### 日常开发构建
```powershell
cd mindcare_app\scripts
.\build_apk.ps1 -BuildType debug -Status dev
```

### 功能测试构建
```powershell
cd mindcare_app\scripts
.\build_apk.ps1 -BuildType release -Status feature
```

### 公开测试构建
```powershell
cd mindcare_app\scripts
.\build_apk.ps1 -BuildType release -Status beta
```

### 正式发布构建
```powershell
cd mindcare_app\scripts
.\build_apk.ps1 -BuildType release -Status release
```

### 问题修复构建
```powershell
cd mindcare_app\scripts
.\build_apk.ps1 -BuildType release -Status fix
```

### 紧急修复构建
```powershell
cd mindcare_app\scripts
.\build_apk.ps1 -BuildType release -Status hotfix
```

## 文件结构

```
MindCare_AI/
├── docs/
│   └── APK_NAMING_CONVENTION.md          # APK 命名规范详细文档
├── mindcare_app/
│   ├── build/
│   │   └── app/
│   │       └── outputs/
│   │           └── flutter-apk/
│   │               ├── MindCareAI_fix_1.0.0_20260110_01.apk  # 已重命名的 APK
│   │               ├── backup/                                # 备份目录
│   │               └── app-release.apk.sha1
│   └── scripts/
│       ├── build_apk.ps1              # 构建和重命名脚本
│       ├── rename_apk.ps1             # 仅重命名脚本
│       └── README.md                   # 快速参考文档
└── README.md                           # 主文档（已更新）
```

## 版本发布流程

### 标准发布流程
```
dev → alpha → beta → rc → release
```

### 问题修复流程
```
发现问题 → hotfix/fix → 测试 → release
```

### 功能迭代流程
```
dev → feature → alpha → beta → rc → release
```

## 最佳实践

1. **命名一致性**：同一项目使用统一的命名规则
2. **版本号管理**：版本号与代码仓库标签保持一致
3. **构建日期**：构建日期与实际构建时间保持一致
4. **构建序号**：构建序号按顺序递增，不跳号
5. **备份管理**：每次重命名前自动备份原文件
6. **文档更新**：及时更新命名规范文档

## 相关文档

- [APK 命名规范文档](docs/APK_NAMING_CONVENTION.md) - 详细的命名规则说明
- [APK 构建和重命名快速参考](mindcare_app/scripts/README.md) - 快速参考指南
- [项目 README](README.md) - 项目整体说明

## 后续建议

1. **版本号管理**：建议使用 Git 标签来标记重要版本
2. **自动化构建**：可以考虑集成到 CI/CD 流程中
3. **版本发布记录**：建议创建版本发布记录文档
4. **APK 分发**：建议建立 APK 分发机制（如内测平台）
5. **用户反馈**：建议建立用户反馈收集机制

## 注意事项

1. **历史数据丢失**：由于 Trae IDE 历史任务和消息丢失，部分开发历史无法追溯
2. **版本号管理**：当前版本号为 1.0.0，建议根据实际情况调整
3. **构建环境**：确保构建环境配置正确（API 地址、Gradle 目录等）
4. **权限配置**：确保 AndroidManifest.xml 中包含必要的权限（INTERNET、ACCESS_NETWORK_STATE）
5. **网络连接**：确保物理设备和开发机器在同一局域网，且 API 地址可访问

## 总结

通过建立这套完整的 APK 命名规范和自动化工具，项目现在可以：
- 清晰地管理不同版本的 APK
- 快速识别 APK 的状态和用途
- 自动化构建和重命名流程
- 保留构建历史和备份
- 提高团队协作效率

这套规范和工具将帮助团队更好地管理 APK 版本，特别是在历史数据丢失的情况下，通过标准化的命名规则可以更好地追溯和管理版本历史。
