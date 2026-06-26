# Loop - 开发常用命令

> 更新日期: 2026-04-07
> 项目路径: `D:\Code\Project\Loop\loop_app`

---

## 模拟器管理

### 查看可用模拟器

```bash
flutter emulators
```

### 启动模拟器

```bash
flutter emulators --launch Loop_API36
```

[NOTE] 模拟器启动需要 30-60 秒，启动后需等待 `flutter devices` 能检测到设备

### 检查已连接设备

```bash
flutter devices
```

目标设备出现 `sdk gphone64 x86 64 (mobile) • emulator-5554` 即可运行

---

## 编译与运行

### 开发调试运行（Debug 模式）

```bash
cd D:\Code\Project\Loop\loop_app
flutter run -d emulator-5554
```

### 构建 Release APK

```bash
cd D:\Code\Project\Loop\loop_app
flutter build apk --release
```

产物位置: `loop_app\build\app\outputs\flutter-apk\app-release.apk`

### 构建产物命名与归档

```powershell
$buildsDir = "D:\Code\Project\Loop\builds"
if (!(Test-Path $buildsDir)) { New-Item -ItemType Directory -Path $buildsDir -Force }
$src = "D:\Code\Project\Loop\loop_app\build\app\outputs\flutter-apk\app-release.apk"
$dest = "$buildsDir\Loop_{status}_{version}_{date}_{seq}.apk"
Copy-Item -Path $src -Destination $dest -Force
```

命名格式: `Loop_{status}_{version}_{date}_{seq}.apk`

- status: alpha / beta / release / dev / debug
- version: 如 0.0.4
- date: YYYYMMDD
- seq: 01, 02, ...

示例: `Loop_alpha_0.0.4_20260407_02.apk`

---

## 代码质量检查

### 静态分析

```bash
cd D:\Code\Project\Loop\loop_app
flutter analyze
```

### 运行测试

```bash
cd D:\Code\Project\Loop\loop_app
flutter test
```

---

## 代码生成

### i18n 国际化

```bash
cd D:\Code\Project\Loop\loop_app
flutter gen-l10n
```

[NOTE] 修改 `lib/l10n/app_zh.arb` 或 `app_en.arb` 后必须重新生成

### Drift 数据库

```bash
cd D:\Code\Project\Loop\loop_app
dart run build_runner build
```

---

## 热重载

在 `flutter run` 运行期间:

| 按键  | 功能                    |
| --- | --------------------- |
| `r` | Hot reload（热重载，保留状态）  |
| `R` | Hot restart（热重启，重置状态） |
| `q` | 退出                    |

[NOTE] 修改了 i18n .arb 文件或数据库表定义后，需要 Hot restart (R) 或重新运行

---

## 版本号

版本号定义在 `pubspec.yaml` 中:

```yaml
version: 0.0.4+4
# 格式: {major}.{minor}.{patch}+{buildNumber}
```

---

## 完整开发流程示例

```powershell
# 1. 启动模拟器
flutter emulators --launch Loop_API36

# 2. 等待模拟器就绪 (约 30-60 秒)
Start-Sleep -Seconds 40

# 3. 确认设备就绪
flutter devices

# 4. 运行 Debug 模式
cd D:\Code\Project\Loop\loop_app
flutter run -d emulator-5554

# 5. (可选) 构建 Release APK
flutter build apk --release

# 6. (可选) 归档构建产物
$buildsDir = "D:\Code\Project\Loop\builds"
$src = "D:\Code\Project\Loop\loop_app\build\app\outputs\flutter-apk\app-release.apk"
$dest = "$buildsDir\Loop_alpha_0.0.4_20260407_02.apk"
Copy-Item -Path $src -Destination $dest -Force
```
