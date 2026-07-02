# 发布说明 Release Notes

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project Name | Loop - 周期计划管理应用 |
| 发布版本 Release Version | v0.0.17+17 |
| 发布日期 Release Date | 2026-07-01 |
| 发布负责人 Release Manager | Snowe |
| 开发者 Developer | Snowe |
| 版本阶段 Release Stage | Alpha (内测版) |

---

## 版本概述 Version Overview

Loop 是一款基于 Flutter 的纯本地周期计划管理移动应用，面向个人自用场景，主打周期管理、进度追踪、每日打卡、计划模板与教务课表导入等功能。

当前版本处于 Alpha 阶段（v0.0.17+17），核心功能模块已全部落地并可用。应用具有以下核心特征：

- **纯本地应用**：所有数据存储于设备本地 SQLite 数据库，不依赖任何后端服务，无需联网。
- **零账号零服务端**：开箱即用，不需要注册、登录或授权。
- **离线优先**：除字体与依赖打包阶段外，运行期不访问任何网络资源。
- **目标平台**：Android 6.0+（API 23），仅 Android 平台正式发布。

---

## 版本历史总表 Version History

> 数据来源：`loop_app/build_history.json`，按构建时间正序排列。
> 产物命名规则：`Loop_{status}_{version}_{date}_{seq}.apk`，存放在项目根目录 `builds/` 下。

| 版本 Version | 构建号 Build | 状态 Status | 日期 Date | 包大小 Size | 平台架构 Architecture |
|------|------|------|------|------|------|
| 0.0.2 | 2 | release | 2026-04-06 | 124.72 MB | android (全架构单包) |
| 0.0.7 | 7 | fix | 2026-05-07 | 102.57 MB | android (全架构单包) |
| 0.0.8 | 8 | fix | 2026-05-07 | 82.69 MB | android-arm64, android-arm |
| 0.0.9 | 9 | fix | 2026-06-22 | 102.59 MB | android-arm64, android-arm, android-x64 |
| 0.0.10 | 10 | fix | 2026-06-23 | 102.59 MB | android-arm64, android-arm, android-x64 |
| 0.0.11 | 11 | fix | 2026-06-23 | 102.59 MB | android-arm64, android-arm, android-x64 |
| 0.0.12 | 12 | fix | 2026-06-23 | 103.21 MB | android-arm64, android-arm, android-x64 |
| 0.0.13 | 13 | fix | 2026-06-25 | 103.21 MB | android-arm64, android-arm, android-x64 |
| 0.0.14 | 14 | fix | 2026-06-25 (seq 01) | 103.21 MB | android-arm64, android-arm, android-x64 |
| 0.0.14 | 14 | fix | 2026-06-25 (seq 02) | 103.21 MB | android-arm64, android-arm, android-x64 |
| 0.0.14 | 14 | fix | 2026-06-28 | 103.54 MB | android-arm64, android-arm, android-x64 |
| 0.0.15 | 15 | fix | 2026-06-28 | 104.04 MB | android-arm64, android-arm, android-x64 |
| 0.0.15 | 15 | alpha | 2026-06-28 | 103.63 MB | android-arm64, android-arm, android-x64 |
| 0.0.15 | 15 | fix | 2026-06-29 | 103.63 MB | android-arm64, android-arm, android-x64 |
| 0.0.16 | 16 | fix | 2026-07-01 | 103.73 MB | android-arm64, android-arm, android-x64 |
| **0.0.17** | **17** | **fix** | **2026-07-01** | **103.73 MB** | android-arm64, android-arm, android-x64 |
| 0.0.18 | 18 | fix | 2026-07-01 | 103.73 MB | android-arm64, android-arm, android-x64 |

> 备注：
> - v0.0.2 为首个 release 里程碑构建，体积最大（124.72 MB）。
> - v0.0.8 起按 ABI 分架构打包（arm / arm64），体积降至 82.69 MB。
> - v0.0.9 起重新加入 x64 架构，恢复 arm / arm64 / x64 三架构通用包，体积稳定在 102~104 MB 区间。
> - v0.0.17 为 `pubspec.yaml` 当前锁定版本；v0.0.18 为同日最新构建记录，尚未提升为发布版本号。

---

## 最新版本 v0.0.17 详细说明

### 新增功能 New Features

以下功能基于 `docs/TODO/TODO_LIST-260331/TODO_LIST-260331.md` 全部 12 项已完成（[DONE]）需求落地：

1. **课表模块完整引入**
   - 覆盖数据层（`Timetables` / `TimetableCourses` 表）、业务层（`TimetableHtmlParser` 教务系统 HTML 智能解析）、展示层（课表列表 / 详情 / 导入 / 课程表单页面）。
   - 支持 HTML 教务课表智能导入（含文件夹批量导入，已通过 `permission_handler` 修复 `MANAGE_EXTERNAL_STORAGE` 运行时权限）。
   - 支持手动创建 / 编辑课程（课程名、地点、节次、星期）。
   - 课程颜色按课程名哈希自动分配。

2. **课表冲突检测提示**
   - 创建计划时实时检测时间段与课表课程冲突，红色警告横幅显示冲突课程列表。
   - 提交保存时弹出确认对话框，用户可选择"仍要保存"或取消。

3. **日计划双指缩放手势**
   - 在日程区域支持双指缩放（`onScaleUpdate`），动态调整时间轴 `_hourHeight`。
   - 缩放范围 0.5x ~ 2.0x（默认 72px/小时），双指捏合显示更多小时，双指张开放大显示更细的时间段。
   - 仅响应双指操作，避免与单指滑动冲突。

4. **日计划双区域滑动**
   - 上方周选择器：`PageView` 无限滑动切换星期。
   - 下方日程区域：`PageView` 无限滑动按天切换日期。
   - 双向同步：周选择器与日程区域联动跳转，使用 `_isSyncingDayPage` / `_isSyncingWeekPage` 标志防抖。

5. **周次指示器**
   - 周选择器上方显示当前学期周次。
   - 本周显示"第x周"（主色高亮）；非本周显示"第x周（非本周）"（灰色）。
   - 无活跃课时自动隐藏。

6. **课表课程在日计划时间轴显示**
   - 新增 `coursesForDateProvider` 按日期获取课程并自动计算周次。
   - 新增 `_CourseCard` 组件（书本图标 + 课程名 + 地点），节次到时间映射，点击查看详情。
   - 切换日期自动加载对应周次课程。

7. **计划编辑功能（编辑范围）**
   - 支持对已创建计划进行编辑修改。
   - 修改保存时弹出范围选择对话框（底部弹窗 4 选项）：
     - 仅本次：仅修改当前这一条计划实例。
     - 修改以后：当前及之后所有关联实例。
     - 修改以前：当前及之前所有关联实例。
     - 修改全部：所有关联实例。
   - 新增 `PlanEditScope` 枚举与批量更新方法。

8. **边缘滑动切换导航 Tab**
   - 在 `ScaffoldWithNavBar` 中添加左右边缘 28px 检测 + 速度阈值判定。
   - 左边缘右滑 → 上一个 Tab；右边缘左滑 → 下一个 Tab。
   - 边缘检测优先级低于日程区域日期滑动，避免冲突。

9. **计划模板与每日计划**
   - 计划模板支持时间段配置、重复规则、活动日期。
   - 每日计划按模板自动生成实例。
   - 时间段卡片支持启用 / 禁用开关。

10. **进度追踪与周期总结**
    - 任务支持目标量、完成量、部分完成进度记录。
    - 每日打卡（每天仅一次），连续打卡中断后归零。
    - 周期结束自动生成总结，含统计图表（`fl_chart`）。

11. **国际化（i18n 6 语言）**
    - 支持中文（zh）、英文（en）、韩文（ko）、日文（ja）、法文（fr）、德文（de）。
    - 基于 `intl` + `flutter_localizations`，输出类 `S`。

12. **玻璃拟态 UI 与动画**
    - 共享组件 `GlassCard`、`ParticleBackground`、`AnimatedWidgets`。
    - 打卡卡片使用脉冲动画圆形按钮（`flutter_animate`）。
    - 品牌字体 MiSans（8 种字重 100-800）。

### 功能改进 Improvements

1. **导航栏高度闪烁修复**：重构 `LoopBottomNav` 为固定高度 + `AnimatedContainer` 过渡动画，切换页面时不再出现高度抖动。
2. **时间轴范围扩展**：从 06:00-23:00 扩展为 05:00-24:00，并在 `ScrollView` 上下添加 padding（顶部 120px / 底部 100px），确保滚动时首尾时间标签不被 AppBar 与底部导航栏遮挡。
3. **时间段卡片布局优化**：时间段卡片从左右排列（`Row`）改为上下排列（`Column`），中间用渐变分隔线 + 时长文字连接，消除下方空白。
4. **统计页打卡卡片重设计**：使用 `GlassCard` + 脉冲动画圆形按钮，解决右侧空白问题。
5. **架构分包构建**：自 v0.0.8 起按 ABI 分架构打包，显著减小单包体积。

### 技术栈 Tech Stack

| 层级 | 技术 | 版本 | 用途 |
|------|------|------|------|
| 框架 | Flutter | 3.x | 跨平台 UI 框架 |
| 语言 | Dart | 3.6+ (sdk: >=3.6.0 <4.0.0) | 编程语言 |
| 状态管理 | flutter_riverpod | ^3.3.1 | AsyncNotifier 响应式状态管理 |
| 路由 | go_router | ^17.2.0 | StatefulShellRoute 声明式路由 |
| 数据库 | drift | ^2.22.1 | 本地 ORM（schemaVersion 4） |
| SQLite 驱动 | sqlite3_flutter_libs | ^0.6.0+eol | SQLite 原生库 |
| 简单存储 | shared_preferences | ^2.3.5 | 应用设置 |
| 通知 | flutter_local_notifications | ^22.0.0 | 本地提醒 |
| 时区 | timezone | ^0.11.0 | 通知时区处理 |
| 图表 | fl_chart | ^1.2.0 | 进度图表 |
| 日历 | table_calendar | ^3.1.3 | 打卡日历 |
| 动画 | flutter_animate | ^4.5.2 | 打卡 / 过渡动画 |
| 唯一 ID | uuid | ^4.5.1 | 实体 ID 生成 |
| 国际化 | intl + flutter_localizations | ^0.20.2 / SDK | 多语言（zh/en/ko/ja/fr/de） |
| 文件选择 | file_picker | ^11.0.1 | 课表 HTML 文件 / 文件夹导入 |
| 权限 | permission_handler | ^12.0.0 | 运行时权限申请 |
| 字体 | MiSans | 自定义 | 品牌字体（100-800 8 种字重） |

---

## 平台与兼容性 Platform & Compatibility

### 正式发布平台

| 平台 | 状态 | 最低版本 | 说明 |
|------|------|----------|------|
| Android | 正式发布 | Android 6.0 (API 23) | 唯一正式发布平台，三架构通用包（arm64 / arm / x64） |

### 工程内其他平台

工程目录下包含 `ios` / `macos` / `windows` / `web` 平台文件夹，但均未进入正式发布流程，不在本次发布范围内。如需评估其他平台，需要单独进行兼容性与功能验证。

---

## 安装说明 Installation

Loop 为纯本地应用，安装流程极为简洁：

1. **获取安装包**：从项目 `builds/` 目录获取对应版本的 APK 文件（命名格式见"构建产物说明"）。
2. **允许未知来源**：在 Android 设备的"设置 → 安全"中允许"安装未知来源应用"。
3. **安装 APK**：使用文件管理器点击 APK 文件完成安装。
4. **运行时权限**（按需授权）：
   - 通知权限（用于本地提醒打卡 / 周期结束提醒）。
   - 存储权限（用于教务课表 HTML 文件 / 文件夹导入，需 `MANAGE_EXTERNAL_STORAGE`）。

### 安装特性

- **无需网络**：安装与运行全程离线。
- **无需账号**：不涉及注册、登录、身份验证。
- **无需服务端**：所有数据本地处理，不存在客户端-服务器通信。

---

## 数据说明 Data Description

### 存储方式

- **数据库引擎**：SQLite（通过 drift ORM）。
- **数据库版本**：schemaVersion 4。
- **存储位置**：应用沙盒内部存储，跟随应用卸载自动清除。

### 数据表清单

| 数据表 | 用途 |
|--------|------|
| cycles | 周期定义 |
| tasks | 任务 |
| progress_records | 进度记录 |
| check_in_records | 打卡记录 |
| categories | 分类 |
| cycle_summaries | 周期总结 |
| plan_templates | 计划模板 |
| plan_instances | 计划实例 |
| timetables | 课表 |
| timetable_courses | 课表课程 |

### 数据导出与清理

- **导出**：通过 `exportToJson` 可将全部应用数据导出为 JSON 文件。
- **清理**：通过 `clearAllData` 可清空全部本地数据（不可恢复，操作前请先导出备份）。

### 数据安全

- 应用不收集、不上传任何用户数据。
- 不集成任何统计分析 / 崩溃上报 SDK。
- 无云端同步能力，数据仅存在于本机。

---

## 已知限制与后续计划 Known Limitations & Roadmap

### 已知限制

1. **PDF 课表导入未实现**：当前仅支持 HTML 教务课表智能导入与手动创建，PDF 解析计划在第二阶段实现。
2. **无云端同步 / 跨设备**：纯本地应用，换机或卸载会丢失数据，需手动导出 JSON 备份。
3. **仅 Android 正式发布**：iOS / macOS / Windows / Web 工程存在但未经测试与发布。
4. **单一用户**：不支持多用户 / 多账号切换。

### 后续计划（来自 TODO_LIST-260410）

- 临时计划与"重复规则 / 活动日期"配合优化（不重复时无需选择活动日期）。
- "每周 / 每月"重复规则与活动日期联动细化。
- 日期列表手势缩放：天 / 周 / 月 显示程度切换。
- HTML 导入后向用户确认学期起始时间，实时更新周数显示。
- "日期列表"右上角新增"第x月"指示。
- 课时节次精细化（45 分钟一节、10 分钟课间、晚八等）。

### 版本里程碑

| 版本 | 含义 | 状态 |
|------|------|------|
| v0.0.x (当前 0.0.17) | Alpha 内测版，核心功能迭代 | 进行中 |
| v1.0.0 | MVP 正式版，功能与体验达到个人自用稳定标准 | 未开始 |
| v1.1.x | 在 MVP 基础上新增功能 | 未开始 |
| v1.1.1 | Bug 修复版本 | 未开始 |

---

## 构建产物说明 Build Artifacts

### 命名规则

```
Loop_{status}_{version}_{date}_{seq}.apk
```

| 字段 | 说明 | 示例 |
|------|------|------|
| Loop | 应用名（固定） | Loop |
| status | 状态类型 | release / beta / alpha / rc / fix / hotfix / feature / dev / debug |
| version | 版本号 | 0.0.17 |
| date | 构建日期 | 20260701 |
| seq | 同日构建序号 | 01, 02, ... |

**示例**：`Loop_fix_0.0.17_20260701_01.apk`

### 产物输出

- **原始输出**：`build/app/outputs/flutter-apk/app-release.apk`（Flutter 默认产物）。
- **重命名后存放**：项目根目录 `builds/` 目录（不在 `build/` 内，不受 `flutter clean` 影响）。
- **原始备份**：`build/app/outputs/flutter-apk/backup/` 下保留原始 APK 的 `.original` 备份。

### 构建历史记录

完整构建历史（含版本、状态、日期、包大小、SHA-256 校验值、平台架构、时间戳）记录于：

- `loop_app/build_history.json`

### 构建命令参考

```bash
# Debug 调试
flutter run

# 构建 Release APK
flutter build apk --release

# 运行测试
flutter test

# 代码生成（Drift）
dart run build_runner build
```

---

## 附录：当前发布版本校验信息 Appendix - v0.0.17 Checksum

| 项目 | 值 |
|------|------|
| 文件名 Filename | Loop_fix_0.0.17_20260701_01.apk |
| 版本 Version | 0.0.17+17 |
| 状态 Status | fix |
| 构建日期 Build Date | 2026-07-01 |
| 构建时间戳 Timestamp | 2026-07-01T21:04:12 |
| 包大小 File Size | 103.73 MB (108766172 bytes) |
| 平台架构 Architecture | android-arm64, android-arm, android-x64 |
| SHA-256 | DAD885BCA3030F6C68D05691CD69F5887ABBF095BD6950C0433DAE4A97C29D39 |

---

**文档结束 End of Document**
