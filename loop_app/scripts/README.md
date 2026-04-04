# Loop 构建脚本

本目录包含用于构建和管理 APK 的脚本。

## 脚本列表

### build_apk.ps1 - APK 构建脚本

完整的 APK 构建脚本，自动处理版本号更新和文件重命名。

**参数**:
- `-BuildType`: 构建类型 (debug/release/profile)，默认 release
- `-Status`: 状态类型 (release/beta/alpha/rc/fix/hotfix/feature/dev/debug)，默认 release

**示例**:
```powershell
# 构建正式版
.\build_apk.ps1 -BuildType release -Status release

# 构建测试版
.\build_apk.ps1 -BuildType release -Status beta

# 构建开发版
.\build_apk.ps1 -BuildType debug -Status dev
```

### rename_apk.ps1 - APK 重命名脚本

单独的重命名脚本，用于已构建的 APK 文件。

**参数**:
- `-Status`: 状态类型，默认 dev
- `-Version`: 指定版本号 (可选，默认从 pubspec.yaml 读取)
- `-All`: 处理所有 APK 文件

**示例**:
```powershell
# 重命名为开发版
.\rename_apk.ps1 -Status dev

# 重命名为测试版
.\rename_apk.ps1 -Status beta

# 重命名所有APK
.\rename_apk.ps1 -Status release -All
```

## 命名规范

APK 文件命名格式：
```
Loop_{状态类型}_{版本号}_{构建日期}_{构建序号}.apk
```

示例：
- `Loop_release_1.0.0_20260326_01.apk`
- `Loop_beta_0.0.1_20260326_02.apk`

详细规范请参考: [APK 命名规范](../docs/APK_NAMING_CONVENTION.md)
