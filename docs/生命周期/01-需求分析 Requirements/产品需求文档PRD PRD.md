# 产品需求文档 PRD (Product Requirements Document)

## 文档信息 Document Information

| 项目 Item               | 内容 Content |
| --------------------- | ---------- |
| 文档版本 Document Version | v1.0.0     |
| 创建日期 Created Date     | 2026-03-16 |
| 最后修改 Last Modified    | 2026-03-16 |
| 产品经理 Product Manager  | Snowe      |
| 对应BRD版本 BRD Version   | v1.0.0     |

---

## 修改记录 Change History

| 版本 Version | 日期 Date    | 修改人 Modifier | 审核人 Reviewer | 修改内容 Description     |
| ---------- | ---------- | ------------ | ------------ | -------------------- |
| v1.0.0     | 2026-03-16 | Snowe        |              | 初始版本 Initial Version |

---

## 目录 Table of Contents

1. [产品概述 Product Overview](#1-产品概述-product-overview)
2. [用户分析 User Analysis](#2-用户分析-user-analysis)
3. [功能需求 Functional Requirements](#3-功能需求-functional-requirements)
4. [非功能需求 Non-Functional Requirements](#4-非功能需求-non-functional-requirements)
5. [用户体验设计 UX Design](#5-用户体验设计-ux-design)
6. [数据需求 Data Requirements](#6-数据需求-data-requirements)
7. [接口需求 API Requirements](#7-接口需求-api-requirements)
8. [业务规则 Business Rules](#8-业务规则-business-rules)
9. [发布计划 Release Plan](#9-发布计划-release-plan)

---

## 1. 产品概述 Product Overview

### 1.1 产品定位 Product Positioning

| 维度 Dimension          | 描述 Description               |
| --------------------- | ---------------------------- |
| 产品名称 Product Name     | Loop - 周期计划管理应用              |
| 产品类型 Product Type     | □ Web ☑ Mobile App □ Desktop |
| 核心价值 Core Value       | 个人自用的周期计划管理工具，支持进度追踪和打卡激励    |
| 目标用户 Target Users     | 开发者本人（个人自用）                  |
| 差异化优势 Differentiation | 完全符合个人使用习惯，支持"部分完成"进度记录      |

### 1.2 产品愿景 Product Vision

打造一款简洁高效的周期计划管理工具，让用户能够轻松规划、追踪和回顾自己的周期任务，通过打卡激励建立良好的执行习惯。

### 1.3 产品目标 Product Goals

| 目标类型 Goal Type     | 具体目标 Specific Goal | 成功指标 Success Metric |
| ------------------ | ------------------ | ------------------- |
| 用户目标 User Goal     | 高效管理周期计划           | 核心功能100%可用          |
| 业务目标 Business Goal | 6.5周内完成v1.0版本      | 按时发布                |
| 产品目标 Product Goal  | 提供流畅的用户体验          | 启动<2s，响应<300ms      |

### 1.4 版本规划 Version Planning

| 版本 Version | 发布时间 Release Date | 核心功能 Core Features  | 目标 Target |
| ---------- | ----------------- | ------------------- | --------- |
| v1.0       | 2026-04-30        | 周期计划管理、进度追踪、打卡、周期总结 | MVP上线     |
| v1.1       | TBD               | 任务提醒优化、数据备份恢复       | 功能增强      |
| v2.0       | TBD               | 云同步、iOS版本           | 重大更新      |

---

## 2. 用户分析 User Analysis

### 2.1 用户角色 User Roles

| 角色ID Role ID | 角色名称 Role Name | 角色描述 Description | 使用频率 Usage Frequency |
| ------------ | -------------- | ---------------- | -------------------- |
| UR-001       | 唯一用户           | 开发者本人，既是使用者也是开发者 | 高（每日使用）              |

**用户需求说明:**

- 需要周期性管理学习/工作任务
- 希望追踪任务的部分完成进度（如今天背了20/140个单词）
- 需要打卡激励来保持执行动力
- 重视周期总结，了解完成情况

### 2.2 用户故事 User Stories

#### 故事1：创建周期任务

**用户故事 User Story:**

> 作为一名计划管理者
> 我想要创建周期任务并设置目标量
> 以便于在周期内追踪我的完成进度

**验收标准 Acceptance Criteria:**

- [ ] 可以选择周期类型（周/月）
- [ ] 可以输入任务名称（如"背英语单词"）
- [ ] 可以设置目标量（如140个）
- [ ] 可以选择任务分类/标签
- [ ] 任务创建后显示在周期列表中

**优先级 Priority:** P0

**预估故事点 Story Points:** 3点

#### 故事2：记录任务进度

**用户故事 User Story:**

> 作为一名进度追踪者
> 我想要记录每日完成的任务量
> 以便于看到整体的完成进度和剩余量

**验收标准 Acceptance Criteria:**

- [ ] 可以选择要记录进度的任务
- [ ] 可以输入今日完成量（如20个）
- [ ] 系统自动计算并显示累计完成量和剩余量
- [ ] 进度以可视化方式展示（如进度条20/140）
- [ ] 完成量达到目标时自动标记任务完成

**优先级 Priority:** P0

**预估故事点 Story Points:** 5点

#### 故事3：每日打卡

**用户故事 User Story:**

> 作为一名习惯养成者
> 我想要每天完成任务后打卡
> 以便于保持执行动力并看到连续打卡记录

**验收标准 Acceptance Criteria:**

- [ ] 首页显示今日打卡按钮
- [ ] 点击打卡后显示打卡成功动画/提示
- [ ] 显示连续打卡天数
- [ ] 打卡日历视图显示历史打卡记录
- [ ] 打卡记录持久化存储

**优先级 Priority:** P0

**预估故事点 Story Points:** 3点

#### 故事4：查看周期总结

**用户故事 User Story:**

> 作为一名计划管理者
> 我想要在周期结束时查看总结报告
> 以便于了解完成情况和改进计划

**验收标准 Acceptance Criteria:**

- [ ] 周期结束自动生成总结报告
- [ ] 显示整体完成率（如85%）
- [ ] 按分类显示各分类完成率
- [ ] 显示打卡统计（如本周打卡5天）
- [ ] 可手动查看历史周期总结

**优先级 Priority:** P1

**预估故事点 Story Points:** 5点

#### 故事5：设置重复任务

**用户故事 User Story:**

> 作为一名计划管理者
> 我想要设置重复任务（如每天背单词）
> 以便于新周期自动创建这些任务

**验收标准 Acceptance Criteria:**

- [ ] 可以设置任务重复周期（每天/每周）
- [ ] 重复任务在新周期自动创建
- [ ] 可以暂停/恢复重复设置
- [ ] 重复任务有标识区分

**优先级 Priority:** P1

**预估故事点 Story Points:** 3点

#### 故事6：任务提醒

**用户故事 User Story:**

> 作为一名计划管理者
> 我想要设置任务提醒时间
> 以便于不会忘记执行任务

**验收标准 Acceptance Criteria:**

- [ ] 可以为任务设置提醒时间
- [ ] 到达提醒时间发送本地通知
- [ ] 通知点击跳转到对应任务
- [ ] 可以关闭/开启提醒

**优先级 Priority:** P1

**预估故事点 Story Points:** 3点

### 2.3 用户旅程 User Journey

**旅程名称 Journey Name:** 日常使用旅程

| 阶段 Stage      | 用户行为 User Action | 系统响应 System Response | 触点 Touchpoint |
| ------------- | ---------------- | -------------------- | ------------- |
| 发现 Discovery  | 打开应用             | 显示首页/今日任务            | 启动页、首页        |
| 规划 Planning   | 查看周期任务           | 展示任务列表和进度            | 任务列表页         |
| 执行 Execution  | 记录完成进度           | 更新进度显示               | 任务详情页         |
| 激励 Motivation | 点击打卡             | 显示打卡成功、更新连续天数        | 首页打卡区         |
| 回顾 Review     | 查看周期总结           | 展示完成率统计              | 总结报告页         |

---

## 3. 功能需求 Functional Requirements

### 3.1 功能架构 Feature Architecture

```
Loop App
├── 周期计划管理模块
│   ├── 周期视图切换（周/月）
│   ├── 任务创建/编辑/删除
│   ├── 任务分类/标签
│   └── 重复任务设置
├── 进度追踪模块
│   ├── 部分完成记录
│   ├── 进度可视化
│   └── 累计统计
├── 打卡功能模块
│   ├── 每日打卡
│   ├── 连续打卡统计
│   └── 打卡日历视图
├── 周期总结模块
│   ├── 完成率统计
│   ├── 分类分析
│   └── 周期报告
└── 设置模块
    ├── 数据备份/恢复
    ├── 提醒设置
    └── 主题设置
```

### 3.2 功能详细描述 Feature Details

#### 模块1：周期计划管理模块

**功能1.1：周期视图切换**

| 属性 Attribute      | 内容 Content                 |
| ----------------- | -------------------------- |
| 功能ID Feature ID   | F-001                      |
| 功能名称 Feature Name | 周期视图切换                     |
| 功能描述 Description  | 支持在周视图和月视图之间切换，展示不同周期范围的任务 |
| 用户角色 User Role    | 计划管理者                      |
| 优先级 Priority      | P0                         |
| 所属版本 Version      | v1.0                       |

**用户操作流程 User Flow:**

```
[进入应用] → [查看当前周期] → [点击切换按钮] → [选择周/月] → [显示对应视图]
```

**功能规格 Feature Specification:**

| 场景 Scenario | 前置条件 Precondition | 输入 Input | 处理逻辑 Logic | 输出 Output | 后置条件 Postcondition |
| ----------- | ----------------- | -------- | ---------- | --------- | ------------------ |
| 切换到周视图      | 在任意页面             | 点击"周"    | 加载本周任务     | 周任务列表     | 显示周视图              |
| 切换到月视图      | 在任意页面             | 点击"月"    | 加载本月任务     | 月任务列表     | 显示月视图              |
| 默认视图        | 首次打开              | 无        | 读取设置       | 周视图       | 保存默认设置             |

**验收标准 Acceptance Criteria:**

- [ ] AC-001: 默认显示周视图
- [ ] AC-002: 切换视图后记住用户选择
- [ ] AC-003: 视图切换动画流畅

**依赖 Dependencies:**

| 依赖项 Dependency Item | 类型 Type | 说明 Description |
| ------------------- | ------- | -------------- |
| 任务数据                | 数据      | 需要任务数据模型       |

---

**功能1.2：任务创建**

| 属性 Attribute      | 内容 Content                 |
| ----------------- | -------------------------- |
| 功能ID Feature ID   | F-002                      |
| 功能名称 Feature Name | 任务创建                       |
| 功能描述 Description  | 在当前周期内创建新任务，设置任务名称、目标量、分类等 |
| 用户角色 User Role    | 计划管理者                      |
| 优先级 Priority      | P0                         |
| 所属版本 Version      | v1.0                       |

**用户操作流程 User Flow:**

```
[点击新建按钮] → [填写任务信息] → [设置目标量] → [选择分类] → [保存] → [显示在列表中]
```

**功能规格 Feature Specification:**

| 场景 Scenario | 前置条件 Precondition | 输入 Input  | 处理逻辑 Logic | 输出 Output | 后置条件 Postcondition |
| ----------- | ----------------- | --------- | ---------- | --------- | ------------------ |
| 正常创建        | 在任务列表页            | 名称、目标量、分类 | 验证数据→保存    | 新任务       | 任务列表更新             |
| 名称为空        | 在创建表单             | 空名称       | 验证失败       | 错误提示      | 不创建                |
| 目标量非法       | 在创建表单             | 负数或0      | 验证失败       | 错误提示      | 不创建                |

**验收标准 Acceptance Criteria:**

- [ ] AC-001: 任务名称必填，最多50字符
- [ ] AC-002: 目标量为正整数
- [ ] AC-003: 分类可选，默认为"未分类"
- [ ] AC-004: 创建成功后返回任务列表

**依赖 Dependencies:**

| 依赖项 Dependency Item | 类型 Type | 说明 Description |
| ------------------- | ------- | -------------- |
| 分类数据                | 数据      | 需要分类列表         |

---

**功能1.3：任务编辑/删除**

| 属性 Attribute      | 内容 Content     |
| ----------------- | -------------- |
| 功能ID Feature ID   | F-003          |
| 功能名称 Feature Name | 任务编辑/删除        |
| 功能描述 Description  | 修改已有任务的信息或删除任务 |
| 用户角色 User Role    | 计划管理者          |
| 优先级 Priority      | P0             |
| 所属版本 Version      | v1.0           |

**用户操作流程 User Flow:**

```
[选择任务] → [点击编辑/删除] → [修改信息/确认删除] → [保存/确认] → [更新列表]
```

**功能规格 Feature Specification:**

| 场景 Scenario | 前置条件 Precondition | 输入 Input | 处理逻辑 Logic | 输出 Output | 后置条件 Postcondition |
| ----------- | ----------------- | -------- | ---------- | --------- | ------------------ |
| 编辑任务        | 任务已存在             | 修改后的信息   | 验证→更新      | 更新后的任务    | 数据更新               |
| 删除任务        | 任务已存在             | 确认删除     | 删除数据       | 从列表移除     | 数据删除               |
| 取消操作        | 在编辑/删除中           | 点击取消     | 不做修改       | 返回列表      | 数据不变               |

**验收标准 Acceptance Criteria:**

- [ ] AC-001: 编辑后数据立即更新
- [ ] AC-002: 删除前需确认
- [ ] AC-003: 删除操作不可恢复

---

#### 模块2：进度追踪模块

**功能2.1：部分完成记录**

| 属性 Attribute      | 内容 Content        |
| ----------------- | ----------------- |
| 功能ID Feature ID   | F-004             |
| 功能名称 Feature Name | 部分完成记录            |
| 功能描述 Description  | 记录任务的每日完成量，支持累计统计 |
| 用户角色 User Role    | 进度追踪者             |
| 优先级 Priority      | P0                |
| 所属版本 Version      | v1.0              |

**用户操作流程 User Flow:**

```
[选择任务] → [点击记录进度] → [输入完成量] → [确认] → [更新进度显示]
```

**功能规格 Feature Specification:**

| 场景 Scenario | 前置条件 Precondition | 输入 Input | 处理逻辑 Logic | 输出 Output | 后置条件 Postcondition |
| ----------- | ----------------- | -------- | ---------- | --------- | ------------------ |
| 正常记录        | 任务未完成             | 完成量      | 累加到总量      | 更新进度      | 进度更新               |
| 超量输入        | 任务未完成             | 完成量>剩余量  | 设为剩余量      | 完成进度      | 任务完成               |
| 负数输入        | 任务未完成             | 负数       | 验证失败       | 错误提示      | 不更新                |

**验收标准 Acceptance Criteria:**

- [ ] AC-001: 输入框只允许正整数
- [ ] AC-002: 完成量自动累加
- [ ] AC-003: 进度可视化显示（进度条+数字）

**数据结构 Data Structure:**

```json
{
  "taskId": "string",
  "taskName": "英语单词",
  "totalTarget": 140,
  "completedAmount": 60,
  "records": [
    { "date": "2026-03-16", "amount": 20 },
    { "date": "2026-03-17", "amount": 25 },
    { "date": "2026-03-18", "amount": 15 }
  ],
  "isCompleted": false
}
```

---

#### 模块3：打卡功能模块

**功能3.1：每日打卡**

| 属性 Attribute      | 内容 Content           |
| ----------------- | -------------------- |
| 功能ID Feature ID   | F-005                |
| 功能名称 Feature Name | 每日打卡                 |
| 功能描述 Description  | 用户完成任务后进行打卡，记录连续打卡天数 |
| 用户角色 User Role    | 习惯养成者                |
| 优先级 Priority      | P0                   |
| 所属版本 Version      | v1.0                 |

**用户操作流程 User Flow:**

```
[查看今日任务] → [完成任务] → [点击打卡按钮] → [显示打卡成功] → [更新连续天数]
```

**功能规格 Feature Specification:**

| 场景 Scenario | 前置条件 Precondition | 输入 Input | 处理逻辑 Logic | 输出 Output | 后置条件 Postcondition |
| ----------- | ----------------- | -------- | ---------- | --------- | ------------------ |
| 首次打卡        | 从未打卡              | 点击打卡     | 创建打卡记录     | 连续1天      | 打卡记录创建             |
| 连续打卡        | 昨天已打卡             | 点击打卡     | 天数+1       | 连续天数更新    | 打卡记录更新             |
| 断续打卡        | 昨天未打卡             | 点击打卡     | 重置为1天      | 连续1天      | 打卡记录重置             |
| 重复打卡        | 今日已打卡             | 点击打卡     | 无操作        | 提示已打卡     | 数据不变               |

**验收标准 Acceptance Criteria:**

- [ ] AC-001: 每天只能打卡一次
- [ ] AC-002: 显示打卡成功动画
- [ ] AC-003: 连续打卡天数实时更新
- [ ] AC-004: 打卡记录持久化存储

---

**功能3.2：打卡日历视图**

| 属性 Attribute      | 内容 Content          |
| ----------------- | ------------------- |
| 功能ID Feature ID   | F-006               |
| 功能名称 Feature Name | 打卡日历视图              |
| 功能描述 Description  | 在日历上展示打卡记录，直观显示打卡情况 |
| 用户角色 User Role    | 习惯养成者               |
| 优先级 Priority      | P1                  |
| 所属版本 Version      | v1.0                |

**用户操作流程 User Flow:**

```
[进入打卡页面] → [查看日历视图] → [看到已打卡日期高亮] → [可切换月份查看]
```

**验收标准 Acceptance Criteria:**

- [ ] AC-001: 已打卡日期显示高亮标记
- [ ] AC-002: 支持左右滑动切换月份
- [ ] AC-003: 今日日期有特殊标识

---

#### 模块4：周期总结模块

**功能4.1：周期总结报告**

| 属性 Attribute      | 内容 Content          |
| ----------------- | ------------------- |
| 功能ID Feature ID   | F-007               |
| 功能名称 Feature Name | 周期总结报告              |
| 功能描述 Description  | 周期结束时自动生成完成率统计和分析报告 |
| 用户角色 User Role    | 计划管理者               |
| 优先级 Priority      | P1                  |
| 所属版本 Version      | v1.0                |

**用户操作流程 User Flow:**

```
[周期结束] → [系统生成报告] → [用户查看] → [显示各项统计]
```

**功能规格 Feature Specification:**

| 场景 Scenario | 前置条件 Precondition | 输入 Input | 处理逻辑 Logic | 输出 Output | 后置条件 Postcondition |
| ----------- | ----------------- | -------- | ---------- | --------- | ------------------ |
| 自动生成        | 周期结束              | 无        | 统计数据       | 总结报告      | 报告可查看              |
| 手动查看        | 有历史周期             | 选择周期     | 加载数据       | 历史报告      | 显示报告               |

**报告内容 Report Content:**

- 整体完成率（如85%）
- 任务完成数/总任务数
- 分类完成率统计
- 打卡天数统计
- 建议（根据完成情况）

**验收标准 Acceptance Criteria:**

- [ ] AC-001: 周期结束自动生成报告
- [ ] AC-002: 报告包含完成率统计
- [ ] AC-003: 可查看历史周期报告

---

### 3.3 功能优先级矩阵 Feature Priority Matrix

| 功能 Feature    | 用户价值 User Value | 技术复杂度 Tech Complexity | 优先级 Priority |
| ------------- | --------------- | --------------------- | ------------ |
| F-001 周期视图切换  | 高               | 低                     | P0           |
| F-002 任务创建    | 高               | 低                     | P0           |
| F-003 任务编辑/删除 | 高               | 低                     | P0           |
| F-004 部分完成记录  | 高               | 中                     | P0           |
| F-005 每日打卡    | 高               | 低                     | P0           |
| F-006 打卡日历视图  | 中               | 低                     | P1           |
| F-007 周期总结报告  | 中               | 中                     | P1           |

---

## 4. 非功能需求 Non-Functional Requirements

### 4.1 性能需求 Performance Requirements

| 指标 Metric | 要求 Requirement | 测试方法 Test Method |
| --------- | -------------- | ---------------- |
| 应用冷启动时间   | < 2秒           | 性能测试             |
| 页面加载时间    | < 500ms        | 性能测试             |
| UI交互响应时间  | < 300ms        | 性能测试             |
| 数据库查询时间   | < 100ms        | 数据库测试            |
| 内存占用      | < 100MB        | 内存分析             |

### 4.2 可用性需求 Usability Requirements

| 指标 Metric               | 要求 Requirement |
| ----------------------- | -------------- |
| 系统可用性 Availability      | > 99%（本地运行）    |
| 故障恢复时间 Recovery Time    | 重启应用即可恢复       |
| 数据备份频率 Backup Frequency | 手动备份           |

### 4.3 安全需求 Security Requirements

| 安全领域 Security Area   | 要求 Requirement |
| -------------------- | -------------- |
| 身份认证 Authentication  | 无需认证（个人应用）     |
| 数据加密 Encryption      | 本地数据库加密（可选）    |
| 权限控制 Authorization   | 无需权限控制         |
| 数据保护 Data Protection | 数据仅存储在本地设备     |

### 4.4 兼容性需求 Compatibility Requirements

#### 设备兼容性 Device Compatibility (Mobile)

| 平台 Platform | 最低版本 Min Version     | 屏幕适配 Screen Adaptation |
| ----------- | -------------------- | ---------------------- |
| Android     | Android 6.0 (API 23) | 支持各种屏幕尺寸               |

#### 屏幕适配 Screen Adaptation

| 屏幕类型 Screen Type | 分辨率 Resolution | 适配要求 Requirement |
| ---------------- | -------------- | ---------------- |
| 小屏手机             | < 5英寸          | 基本支持             |
| 标准手机             | 5-6.5英寸        | 完全支持             |
| 大屏手机/平板          | > 6.5英寸        | 完全支持             |

### 4.5 可维护性需求 Maintainability Requirements

| 需求项 Requirement Item | 要求 Requirement     |
| -------------------- | ------------------ |
| 代码规范 Code Standards  | 遵循Dart/Flutter官方规范 |
| 文档完整性 Documentation  | 代码注释、API文档         |
| 日志规范 Logging         | 分级日志、可开关           |
| 监控告警 Monitoring      | 无（本地应用）            |

---

## 5. 用户体验设计 UX Design

### 5.1 设计原则 Design Principles

1. **简洁高效**：界面简洁，操作步骤最少化
2. **直观易懂**：功能入口清晰，无需学习成本
3. **反馈及时**：操作后立即给予反馈
4. **数据可视化**：进度、统计以图表形式展示

### 5.2 信息架构 Information Architecture

```
首页 Home
├── 今日概览
│   ├── 打卡按钮
│   └── 今日任务
├── 周期任务
│   ├── 周视图
│   ├── 月视图
│   └── 任务列表
├── 打卡记录
│   ├── 连续天数
│   └── 日历视图
├── 周期总结
│   ├── 当前周期
│   └── 历史周期
└── 设置
    ├── 分类管理
    ├── 提醒设置
    ├── 数据备份
    └── 主题设置
```

### 5.3 关键页面设计 Key Page Designs

#### 页面1：首页/今日概览

| 元素 Element | 描述 Description | 交互说明 Interaction |
| ---------- | -------------- | ---------------- |
| 顶部问候语      | 显示日期和问候语       | 无                |
| 打卡区域       | 大打卡按钮+连续天数     | 点击打卡             |
| 今日任务列表     | 今日待完成任务        | 点击查看详情           |
| 底部导航       | 首页/任务/打卡/我的    | 切换页面             |

#### 页面2：任务列表页

| 元素 Element | 描述 Description | 交互说明 Interaction |
| ---------- | -------------- | ---------------- |
| 周期切换       | 周/月切换标签        | 点击切换             |
| 新建按钮       | 悬浮按钮           | 点击创建任务           |
| 任务卡片       | 任务名称+进度条       | 点击查看详情           |
| 分类筛选       | 分类标签列表         | 点击筛选             |

#### 页面3：任务详情页

| 元素 Element | 描述 Description | 交互说明 Interaction |
| ---------- | -------------- | ---------------- |
| 任务名称       | 大字显示           | 可编辑              |
| 进度显示       | 进度条+完成量/目标量    | 可视化              |
| 记录进度       | 输入框+按钮         | 输入完成量            |
| 历史记录       | 每日完成记录列表       | 可查看/删除           |

### 5.4 交互规范 Interaction Guidelines

| 交互元素 Element | 规范 Specification        |
| ------------ | ----------------------- |
| 按钮 Button    | Material Design风格，圆角8dp |
| 表单 Form      | 输入框下方显示验证错误             |
| 弹窗 Modal     | 底部弹出式对话框                |
| 加载 Loading   | 圆形进度指示器                 |
| 反馈 Feedback  | Toast提示+轻微震动            |

### 5.5 内容策略 Content Strategy

| 内容类型 Content Type | 策略 Strategy        |
| ----------------- | ------------------ |
| 文案 Copywriting    | 简洁、积极、鼓励性          |
| 图片 Images         | 使用图标为主，简洁风格        |
| 图标 Icons          | Material Icons     |
| 颜色 Colors         | 主色调：蓝色系，辅助色：绿色（成功） |

---

## 6. 数据需求 Data Requirements

### 6.1 数据实体 Data Entities

#### 实体1：周期 (Cycle)

| 字段名 Field Name | 数据类型 Data Type | 长度 Length | 必填 Required | 说明 Description  |
| -------------- | -------------- | --------- | ----------- | --------------- |
| id             | String         | 36        | 是           | 主键UUID          |
| type           | String         | 10        | 是           | 周期类型：week/month |
| startDate      | DateTime       | -         | 是           | 开始日期            |
| endDate        | DateTime       | -         | 是           | 结束日期            |
| createdAt      | DateTime       | -         | 是           | 创建时间            |
| updatedAt      | DateTime       | -         | 是           | 更新时间            |

#### 实体2：任务 (Task)

| 字段名 Field Name  | 数据类型 Data Type | 长度 Length | 必填 Required | 说明 Description    |
| --------------- | -------------- | --------- | ----------- | ----------------- |
| id              | String         | 36        | 是           | 主键UUID            |
| cycleId         | String         | 36        | 是           | 所属周期ID            |
| name            | String         | 50        | 是           | 任务名称              |
| targetAmount    | Integer        | -         | 是           | 目标量               |
| completedAmount | Integer        | -         | 是           | 已完成量              |
| categoryId      | String         | 36        | 否           | 分类ID              |
| isRepeatable    | Boolean        | -         | 是           | 是否重复任务            |
| repeatType      | String         | 10        | 否           | 重复类型：daily/weekly |
| isCompleted     | Boolean        | -         | 是           | 是否完成              |
| createdAt       | DateTime       | -         | 是           | 创建时间              |
| updatedAt       | DateTime       | -         | 是           | 更新时间              |

#### 实体3：进度记录 (ProgressRecord)

| 字段名 Field Name | 数据类型 Data Type | 长度 Length | 必填 Required | 说明 Description |
| -------------- | -------------- | --------- | ----------- | -------------- |
| id             | String         | 36        | 是           | 主键UUID         |
| taskId         | String         | 36        | 是           | 关联任务ID         |
| date           | Date           | -         | 是           | 记录日期           |
| amount         | Integer        | -         | 是           | 完成量            |
| note           | String         | 200       | 否           | 备注             |
| createdAt      | DateTime       | -         | 是           | 创建时间           |

#### 实体4：打卡记录 (CheckInRecord)

| 字段名 Field Name | 数据类型 Data Type | 长度 Length | 必填 Required | 说明 Description |
| -------------- | -------------- | --------- | ----------- | -------------- |
| id             | String         | 36        | 是           | 主键UUID         |
| date           | Date           | -         | 是           | 打卡日期           |
| streakCount    | Integer        | -         | 是           | 连续天数           |
| createdAt      | DateTime       | -         | 是           | 创建时间           |

#### 实体5：分类 (Category)

| 字段名 Field Name | 数据类型 Data Type | 长度 Length | 必填 Required | 说明 Description |
| -------------- | -------------- | --------- | ----------- | -------------- |
| id             | String         | 36        | 是           | 主键UUID         |
| name           | String         | 20        | 是           | 分类名称           |
| color          | String         | 10        | 是           | 颜色代码           |
| icon           | String         | 30        | 否           | 图标名称           |
| createdAt      | DateTime       | -         | 是           | 创建时间           |

#### 实体6：周期总结 (CycleSummary)

| 字段名 Field Name | 数据类型 Data Type | 长度 Length | 必填 Required | 说明 Description |
| -------------- | -------------- | --------- | ----------- | -------------- |
| id             | String         | 36        | 是           | 主键UUID         |
| cycleId        | String         | 36        | 是           | 关联周期ID         |
| totalTasks     | Integer        | -         | 是           | 总任务数           |
| completedTasks | Integer        | -         | 是           | 完成任务数          |
| completionRate | Double         | -         | 是           | 完成率            |
| checkInDays    | Integer        | -         | 是           | 打卡天数           |
| categoryStats  | JSON           | -         | 否           | 分类统计           |
| createdAt      | DateTime       | -         | 是           | 创建时间           |

### 6.2 数据关系 Data Relationships

```
[Cycle] 1:N [Task]
[Task] 1:N [ProgressRecord]
[Task] N:1 [Category]
[Cycle] 1:1 [CycleSummary]
[CheckInRecord] 独立实体（按日期记录）
```

### 6.3 数据字典 Data Dictionary

| 数据项 Data Item | 类型 Type | 枚举值 Enum Values | 说明 Description |
| ------------- | ------- | --------------- | -------------- |
| cycleType     | String  | week/month      | 周期类型           |
| repeatType    | String  | daily/weekly    | 重复类型           |
| isCompleted   | Boolean | true/false      | 完成状态           |
| isRepeatable  | Boolean | true/false      | 是否重复           |

### 6.4 数据量预估 Data Volume Estimation

| 数据实体 Data Entity | 预估记录数 Estimated Records | 增长频率 Growth Rate |
| ---------------- | ----------------------- | ---------------- |
| Cycle            | 52条/年                   | 1条/周             |
| Task             | 100-500条/年              | 10-50条/周         |
| ProgressRecord   | 365-1825条/年             | 5-10条/天          |
| CheckInRecord    | 365条/年                  | 1条/天             |
| Category         | 5-20条                   | 很少变化             |

---

## 7. 接口需求 API Requirements

### 7.1 API列表 API List

本应用为纯本地应用，无服务端API。所有数据操作通过本地数据库进行。

#### 本地数据接口 Local Data Interfaces

| 接口ID API ID | 接口名称 API Name      | 描述 Description |
| ----------- | ------------------ | -------------- |
| L-001       | CycleRepository    | 周期数据CRUD       |
| L-002       | TaskRepository     | 任务数据CRUD       |
| L-003       | ProgressRepository | 进度记录CRUD       |
| L-004       | CheckInRepository  | 打卡记录CRUD       |
| L-005       | CategoryRepository | 分类数据CRUD       |
| L-006       | SummaryRepository  | 总结数据CRUD       |

### 7.2 第三方集成 Third-Party Integration

| 服务 Service                  | 用途 Purpose | 集成方式 Integration Type |
| --------------------------- | ---------- | --------------------- |
| flutter_local_notifications | 本地通知提醒     | Flutter插件             |
| sqflite/drift               | 本地数据库      | Flutter插件             |
| shared_preferences          | 简单设置存储     | Flutter插件             |
| path_provider               | 文件路径获取     | Flutter插件             |

---

## 8. 业务规则 Business Rules

### 8.1 核心业务规则 Core Business Rules

| 规则ID Rule ID | 规则描述 Rule Description | 触发条件 Trigger | 处理逻辑 Logic |
| ------------ | --------------------- | ------------ | ---------- |
| BR-001       | 任务目标量必须为正整数           | 创建/编辑任务      | 验证输入>0     |
| BR-002       | 每日完成量不能超过剩余量          | 记录进度         | 自动设为剩余量    |
| BR-003       | 连续打卡中断后归零             | 打卡时检查        | 重置连续天数     |
| BR-004       | 周期结束自动生成总结            | 周期结束时间       | 触发统计计算     |
| BR-005       | 重复任务自动创建              | 新周期开始        | 复制任务到新周期   |
| BR-006       | 每天只能打卡一次              | 打卡操作         | 检查今日是否已打卡  |

### 8.2 验证规则 Validation Rules

| 字段 Field | 验证规则 Validation Rule | 错误提示 Error Message |
| -------- | -------------------- | ------------------ |
| 任务名称     | 非空，最多50字符            | "请输入任务名称"          |
| 目标量      | 正整数                  | "目标量必须大于0"         |
| 完成量      | 正整数，≤剩余量             | "完成量不能超过剩余量"       |
| 分类名称     | 非空，最多20字符            | "请输入分类名称"          |

### 8.3 计算规则 Calculation Rules

| 计算项 Calculation | 公式 Formula       | 说明 Notes |
| --------------- | ---------------- | -------- |
| 完成率             | 已完成量/目标量×100%    | 百分比显示    |
| 周期完成率           | 已完成任务数/总任务数×100% | 百分比显示    |
| 连续打卡天数          | 昨天打卡则+1，否则重置为1   | 首次打卡为1   |

---

## 9. 发布计划 Release Plan

### 9.1 版本迭代规划 Version Roadmap

| 版本 Version | 发布日期 Release Date | 主要功能 Main Features | 里程碑 Milestone |
| ---------- | ----------------- | ------------------ | ------------- |
| v1.0 MVP   | 2026-04-30        | 周期管理、进度追踪、打卡、总结    | 最小可行产品        |
| v1.1       | TBD               | 任务提醒优化、数据备份恢复      | 功能迭代          |
| v1.2       | TBD               | 主题设置、统计图表优化        | 功能迭代          |
| v2.0       | TBD               | 云同步、iOS版本          | 重大升级          |

### 9.2 MVP功能范围 MVP Feature Scope

**包含 Included:**

- 周期视图切换（周/月）
- 任务创建/编辑/删除
- 部分完成记录
- 每日打卡
- 连续打卡统计
- 打卡日历视图
- 周期总结报告
- 任务分类管理

**不包含 Excluded (v1.0后):**

- 云同步功能
- 数据自动备份
- 社交分享功能
- iOS版本

### 9.3 功能优先级调整 Priority Adjustment

| 功能 Feature | 当前版本 Current Version | 计划版本 Planned Version | 调整原因 Reason       |
| ---------- | -------------------- | -------------------- | ----------------- |
| 云同步        | v1.0不包含              | v2.0                 | 需要后端支持，v1.0专注核心功能 |
| iOS版本      | v1.0不包含              | v2.0                 | 先验证Android版本可行性   |

---

## 10. 附录 Appendix

### 附录A：相关文档 Related Documents

| 文档名称 Document Name | 版本 Version | 链接/路径 Link/Path                                 |
| ------------------ | ---------- | ----------------------------------------------- |
| BRD业务需求文档          | v1.0.0     | ./业务需求文档BRD BRD.md                              |
| 项目章程               | v1.0.0     | ./../00-项目启动 Initiation/项目章程 Project Charter.md |
| 技术选型报告             | v1.0.0     | ./../02-系统设计 Design/技术选型报告 Tech Stack.md        |

### 附录B：术语表 Glossary

| 术语 Term | 定义 Definition                 |
| ------- | ----------------------------- |
| MVP     | Minimum Viable Product 最小可行产品 |
| 周期计划    | 按周或月组织的任务计划集合                 |
| 部分完成    | 记录任务的进度完成量（如20/140）           |
| 打卡      | 每日完成后的确认行为                    |
| 连续打卡    | 连续每天打卡的天数累计                   |

### 附录C：变更记录 Change Log

| 日期 Date    | 变更内容 Change | 影响分析 Impact |
| ---------- | ----------- | ----------- |
| 2026-03-16 | 初始版本创建      | 新建文档        |

---

## 审批与签署 Approvals

| 角色 Role              | 姓名 Name | 签名 Signature | 日期 Date    |
| -------------------- | ------- | ------------ | ---------- |
| 产品经理 Product Manager | Snowe   |              | 2026-03-16 |
| 业务负责人 Business Owner | Snowe   |              | 2026-03-16 |
| 技术负责人 Tech Lead      | Snowe   |              | 2026-03-16 |
| 项目经理 Project Manager | Snowe   |              | 2026-03-16 |

---

**文档结束 End of Document**

**注意:** 本文档定义产品层面的功能需求，技术实现细节请参考《概要设计说明书》和《详细设计说明书》。
