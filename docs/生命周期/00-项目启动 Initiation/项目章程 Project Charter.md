# 项目章程 Project Charter

## 文档信息 Document Information

| 项目 Item               | 内容 Content |
| --------------------- | ---------- |
| 文档版本 Document Version | v1.0.0     |
| 创建日期 Created Date     | 2026-03-16 |
| 生效日期 Effective Date   | 2026-03-16 |
| 项目经理 Project Manager  | Snowe      |
| 项目发起人 Project Sponsor | Snowe      |

---

## 修改记录 Change History

| 版本 Version | 日期 Date    | 修改人 Modifier | 修改内容 Description     | 审核人 Reviewer |
| ---------- | ---------- | ------------ | -------------------- | ------------ |
| v1.0.0     | 2026-03-16 | Snowe        | 初始版本 Initial Version |              |

---

## 目录 Table of Contents

1. [项目概览 Project Overview](#1-项目概览-project-overview)
2. [项目目标与范围 Objectives & Scope](#2-项目目标与范围-objectives--scope)
3. [关键干系人 Stakeholders](#3-关键干系人-stakeholders)
4. [项目组织与团队 Organization](#4-项目组织与团队-organization)
5. [项目里程碑 Milestones](#5-项目里程碑-milestones)
6. [项目约束 Constraints](#6-项目约束-constraints)
7. [项目假设 Assumptions](#7-项目假设-assumptions)
8. [主要风险 Major Risks](#8-主要风险-major-risks)
9. [预算概要 Budget Summary](#9-预算概要-budget-summary)
10. [成功标准 Success Criteria](#10-成功标准-success-criteria)

---

## 1. 项目概览 Project Overview

### 1.1 项目基本信息 Project Basic Information

| 项目 Item                 | 信息 Information              |
| ----------------------- | --------------------------- |
| **项目名称 Project Name**   | Loop - 周期计划管理应用             |
| **项目编号 Project ID**     | LOOP-2026-001               |
| **项目类型 Project Type**   | □ Web应用 ☑ 移动App □ 桌面应用 □ 其他 |
| **项目状态 Project Status** | ☑ 筹备中 □ 进行中 □ 已完成           |
| **开始日期 Start Date**     | 2026-03-16                  |
| **结束日期 End Date**       | 2026-04-30                  |
| **项目工期 Duration**       | 6.5周                        |

### 1.2 项目背景与意义 Background & Significance

用户目前使用备忘录来管理周期计划任务，但体验不佳。备忘录缺乏专业的周期管理功能：

- 无法直观展示周/月计划视图
- 不支持"部分完成"进度记录
- 缺少打卡激励机制
- 无周期总结分析功能

本项目旨在开发一款专业的周期计划管理应用，帮助用户更高效地管理周期任务、追踪进度、养成良好习惯。

### 1.3 项目愿景 Project Vision

打造一款完全符合个人使用习惯的周期计划管理工具：

- 轻松规划和追踪周/月计划
- 记录任务的部分完成进度（如20/140单词）
- 通过打卡激励保持执行动力
- 定期回顾和总结周期完成情况

**项目性质:** 个人自用工具，同时积累Flutter移动开发经验

---

## 2. 项目目标与范围 Objectives & Scope

### 2.1 项目目标 Project Objectives

#### 2.1.1 业务目标 Business Objectives

| 序号 ID | 业务目标 Business Objective | 衡量指标 Metric | 目标值 Target |
| ----- | ----------------------- | ----------- | ---------- |
| 1     | 完成MVP版本开发               | 功能完成度       | 100%       |
| 2     | 实现核心功能                  | 核心功能可用      | 4项核心功能     |
| 3     | 发布可用版本                  | APK发布       | v1.0正式版    |

#### 2.1.2 用户目标 User Objectives

| 用户角色 User Role | 目标需求 User Need | 优先级 Priority |
| -------------- | -------------- | ------------ |
| 唯一用户（开发者本人）    | 直观的周期视图管理任务    | P0           |
|                | 记录任务的部分完成进度    | P0           |
|                | 打卡激励保持动力       | P0           |
|                | 周期总结了解完成情况     | P1           |

#### 2.1.3 技术目标 Technical Objectives

| 技术指标 Technical Metric | 目标值 Target | 说明 Notes |
| --------------------- | ---------- | -------- |
| 应用启动时间                | < 2秒       | 冷启动      |
| 页面响应时间                | < 300ms    | 交互响应     |
| 本地存储可靠性               | 100%       | 数据不丢失    |
| 应用包体积                 | < 20MB     | APK大小    |

### 2.2 项目范围 Project Scope

#### 2.2.1 范围内 In Scope

| 序号 ID | 功能模块/交付物 Module/Deliverable | 描述 Description      |
| ----- | --------------------------- | ------------------- |
| 1     | 周期计划管理                      | 周/月视图、任务CRUD、分类标签   |
| 2     | 部分完成记录                      | 进度记录（如20/140）、可视化显示 |
| 3     | 打卡功能                        | 每日打卡、连续天数、日历视图      |
| 4     | 周期总结                        | 完成率统计、分类分析、总结报告     |
| 5     | 本地存储                        | SQLite数据持久化、备份恢复    |
| 6     | 任务提醒                        | 本地通知提醒              |

#### 2.2.2 范围外 Out of Scope

| 序号 ID | 明确排除的内容 Excluded Item | 原因 Reason         |
| ----- | --------------------- | ----------------- |
| 1     | 云同步功能                 | v1.0暂不实现，后续版本考虑   |
| 2     | 多人协作                  | 个人应用，无需协作功能       |
| 3     | iOS版本                 | 先完成Android版本，后续考虑 |
| 4     | 社交功能                  | 专注核心功能，暂不添加       |

### 2.3 范围管理原则 Scope Management Principles

- 所有范围变更必须经过评审和批准
- 变更影响分析必须包含对时间、成本、质量的影响
- MVP功能范围严格控制，新增功能放入后续版本
- 采用敏捷迭代，分版本交付

---

## 3. 关键干系人 Stakeholders

### 3.1 干系人登记表 Stakeholder Register

| 序号 ID | 干系人姓名 Name | 角色职位 Role | 利益相关度 Interest | 影响力 Influence | 沟通需求 Communication |
| ----- | ---------- | --------- | -------------- | ------------- | ------------------ |
| 1     | Snowe      | 项目发起人/开发者 | 高              | 高             | 日常沟通               |
| 2     | Snowe      | 产品设计者     | 高              | 高             | 日常沟通               |

### 3.2 干系人职责矩阵 Stakeholder Responsibility Matrix

| 干系人 Stakeholder | 角色 Role | 主要职责 Key Responsibilities |
| --------------- | ------- | ------------------------- |
| 项目发起人 Sponsor   | Snowe   | 提供资源、决策支持、问题升级            |
| 项目经理 PM         | Snowe   | 项目管理、团队协调、进度控制            |
| 产品负责人 PO        | Snowe   | 需求定义、优先级排序、验收             |
| 技术负责人 Tech Lead | Snowe   | 技术决策、架构设计、代码审查            |
| 开发工程师 Developer | Snowe   | 功能开发、单元测试                 |
| 测试工程师 QA        | Snowe   | 功能测试、Bug报告                |

---

## 4. 项目组织与团队 Organization

### 4.1 组织结构图 Organizational Structure

```
                    项目发起人 Project Sponsor
                    (Snowe)
                             |
                    项目经理 Project Manager
                    (Snowe)
                             |
        ┌────────────┬────────┴────────┬────────────┐
    产品负责人 PO  技术负责人 Tech Lead  测试负责人 QA
    (Snowe)        (Snowe)             (Snowe)
        │             │                 │
    ┌───┴───┐     ┌───┴───┐         ┌───┴───┐
  UI设计   需求    前端开发  后端开发   功能测试  Bug报告
```

### 4.2 团队成员列表 Team Members

| 序号 ID | 姓名 Name | 角色 Role         | 职责 Responsibilities | 参与时间 Period |
| ----- | ------- | --------------- | ------------------- | ----------- |
| 1     | Snowe   | 项目经理 PM         | 项目管理、进度控制           | 全程          |
| 2     | Snowe   | 全栈开发 Full Stack | 应用设计、开发、测试          | 全程          |
| 3     | Snowe   | UI设计师 Designer  | 界面设计、交互设计           | 设计阶段        |

### 4.3 角色与职责 Roles & Responsibilities (RACI)

| 任务活动 Task         | 项目经理 PM | 产品负责人 PO | 技术负责人 Tech Lead | 开发团队 Dev | 测试团队 QA |
| ----------------- | ------- | -------- | --------------- | -------- | ------- |
| 需求定义 Requirements | A/R     | A/R      | C               | C        | I       |
| 架构设计 Architecture | A       | I        | R/C             | C        | I       |
| UI设计 UI Design    | A       | R        | C               | R        | I       |
| 开发编码 Development  | A       | I        | C               | R        | I       |
| 测试验收 Testing      | A       | I        | C               | I        | R       |
| 部署上线 Deployment   | A       | I        | R/C             | C        | I       |

**图例 Legend:**

- **R** = Responsible 负责执行
- **A** = Accountable 最终负责
- **C** = Consulted 需要咨询
- **I** = Informed 需要知情

---

## 5. 项目里程碑 Milestones

### 5.1 里程碑计划 Milestone Schedule

| 序号 ID | 里程碑名称 Milestone            | 里程碑日期 Target Date | 关键交付物 Deliverables | 负责人 Owner |
| ----- | -------------------------- | ----------------- | ------------------ | --------- |
| M1    | 项目启动 Kickoff               | 2026-03-16        | 项目章程、开发计划          | PM        |
| M2    | 需求确认 Requirements Sign-off | 2026-03-20        | PRD文档              | PO        |
| M3    | 设计评审 Design Review         | 2026-03-28        | UI设计稿、数据库设计        | Tech Lead |
| M4    | Alpha版本 Alpha Release      | 2026-04-10        | 核心功能可用版本           | Dev Team  |
| M5    | Beta版本 Beta Release        | 2026-04-20        | 功能完整测试版本           | Dev Team  |
| M6    | 产品上线 Launch                | 2026-04-30        | v1.0正式版            | All       |

### 5.2 里程碑详细描述 Milestone Details

#### M1: 项目启动 Project Kickoff

- **日期 Date:** 2026-03-16
- **目标 Objective:** 完成项目立项，明确项目方向
- **成功标准 Success Criteria:** 项目章程签署，开发环境就绪
- **依赖 Dependencies:** 无

#### M2: 需求确认 Requirements Sign-off

- **日期 Date:** 2026-03-20
- **目标 Objective:** 完成需求分析，明确功能范围
- **成功标准 Success Criteria:** PRD文档评审通过
- **依赖 Dependencies:** M1完成

#### M3: 设计评审 Design Review

- **日期 Date:** 2026-03-28
- **目标 Objective:** 完成系统设计，指导开发实施
- **成功标准 Success Criteria:** UI设计稿、数据库设计评审通过
- **依赖 Dependencies:** M2完成

#### M4: Alpha版本 Alpha Release

- **日期 Date:** 2026-04-10
- **目标 Objective:** 核心功能开发完成
- **成功标准 Success Criteria:** 周期计划、进度追踪功能可用
- **依赖 Dependencies:** M3完成

#### M5: Beta版本 Beta Release

- **日期 Date:** 2026-04-20
- **目标 Objective:** 功能完整，进入测试阶段
- **成功标准 Success Criteria:** 所有功能开发完成，进入测试
- **依赖 Dependencies:** M4完成

#### M6: 产品上线 Launch

- **日期 Date:** 2026-04-30
- **目标 Objective:** 产品正式发布
- **成功标准 Success Criteria:** v1.0正式版发布，核心功能正常运行
- **依赖 Dependencies:** M5完成

---

## 6. 项目约束 Constraints

### 6.1 约束条件汇总 Constraints Summary

| 约束类型 Constraint Type | 约束描述 Description | 应对措施 Mitigation |
| -------------------- | ---------------- | --------------- |
| 时间约束 Schedule        | 6.5周完成开发         | 采用MVP模式，严格控制范围  |
| 预算约束 Budget          | 零成本开发            | 使用开源/免费工具       |
| 资源约束 Resources       | 个人开发，资源有限        | 合理规划，分阶段交付      |
| 技术约束 Technical       | Flutter学习曲线      | 提前学习，边学边做       |
| 平台约束 Platform        | 仅Android平台       | 先完成单平台，后续扩展     |

### 6.2 依赖关系 Dependencies

| 依赖项 Dependency | 类型 Type | 描述 Description | 影响分析 Impact |
| -------------- | ------- | -------------- | ----------- |
| Flutter SDK    | 外部      | 开发框架依赖         | 阻塞开发        |
| Android SDK    | 外部      | 目标平台依赖         | 阻塞开发        |
| 第三方包           | 外部      | 功能依赖           | 可能影响功能实现    |

---

## 7. 项目假设 Assumptions

| 序号 ID | 假设内容 Assumption | 影响分析 Impact | 验证方法 Verification |
| ----- | --------------- | ----------- | ----------------- |
| 1     | Flutter框架稳定可用   | 阻塞          | 安装测试              |
| 2     | 开发时间可保证         | 影响进度        | 每周回顾              |
| 3     | 本地存储满足需求        | 影响功能        | 技术验证              |
| 4     | 个人能力可完成开发       | 影响质量        | 持续评估              |

**重要提醒:** 如果假设不成立，需要重新评估项目可行性

---

## 8. 主要风险 Major Risks

### 8.1 高优先级风险 High Priority Risks

| 风险ID Risk ID | 风险描述 Risk Description | 影响等级 Impact | 概率 Probability | 风险 owner Risk Owner |
| ------------ | --------------------- | ----------- | -------------- | ------------------- |
| R001         | Flutter学习曲线影响开发效率     | 中           | 中              | Snowe               |
| R002         | 个人开发时间不稳定             | 中           | 中              | Snowe               |
| R003         | 功能范围蔓延导致延期            | 中           | 低              | Snowe               |
| R004         | 测试覆盖不足影响质量            | 低           | 中              | Snowe               |

### 8.2 风险应对计划 Risk Response Plan

| 风险 Risk | 应对策略 Strategy | 具体措施 Actions        | 触发条件 Trigger |
| ------- | ------------- | ------------------- | ------------ |
| R001    | 减轻            | 提前学习基础，参考官方示例，边学边做  | 开发进度滞后       |
| R002    | 接受            | 制定弹性计划，设置缓冲时间       | 时间冲突         |
| R003    | 规避            | 严格控制MVP范围，新需求放入后续版本 | 需求变更请求       |
| R004    | 减轻            | 编写单元测试，充分手动测试       | 功能Bug        |

---

## 9. 预算概要 Budget Summary

### 9.1 预算分配 Budget Allocation

| 类别 Category          | 预算金额 Budget (¥) | 占比 Percentage |
| -------------------- | --------------- | ------------- |
| 人力成本 Human Resources | ¥0              | 0%            |
| 硬件设备 Hardware        | ¥0              | 0%            |
| 软件工具 Software        | ¥0              | 0%            |
| 服务费用 Services        | ¥0              | 0%            |
| 应急储备 Contingency     | ¥0              | 0%            |
| **总计 Total**         | **¥0**          | **0%**        |

**说明:** 本项目为个人学习型项目，主要成本为时间投入，无金钱成本。

### 9.2 预算授权 Budget Authorization

| 授权级别 Authorization Level | 授权金额 Limit | 说明 Notes |
| ------------------------ | ---------- | -------- |
| 项目经理 PM                  | ¥0         | 无预算支出    |
| 项目发起人 Sponsor            | ¥0         | 无预算支出    |

---

## 10. 成功标准 Success Criteria

### 10.1 项目成功标准 Project Success Criteria

| 类别 Category             | 成功标准 Success Criteria | 衡量方式 Measurement |
| ----------------------- | --------------------- | ---------------- |
| 业务目标 Business           | v1.0版本按时发布            | 版本发布             |
| 用户满意度 User Satisfaction | 核心功能可用、体验流畅           | 功能测试             |
| 技术指标 Technical          | 启动<2s，响应<300ms        | 性能测试             |
| 进度 Schedule             | 6.5周内完成               | 里程碑达成            |
| 质量 Quality              | 无严重Bug                | 测试报告             |

### 10.2 验收标准 Acceptance Criteria

| 验收项 Item                 | 标准 Criteria | 验收方式 Method |
| ------------------------ | ----------- | ----------- |
| 功能完成度 Feature Completion | 100%        | 功能测试        |
| 缺陷密度 Defect Density      | < 5个严重Bug   | 测试报告        |
| 性能指标 Performance         | 达标          | 性能测试        |
| 文档完整性 Documentation      | 完整          | 文档评审        |

---

## 11. 沟通管理 Communication Management

### 11.1 沟通计划 Communication Plan

| 会议/报告 Meeting/Report   | 频率 Frequency | 参与人 Participants | 时长 Duration |
| ---------------------- | ------------ | ---------------- | ----------- |
| 每日站会 Daily Standup     | 每日 Daily     | Snowe            | 10分钟        |
| 周例会 Weekly Meeting     | 每周 Weekly    | Snowe            | 30分钟        |
| 里程碑评审 Milestone Review | 按需 As Needed | Snowe            | 1小时         |
| 日报 Daily Report        | 每日 Daily     | Snowe            | -           |
| 周报 Weekly Report       | 每周 Weekly    | Snowe            | -           |

### 11.2 沟通工具 Communication Tools

| 用途 Purpose           | 工具 Tool            |
| -------------------- | ------------------ |
| 任务管理 Task Management | Notion/Trello      |
| 代码管理 Code            | Git + GitHub       |
| 文档协作 Docs            | Markdown + VS Code |

---

## 12. 变更管理 Change Management

### 12.1 变更控制流程 Change Control Process

```
变更请求提交 → 影响分析 → 变更评审 → 决策(批准/拒绝) → 实施 → 验证
Change Request → Impact Analysis → Review → Decision → Implement → Verify
```

### 12.2 变更控制委员会 Change Control Board (CCB)

| 成员 Member | 角色 Role | 职责 Responsibility |
| --------- | ------- | ----------------- |
| Snowe     | 项目经理    | 变更评审、决策           |

---

## 13. 批准与授权 Approval & Authorization

### 13.1 项目章程批准 Charter Approval

本人确认并同意以上项目章程内容，并授权项目启动。

I confirm and agree to the contents of this Project Charter and authorize the project initiation.

| 角色 Role               | 姓名 Name | 签名 Signature | 日期 Date    |
| --------------------- | ------- | ------------ | ---------- |
| 项目发起人 Project Sponsor | Snowe   |              | 2026-03-16 |
| 项目经理 Project Manager  | Snowe   |              | 2026-03-16 |

---

## 附录 Appendix

### 附录A：术语表 Glossary

| 术语 Term | 定义 Definition                        |
| ------- | ------------------------------------ |
| PRD     | Product Requirements Document 产品需求文档 |
| MVP     | Minimum Viable Product 最小可行产品        |
| Flutter | Google开源的跨平台UI框架                     |
| APK     | Android Package Kit Android安装包       |

### 附录B：参考文档 Reference Documents

- 项目立项申请书
- 可行性分析报告
- 周期计划App-需求整理.md

### 附录C：项目编号规则 Project ID Rules

- 项目编号格式：LOOP-YYYY-NNN
- LOOP：项目代码
- YYYY：年份
- NNN：序号

---

**文档结束 End of Document**

**重要提示:** 本章程一经签署，即成为项目执行的正式依据。任何变更必须经过正式的变更控制流程。
