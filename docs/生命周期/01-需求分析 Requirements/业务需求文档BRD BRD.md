# 业务需求文档 BRD (Business Requirements Document)

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 文档版本 Document Version | v1.0.0 |
| 创建日期 Created Date | 2026-03-16 |
| 最后修改 Last Modified | 2026-03-16 |
| 业务负责人 Business Owner | Snowe |
| 产品经理 Product Manager | Snowe |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 修改内容 Description | 审核人 Reviewer |
|-------------|---------|---------------|-------------------|---------------|
| v1.0.0 | 2026-03-16 | Snowe | 初始版本 Initial Version | |

---

## 目录 Table of Contents

1. [文档概述 Document Overview](#1-文档概述-document-overview)
2. [业务背景 Business Background](#2-业务背景-business-background)
3. [业务目标 Business Objectives](#3-业务目标-business-objectives)
4. [目标市场 Target Market](#4-目标市场-target-market)
5. [业务需求 Business Requirements](#5-业务需求-business-requirements)
6. [业务流程 Business Processes](#6-业务流程-business-processes)
7. [业务规则 Business Rules](#7-业务规则-business-rules)
8. [成功指标 Success Metrics](#8-成功指标-success-metrics)
9. [约束条件 Constraints](#9-约束条件-constraints)
10. [风险评估 Risk Assessment](#10-风险评估-risk-assessment)

---

## 1. 文档概述 Document Overview

### 1.1 文档目的 Document Purpose

本文档旨在定义Loop周期计划管理应用的业务需求，明确业务目标、范围和成功标准，为产品设计和开发提供业务层面的指导。

This document defines the business requirements of the Loop project, clarifying business objectives, scope, and success criteria.

### 1.2 文档范围 Document Scope

| 包含内容 In Scope | 不包含内容 Out of Scope |
|-----------------|----------------------|
| 业务目标和策略 | 技术实现细节 |
| 业务流程和规则 | 详细功能设计 |
| 业务需求和约束 | UI/UX设计规格 |

### 1.3 目标读者 Target Audience

| 角色 Role | 使用目的 Usage |
|----------|--------------|
| 业务干系人 Stakeholders | 确认业务需求和目标 |
| 产品经理 Product Manager | 作为PRD编写的基础 |
| 项目经理 Project Manager | 了解项目业务价值 |
| 技术团队 Tech Team | 理解业务背景 |

---

## 2. 业务背景 Business Background

### 2.1 业务现状 Current Situation

**当前业务流程 Current Process:**

```
用户使用备忘录 → 手动记录周期任务 → 无法追踪进度 → 难以总结回顾 → 计划执行力下降
```

**存在的问题 Existing Problems:**

| 问题 ID Problem ID | 问题描述 Description | 影响范围 Impact | 紧急程度 Urgency |
|------------------|-------------------|---------------|---------------|
| P-001 | 备忘录缺乏周期视图，无法直观查看周/月计划 | 高 | 高 |
| P-002 | 无法记录任务的"部分完成"进度（如20/140单词） | 高 | 高 |
| P-003 | 缺少打卡激励机制，难以保持持续执行 | 中 | 高 |
| P-004 | 缺少周期总结功能，无法回顾和反思 | 中 | 中 |
| P-005 | 缺少数据统计和分析，无法优化计划 | 中 | 低 |

### 2.2 变化驱动因素 Change Drivers

| 驱动因素 Driver | 描述 Description | 影响程度 Impact |
|--------------|----------------|---------------|
| 市场变化 Market Change | 任务管理类应用需求增长 | 中 |
| 技术发展 Technology | Flutter跨平台技术成熟 | 高 |
| 竞争压力 Competition | 现有工具功能不完善 | 高 |
| 政策法规 Regulation | 无 | 低 |
| 用户需求 User Demand | 个人需求强烈 | 高 |

### 2.3 业务机会 Business Opportunity

- **细分市场机会**：专注"周期计划+部分完成记录+打卡激励"的组合功能，填补市场空白
- **用户体验机会**：打造简洁高效的用户体验，区别于功能臃肿的竞品
- **技术学习机会**：通过实际项目积累Flutter移动开发经验

---

## 3. 业务目标 Business Objectives

### 3.1 总体业务目标 Overall Business Objectives

| 序号 ID | 业务目标 Business Objective | 成功衡量 Success Measure |
|--------|--------------------------|----------------------|
| 1 | 开发一款实用的周期计划管理应用 | v1.0版本按时发布 |
| 2 | 解决现有工具的功能缺失问题 | 核心功能100%实现 |
| 3 | 提升个人计划管理效率 | 效率提升50%+ |
| 4 | 积累Flutter移动开发经验 | 掌握Flutter开发技能 |

### 3.2 具体业务指标 Specific Business Metrics

| 业务指标 Business Metric | 当前值 Current | 目标值 Target | 时间周期 Timeline |
|----------------------|-------------|------------|---------------|
| 任务管理效率 | 低（备忘录） | 高（专用工具） | 6.5周 |
| 进度追踪能力 | 无 | 完整支持 | 6.5周 |
| 打卡激励机制 | 无 | 完整支持 | 6.5周 |
| 周期总结功能 | 无 | 完整支持 | 6.5周 |

### 3.3 SMART目标检查 SMART Goals Check

| 目标 Objective | Specific | Measurable | Achievable | Relevant | Time-bound |
|-------------|-----------|-----------|------------|-----------|-----------|
| 目标1：完成MVP开发 | ☑ | ☑ | ☑ | ☑ | ☑ |
| 目标2：提升效率50% | ☑ | ☑ | ☑ | ☑ | ☑ |
| 目标3：积累Flutter经验 | ☑ | ☑ | ☑ | ☑ | ☑ |

---

## 4. 目标市场 Target Market

### 4.1 项目定位 Project Positioning

| 维度 Dimension | 描述 Description |
|-------------|----------------|
| 项目性质 Nature | 个人自用工具 |
| 核心目标 Core Goal | 解决自己的周期计划管理痛点 |
| 使用场景 Use Case | 个人日常周期计划管理 |

### 4.2 用户画像 User Profile

| 属性 Attribute | 详细描述 Detail |
|--------------|--------------|
| 用户身份 Identity | 开发者本人 |
| 核心痛点 Pain Points | 备忘录无法满足周期计划管理需求 |
| 主要需求 Main Needs | 周期视图、进度追踪、打卡激励、周期总结 |

**用户需求描述:**
- 需要周期性管理学习/工作计划
- 希望追踪任务的部分完成进度（如20/140单词）
- 需要打卡激励来保持执行动力
- 重视周期总结和数据回顾

### 4.3 现有工具分析 Current Tools Analysis

| 现有工具 Current Tool | 优势 Strengths | 无法满足的需求 Missing Features |
|---------------------|--------------|---------------------------|
| 备忘录 | 简单、系统自带 | 无周期视图、无进度追踪、无打卡、无总结 |
| 滴答清单等任务管理App | 功能全面 | 功能过重、部分功能需付费、不够简洁 |

**开发动机:**
现有工具无法完全满足个人需求，因此开发一款完全符合自己使用习惯的周期计划管理工具。

---

## 5. 业务需求 Business Requirements

### 5.1 业务需求清单 Business Requirements List

| 需求ID BR ID | 业务需求描述 Business Requirement | 优先级 Priority | 业务价值 Business Value |
|------------|-------------------------------|---------------|----------------------|
| BR-001 | 支持周/月周期视图管理计划任务 | P0 | 高 |
| BR-002 | 支持记录任务的"部分完成"进度 | P0 | 高 |
| BR-003 | 支持每日打卡和连续打卡统计 | P0 | 高 |
| BR-004 | 支持周期总结和完成率统计 | P1 | 中 |
| BR-005 | 支持任务分类和标签管理 | P1 | 中 |
| BR-006 | 支持重复任务设置 | P1 | 中 |
| BR-007 | 支持任务提醒 | P1 | 中 |
| BR-008 | 支持本地数据存储 | P0 | 高 |
| BR-009 | 支持数据备份与恢复 | P2 | 低 |
| BR-010 | 支持打卡日历视图 | P1 | 中 |

### 5.2 需求分类 Requirements Categorization

#### 功能需求 Functional Requirements

| 需求类别 Category | 需求列表 Requirements |
|----------------|---------------------|
| 核心功能 Core | 周期计划管理、部分完成记录、打卡功能 |
| 扩展功能 Extended | 周期总结、分类标签、重复任务、任务提醒 |
| 管理功能 Admin | 数据备份恢复、设置偏好 |

#### 非功能需求 Non-Functional Requirements

| 类别 Category | 要求 Requirement |
|-------------|----------------|
| 性能 Performance | 启动<2s，响应<300ms |
| 可用性 Availability | 99%+，本地运行 |
| 安全性 Security | 数据本地加密存储 |
| 可扩展性 Scalability | 支持未来云同步扩展 |

---

## 6. 业务流程 Business Processes

### 6.1 核心业务流程 Core Business Processes

#### 流程1：周期计划管理流程

**流程描述 Process Description:**
用户创建周期计划任务，在周期内追踪任务进度，周期结束后生成总结报告。

**流程图 Process Flow:**

```
[创建周期] → [添加任务] → [分配目标量] → [每日执行/记录进度] → [打卡] → [周期结束] → [生成总结]
```

**流程步骤说明 Step Details:**

| 步骤 Step | 操作者 Actor | 操作 Action | 输出 Output |
|----------|------------|-----------|-----------|
| 1 | 用户 | 选择或创建周期（周/月） | 新周期 |
| 2 | 用户 | 添加任务，设置目标量 | 任务列表 |
| 3 | 用户 | 每日执行任务，记录完成量 | 进度记录 |
| 4 | 用户 | 完成后打卡 | 打卡记录 |
| 5 | 系统 | 周期结束自动生成总结 | 总结报告 |

**业务规则 Business Rules:**
- 每个任务可以设置目标量（如140个单词）
- 每次记录的完成量会累加到总完成量
- 完成量达到目标量时任务标记为完成

#### 流程2：打卡流程

**流程描述 Process Description:**
用户每日完成任务后进行打卡，系统记录连续打卡天数。

**流程图 Process Flow:**

```
[打开应用] → [查看今日任务] → [完成任务/记录进度] → [点击打卡] → [更新连续天数]
```

**流程步骤说明 Step Details:**

| 步骤 Step | 操作者 Actor | 操作 Action | 输出 Output |
|----------|------------|-----------|-----------|
| 1 | 用户 | 打开应用 | 显示今日任务 |
| 2 | 用户 | 完成任务或记录进度 | 更新进度 |
| 3 | 用户 | 点击打卡按钮 | 打卡成功提示 |
| 4 | 系统 | 计算连续打卡天数 | 更新打卡统计 |

**业务规则 Business Rules:**
- 每天只能打卡一次
- 连续打卡从第一次打卡开始计算
- 中断一天则连续天数归零重计

#### 流程3：周期总结流程

**流程描述 Process Description:**
周期结束时自动生成总结报告，展示完成率、分类统计等数据。

**流程图 Process Flow:**

```
[周期结束] → [系统统计] → [生成报告] → [用户查看] → [下周建议]
```

**流程步骤说明 Step Details:**

| 步骤 Step | 操作者 Actor | 操作 Action | 输出 Output |
|----------|------------|-----------|-----------|
| 1 | 系统 | 检测周期结束 | 触发统计 |
| 2 | 系统 | 统计各项数据 | 统计结果 |
| 3 | 系统 | 生成可视化报告 | 总结报告 |
| 4 | 用户 | 查看报告，调整计划 | 新周期计划 |

### 6.2 跨系统集成 Integration Points

| 系统 System | 集成点 Integration Point | 集成方式 Integration Type |
|-----------|----------------------|----------------------|
| 本地通知 | 任务提醒 | 系统API |
| 本地存储 | 数据持久化 | SQLite |
| 系统日历 | 可选：同步任务 | 系统API（后续版本） |

---

## 7. 业务规则 Business Rules

### 7.1 核心业务规则 Core Business Rules

| 规则ID Rule ID | 规则描述 Rule Description | 规则类型 Rule Type | 例外情况 Exception |
|--------------|----------------------|------------------|------------------|
| R-001 | 任务目标量必须为正整数 | 约束 | 无 |
| R-002 | 每日完成量不能超过任务剩余量 | 约束 | 无 |
| R-003 | 连续打卡中断后归零重计 | 计算 | 无 |
| R-004 | 周期结束自动归档并生成总结 | 触发 | 可手动延迟 |
| R-005 | 重复任务自动创建到新周期 | 自动化 | 可暂停重复 |

### 7.2 业务规则详细说明 Detailed Business Rules

#### R-001: 任务目标量规则

**规则描述 Description:**
创建任务时，目标量必须为正整数，表示任务需要完成的总数量。

**适用范围 Scope:**
所有有量化的任务（如背单词、看书页数等）

**规则逻辑 Logic:**

```
IF 任务类型 == "有量化任务"
THEN 目标量 > 0 且 目标量 为整数
ELSE 目标量 可为空（表示非量化任务）
```

**业务影响 Business Impact:**
确保进度追踪有意义，可以正确计算完成百分比。

#### R-002: 每日完成量限制规则

**规则描述 Description:**
每日记录的完成量不能超过任务的剩余未完成量。

**适用范围 Scope:**
所有进度记录操作

**规则逻辑 Logic:**

```
IF 用户输入完成量 > 剩余量
THEN 提示并自动设置为剩余量
ELSE 正常记录
```

**业务影响 Business Impact:**
防止数据错误，保证进度记录准确性。

#### R-003: 连续打卡计算规则

**规则描述 Description:**
连续打卡天数从最近一次连续打卡开始计算，中断一天则归零。

**适用范围 Scope:**
打卡统计功能

**规则逻辑 Logic:**

```
IF 今天已打卡
THEN 连续天数不变（已打卡）
ELSE IF 昨天已打卡
THEN 连续天数 + 1
ELSE
THEN 连续天数 = 1（重新开始）
```

**业务影响 Business Impact:**
激励用户保持每日打卡习惯。

---

## 8. 成功指标 Success Metrics

### 8.1 关键绩效指标 KPIs (Key Performance Indicators)

| KPI指标 KPI Metric | 定义 Definition | 目标值 Target | 测量方式 Measurement Method |
|------------------|--------------|------------|----------------------|
| 功能完成率 | 核心功能实现比例 | 100% | 功能清单检查 |
| 应用启动时间 | 冷启动耗时 | <2秒 | 性能测试 |
| 任务完成率 | 用户周期任务完成率 | >70% | 数据统计 |
| 打卡坚持率 | 用户连续打卡比例 | >50% | 数据统计 |

### 8.2 业务成功标准 Business Success Criteria

| 成功标准 Success Criterion | 衡量方式 Measurement | 目标值 Target | 时间范围 Timeframe |
|------------------------|-------------------|------------|----------------|
| MVP按时交付 | 版本发布 | v1.0 | 6.5周内 |
| 核心功能可用 | 功能测试 | 100%通过 | 发布时 |
| 用户体验良好 | 主观评价 | >4分/5分 | 使用后 |
| 无严重Bug | Bug统计 | 0个严重 | 发布时 |

### 8.3 ROI分析 ROI Analysis

| 指标 Indicator | 计算方式 Calculation | 目标值 Target |
|--------------|-----------------|------------|
| 投资回报率 ROI | 学习价值/时间投入 | 技能提升 |
| 回收周期 Payback Period | 即时 | 即时受益 |

*注：本项目为学习型个人项目，主要收益为技能提升和效率改善*

---

## 9. 约束条件 Constraints

### 9.1 业务约束 Business Constraints

| 约束类型 Constraint Type | 约束描述 Description | 影响分析 Impact |
|----------------------|-------------------|---------------|
| 预算约束 Budget | 零成本开发 | 使用开源免费工具 |
| 时间约束 Schedule | 6.5周完成 | 采用MVP模式 |
| 资源约束 Resources | 个人开发 | 范围控制 |
| 政策约束 Policy | 无 | 无影响 |

### 9.2 技术约束 Technical Constraints

| 约束项 Constraint Item | 描述 Description |
|-------------------|----------------|
| 现有系统 Legacy Systems | 无 |
| 技术栈限制 Tech Stack | Flutter + SQLite |
| 集成要求 Integration | 本地通知 |
| 平台限制 Platform | 仅Android |

---

## 10. 风险评估 Risk Assessment

### 10.1 业务风险 Business Risks

| 风险ID Risk ID | 风险描述 Risk Description | 影响程度 Impact | 概率 Probability | 应对策略 Mitigation |
|--------------|----------------------|---------------|---------------|------------------|
| BR-001 | 功能范围蔓延导致延期 | 中 | 中 | 严格控制MVP范围 |
| BR-002 | 用户需求变化 | 中 | 低 | 敏捷迭代，快速响应 |
| BR-003 | 竞品压力 | 低 | 低 | 专注差异化功能 |

### 10.2 假设与依赖 Assumptions & Dependencies

| 序号 ID | 假设/依赖 Assumption/Dependency | 影响分析 Impact |
|--------|---------------------------|---------------|
| 1 | Flutter框架稳定可用 | 阻塞开发 |
| 2 | 开发时间可保证 | 影响进度 |
| 3 | 本地存储满足需求 | 影响功能 |
| 4 | Android设备兼容性良好 | 影响使用 |

---

## 11. 审批与签署 Approvals

| 角色 Role | 姓名 Name | 签名 Signature | 日期 Date |
|----------|---------|--------------|---------|
| 业务负责人 Business Owner | Snowe | | 2026-03-16 |
| 产品经理 Product Manager | Snowe | | 2026-03-16 |
| 项目经理 Project Manager | Snowe | | 2026-03-16 |

---

## 附录 Appendix

### 附录A：术语表 Glossary

| 术语 Term | 定义 Definition |
|----------|---------------|
| 周期计划 | 按周或月组织的任务计划集合 |
| 部分完成 | 记录任务的进度完成量（如20/140） |
| 打卡 | 每日完成后的确认行为 |
| 周期总结 | 周期结束后的完成情况统计分析 |

### 附录B：参考文档 References

- 周期计划App-需求整理.md
- 项目立项申请书
- 可行性分析报告

### 附录C：业务数据统计 Business Statistics

| 数据项 Data Item | 预估值 Estimate | 说明 Notes |
|---------------|--------------|----------|
| 单用户任务数 | 10-50个/周期 | 根据个人习惯 |
| 日活记录数 | 5-20条 | 每日进度记录 |
| 周期时长 | 7天/30天 | 周期/月周期 |

---

**文档结束 End of Document**

**注意:** 本文档是业务需求层面，不涉及具体的功能设计和技术实现。详细的功能需求请参考《产品需求文档(PRD)》。
