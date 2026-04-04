# 永久性配置 Flutter 镜像源

Flutter 镜像源可以通过环境变量进行配置，主要需要设置以下两个环境变量：
- `PUB_HOSTED_URL`：Dart 包管理器 pub 的镜像源
- `FLUTTER_STORAGE_BASE_URL`：Flutter 存储资源的镜像源

## Windows 系统配置方法

### 方法 1：通过系统环境变量配置（推荐）

1. 右键点击「此电脑」→「属性」→「高级系统设置」→「环境变量」
2. 在「用户变量」或「系统变量」中点击「新建」
3. 添加以下两个环境变量：
   - 变量名：`PUB_HOSTED_URL`，变量值：`https://pub.flutter-io.cn`
   - 变量名：`FLUTTER_STORAGE_BASE_URL`，变量值：`https://storage.flutter-io.cn`
4. 点击「确定」保存配置
5. 重启命令行工具或 IDE 使配置生效

### 方法 2：通过 PowerShell 配置文件

1. 打开 PowerShell，运行以下命令创建配置文件（如果不存在）：
   ```powershell
   if (!(Test-Path -Path $PROFILE)) {
       New-Item -ItemType File -Path $PROFILE -Force
   }
   ```

2. 编辑配置文件：
   ```powershell
   notepad $PROFILE
   ```

3. 在配置文件中添加以下内容：
   ```powershell
   # Flutter 镜像源配置
   $env:PUB_HOSTED_URL="https://pub.flutter-io.cn"
   $env:FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
   ```

4. 保存文件并重启 PowerShell

## macOS/Linux 系统配置方法

### 方法 1：通过 shell 配置文件（推荐）

1. 打开终端，根据使用的 shell 编辑对应的配置文件：
   - Bash：`~/.bash_profile` 或 `~/.bashrc`
   - Zsh：`~/.zshrc`

2. 使用编辑器打开配置文件，例如：
   ```bash
   # Bash
   nano ~/.bash_profile
   
   # Zsh  
   nano ~/.zshrc
   ```

3. 在文件末尾添加以下内容：
   ```bash
   # Flutter 镜像源配置
   export PUB_HOSTED_URL=https://pub.flutter-io.cn
   export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
   ```

4. 保存文件并运行以下命令使配置生效：
   ```bash
   # Bash
   source ~/.bash_profile
   
   # Zsh
   source ~/.zshrc
   ```

## 验证配置是否成功

1. 打开命令行工具，运行以下命令查看环境变量：
   ```bash
   # Windows PowerShell
   echo $env:PUB_HOSTED_URL
   echo $env:FLUTTER_STORAGE_BASE_URL
   
   # macOS/Linux
   echo $PUB_HOSTED_URL
   echo $FLUTTER_STORAGE_BASE_URL
   ```

2. 运行 `flutter doctor` 命令，检查是否能正常访问镜像源

3. 运行 `flutter pub get` 测试包下载是否使用了配置的镜像源

## 常用 Flutter 镜像源

### Flutter 社区镜像（推荐）
```
PUB_HOSTED_URL=https://pub.flutter-io.cn
FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

### 阿里云镜像
```
PUB_HOSTED_URL=https://mirrors.aliyun.com/dart-pub/
FLUTTER_STORAGE_BASE_URL=https://mirrors.aliyun.com/flutter/
```

### 腾讯云镜像
```
PUB_HOSTED_URL=https://mirrors.cloud.tencent.com/dart-pub/
FLUTTER_STORAGE_BASE_URL=https://mirrors.cloud.tencent.com/flutter/
```

## 注意事项

1. 镜像源配置只对当前用户有效（如果在用户变量中设置）
2. 如需全局生效，请在系统变量中设置（Windows）或在 `/etc/profile` 中设置（Linux）
3. 定期检查镜像源的可用性，避免使用失效的镜像源
4. 如果配置后出现问题，可以尝试切换到其他镜像源
5. 重启 IDE 或命令行工具可以确保配置生效
