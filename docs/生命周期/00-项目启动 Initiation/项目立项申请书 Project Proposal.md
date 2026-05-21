# 项目立项申请书 Project Proposal

## 文档信息 Document Information

| 项目 Item               | 内容 Content |
| --------------------- | ---------- |
| 文档版本 Document Version | v1.0.0     |
| 创建日期 Created Date     | 2026-03-16 |
| 最后修改 Last Modified    | 2026-03-16 |
| 作者 Author             | Snowe      |
| 审核人 Reviewer          |            |
| 批准人 Approver          |            |

---

## 修改记录 Change History

| 版本 Version | 日期 Date    | 修改人 Modifier | 修改内容 Description     |
| ---------- | ---------- | ------------ | -------------------- |
| v1.0.0     | 2026-03-16 | Snowe        | 初始版本 Initial Version |

---

## 目录 Table of Contents

1. [项目背景 Project Background](#1-项目背景-project-background)
2. [项目目标 Project Objectives](#2-项目目标-project-objectives)
3. [项目范围 Project Scope](#3-项目范围-project-scope)
4. [预期收益 Expected Benefits](#4-预期收益-expected-benefits)
5. [资源需求 Resource Requirements](#5-资源需求-resource-requirements)
6. [风险评估 Risk Assessment](#6-风险评估-risk-assessment)
7. [时间计划 Timeline](#7-时间计划-timeline)

---

## 1. 项目背景 Project Background

### 1.1 立项背景 Initiation Background

用户目前使用备忘录来管理周期计划任务，但体验不佳。备忘录缺乏专门的周期管理功能，无法有效追踪任务进度、生成周期总结、进行打卡记录，也无法支持"部分完成"的进度记录（如今天背了20/140个单词）。

There is a need for a dedicated periodic task management application that can help users better organize their weekly/monthly plans, track progress, and maintain motivation through check-in features.

**当前问题 Current Issues:**

- 备忘录缺乏周期视图，无法直观查看周/月计划
- 无法记录任务的"部分完成"进度，只能标记完成/未完成
- 缺少周期总结功能，无法回顾和反思完成情况
- 缺少打卡激励，难以保持持续执行的动力
- 缺少数据统计和分析功能

**业务痛点 Business Pain Points:**

- 任务管理效率低，需要手动整理周期任务
- 进度追踪困难，无法可视化完成情况
- 缺乏正向反馈机制，难以坚持长期计划
- 无法根据历史数据调整计划量

### 1.2 项目来源 Project Source

| 来源类型 Source Type | 具体说明 Description     |
| ---------------- | -------------------- |
| ☑ 其他 Other       | 个人自用工具，解决自己的周期计划管理需求 |

---

## 2. 项目目标 Project Objectives

### 2.1 总体目标 Overall Objective

开发一款基于 Flutter 的 Android 周期计划管理应用，帮助用户高效管理周/月计划任务，支持进度追踪、打卡激励和周期总结功能，提升用户的计划执行力和自我管理能力。

**项目愿景 Project Vision:**

打造一款简洁高效的周期计划管理工具，让用户能够轻松规划、追踪和回顾自己的周期任务，通过打卡和总结功能建立良好的执行习惯。

### 2.2 具体目标 Specific Objectives

| 序号 ID | 目标描述 Objective | 成功标准 Success Criteria | 优先级 Priority |
| ----- | -------------- | --------------------- | ------------ |
| 1     | 实现周期计划管理功能     | 支持周/月视图，任务创建/编辑/删除    | P0           |
| 2     | 实现部分完成记录功能     | 支持记录进度（如20/140），显示剩余量 | P0           |
| 3     | 实现打卡功能         | 支持每日打卡，显示连续天数         | P0           |
| 4     | 实现周期总结功能       | 自动生成周期完成率统计和总结报告      | P1           |
| 5     | 实现任务提醒功能       | 支持定时提醒未完成任务           | P1           |

### 2.3 关键成功指标 KSI (Key Success Indicators)

| 指标 Indicator  | 目标值 Target | 当前值 Current |
| ------------- | ---------- | ----------- |
| 核心功能完成度       | 100%       | 0%          |
| 应用启动时间        | < 2秒       | -           |
| 日活用户留存率（个人使用） | 持续使用       | -           |
| 用户满意度         | > 4.0/5.0  | -           |

---

## 3. 项目范围 Project Scope

### 3.1 项目边界 Project Boundaries

#### 包含范围 In Scope

- **周期计划管理模块**
  
  - 周/月计划视图切换
  - 任务创建、编辑、删除
  - 任务分类/标签功能
  - 重复任务设置（每天/每周）

- **进度追踪模块**
  
  - 部分完成记录（如20/140单词）
  - 进度可视化显示
  - 累计统计功能

- **打卡功能模块**
  
  - 每日打卡记录
  - 连续打卡天数统计
  - 打卡日历视图
  - 打卡提醒

- **周期总结模块**
  
  - 完成率统计
  - 分类进度分析
  - 周期报告生成

- **基础功能**
  
  - 本地数据存储
  - 数据备份与恢复
  - 设置与偏好

#### 不包含范围 Out of Scope

- 云同步功能（v1.0暂不实现）
- 多人协作/分享功能
- 社交功能
- 付费订阅功能
- iOS版本（后续考虑）

### 3.2 交付物 Deliverables

| 序号 ID | 交付物名称 Deliverable  | 交付时间 Due Date | 负责人 Owner |
| ----- | ------------------ | ------------- | --------- |
| 1     | 需求文档（PRD）          | 2026-03-20    | Snowe     |
| 2     | UI设计稿              | 2026-03-25    | Snowe     |
| 3     | 数据库设计              | 2026-03-22    | Snowe     |
| 4     | Android APK (v1.0) | 2026-04-15    | Snowe     |
| 5     | 测试报告               | 2026-04-20    | Snowe     |
| 6     | 用户手册               | 2026-04-25    | Snowe     |

---

## 4. 预期收益 Expected Benefits

### 4.1 业务价值 Business Value

| 收益类型 Benefit Type    | 描述 Description   | 量化指标 Metric |
| -------------------- | ---------------- | ----------- |
| 效率提升 Efficiency      | 替代备忘录，提升个人计划管理效率 | 管理效率提升50%   |
| 习惯养成 Habit Formation | 通过打卡激励建立良好习惯     | 持续使用        |
| 技术积累 Tech Learning   | Flutter移动开发经验积累  | 掌握Flutter开发 |
| 个人工具 Personal Tool   | 打造适合自己的周期管理工具    | 满足个人需求      |

### 4.2 成本效益分析 Cost-Benefit Analysis

| 项目 Item              | 金额/描述 Amount | 说明 Notes     |
| -------------------- | ------------ | ------------ |
| 预计总成本 Total Cost     | ¥0           | 个人开发，无直接金钱成本 |
| 预计收益 Expected Return | 个人效率提升+技术积累  | 无形价值         |
| 投资回报率 ROI            | -            | 学习型项目        |
| 回收周期 Payback Period  | -            | 持续受益         |

---

## 5. 资源需求 Resource Requirements

### 5.1 人力资源 Human Resources

| 角色 Role             | 人数 Count | 技能要求 Skills           | 工作内容 Work Content |
| ------------------- | -------- | --------------------- | ----------------- |
| 全栈开发 Full Stack     | 1        | Flutter, Dart, SQLite | 应用设计、开发、测试        |
| 产品设计 Product Design | 1        | UI/UX设计               | 界面设计、交互设计         |

### 5.2 技术资源 Technical Resources

| 资源类型 Resource Type   | 具体内容 Details             | 数量 Quantity |
| -------------------- | ------------------------ | ----------- |
| 开发环境 Development     | VS Code / Android Studio | 1           |
| 开发框架 Framework       | Flutter 3.x              | 1           |
| 本地数据库 Database       | SQLite / Drift           | 1           |
| 版本控制 Version Control | Git + GitHub             | 1           |
| 测试设备 Test Device     | Android手机                | 1           |

### 5.3 预算估算 Budget Estimate

| 类别 Category   | 金额 Amount | 说明 Description |
| ------------- | --------- | -------------- |
| 人力成本 Labor    | ¥0        | 个人开发           |
| 硬件设备 Hardware | ¥0        | 使用现有设备         |
| 软件许可 Software | ¥0        | 使用开源/免费工具      |
| 服务费用 Services | ¥0        | 无需付费服务         |
| 其他 Others     | ¥0        | -              |
| **总计 Total**  | **¥0**    |                |

---

## 6. 风险评估 Risk Assessment

### 6.1 风险识别 Risk Identification

| 风险ID Risk ID | 风险描述 Risk Description | 影响程度 Impact | 发生概率 Probability | 风险等级 Risk Level | 应对措施 Mitigation     |
| ------------ | --------------------- | ----------- | ---------------- | --------------- | ------------------- |
| R001         | Flutter学习曲线较陡         | 中           | 中                | 中               | 提前学习，参考官方文档         |
| R002         | 开发时间超出预期              | 中           | 中                | 中               | 采用MVP模式，分阶段交付       |
| R003         | 本地数据存储方案复杂            | 低           | 低                | 低               | 使用成熟的ORM框架          |
| R004         | UI设计经验不足              | 低           | 中                | 低               | 参考Material Design规范 |

### 6.2 关键风险分析 Critical Risk Analysis

**技术风险 Technical Risks:**

- Flutter框架更新可能导致兼容性问题
- 本地数据库性能优化需要经验积累

**资源风险 Resource Risks:**

- 个人开发时间有限，可能影响进度

**时间风险 Schedule Risks:**

- 功能范围可能扩大导致延期

**市场/竞争风险 Market Risks:**

- 市场上已有类似产品，需要突出差异化

---

## 7. 时间计划 Timeline

### 7.1 项目里程碑 Project Milestones

| 序号 ID | 里程碑 Milestone              | 计划日期 Planned Date | 关键交付物 Key Deliverables |
| ----- | -------------------------- | ----------------- | ---------------------- |
| M1    | 项目启动 Project Kickoff       | 2026-03-16        | 项目章程、开发计划              |
| M2    | 需求确认 Requirements Approval | 2026-03-20        | PRD文档                  |
| M3    | 设计完成 Design Complete       | 2026-03-28        | UI设计稿、数据库设计            |
| M4    | Alpha版本 Alpha Release      | 2026-04-10        | 核心功能可用版本               |
| M5    | Beta版本 Beta Release        | 2026-04-20        | 功能完整测试版本               |
| M6    | 正式上线 Launch                | 2026-04-30        | v1.0正式版                |

### 7.2 总体时间表 Overall Schedule

| 阶段 Phase          | 开始日期 Start | 结束日期 End   | 工期 Duration | 依赖关系 Dependencies |
| ----------------- | ---------- | ---------- | ----------- | ----------------- |
| 需求分析 Requirements | 2026-03-16 | 2026-03-20 | 5天          | -                 |
| 系统设计 Design       | 2026-03-21 | 2026-03-28 | 8天          | 需求完成              |
| 开发实施 Development  | 2026-03-29 | 2026-04-20 | 23天         | 设计完成              |
| 测试验收 Testing      | 2026-04-21 | 2026-04-28 | 8天          | 开发完成              |
| 部署上线 Deployment   | 2026-04-29 | 2026-04-30 | 2天          | 测试通过              |

---

## 8. 审批记录 Approval Record

| 角色 Role                 | 姓名 Name | 签名 Signature | 日期 Date    |
| ----------------------- | ------- | ------------ | ---------- |
| 项目申请人 Project Applicant | Snowe   |              | 2026-03-16 |
| 部门经理 Department Manager | -       |              |            |
| 技术负责人 Tech Lead         | Snowe   |              | 2026-03-16 |
| 最终审批人 Final Approver    | Snowe   |              | 2026-03-16 |

---

## 附录 Appendix

### 附录A：参考资料 Reference Materials

- Flutter官方文档: https://flutter.dev
- Material Design设计规范: https://material.io/design
- Dart语言指南: https://dart.dev/guides

### 附录B：相关文档 Related Documents

- 周期计划App-需求整理.md
- 产品需求文档PRD
- 技术选型报告

### 附录C：术语表 Glossary

| 术语 Term | 定义 Definition                 |
| ------- | ----------------------------- |
| MVP     | Minimum Viable Product 最小可行产品 |
| Flutter | Google开源的跨平台UI框架              |
| Dart    | Flutter使用的编程语言                |
| 周期计划    | 按周或月组织的任务计划                   |

---

**文档结束 End of Document**
