# Loop - 周期计划管理应用

## 项目简介

Loop 是一款专注于周期计划管理的移动应用，帮助用户设定周期性目标，追踪每日进度，并通过打卡机制培养良好习惯。

## 技术栈

- Flutter 3.x
- Dart 3.6+
- Riverpod 3.x (状态管理)
- Drift + SQLite (本地数据库)
- go_router 17.x (路由)

## 项目结构

```
lib/
├── main.dart              # 应用入口
├── app.dart               # MaterialApp 配置
├── core/                  # 核心模块
│   ├── constants/         # 常量定义
│   ├── theme/             # 主题配置
│   ├── router/            # 路由配置
│   └── utils/             # 工具函数
├── data/                  # 数据层
│   ├── database/          # Drift 数据库
│   ├── models/            # 数据模型
│   └── repositories/      # 数据仓库
├── domain/                # 业务层
│   └── services/          # 业务服务
├── presentation/          # 表现层
│   ├── providers/         # Riverpod Providers
│   ├── pages/             # 页面
│   └── widgets/           # 共享组件
└── shared/                # 共享模块
    ├── services/          # 跨层服务
    └── extensions/        # 扩展方法
```

## 快速开始

1. 安装依赖
```bash
flutter pub get
```

2. 生成数据库代码
```bash
dart run build_runner build
```

3. 运行应用
```bash
flutter run
```

## 核心功能

- 周期计划创建与管理
- 任务进度追踪
- 每日打卡
- 周期总结统计
- 计划模板与每日实例 (支持编辑范围: 仅本次/未来/过去/全部)
- 教务课表 HTML 导入与查看
- 本地通知提醒

## 版本

当前版本: v0.0.13+13 (Alpha)
