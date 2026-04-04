<#
.SYNOPSIS
    Flutter 国内开发环境全局初始化脚本（只需运行一次）
.DESCRIPTION
    配置所有 Flutter 项目在国内网络环境下所需的全局基础设施：
    - Gradle 全局 init.d 镜像（所有 Gradle 项目自动生效）
    - Flutter SDK 环境变量镜像（pub.dev / storage.flutter-io.cn）
    - sqlite3 本地源码缓存（全局共享，所有 Flutter 项目复用）
    - flutter_bootstrap.js 模板（全局模板，新项目自动引用）
.NOTES
    使用方法：以管理员权限运行一次即可
    powershell -ExecutionPolicy Bypass -File init_flutter_env.ps1
#>

param(
    [string]$SqliteCacheDir
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  Flutter 国内开发环境 - 全局初始化" -ForegroundColor Cyan
Write-Host "  （只需运行一次，所有新项目自动受益）" -ForegroundColor DarkGray
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

$globalOk = 0
$globalWarn = 0

function Ensure-Dir([string]$Path) {
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Force -Path $Path | Out-Null
    }
}

function Write-Ok([string]$Msg) {
    Write-Host "  [OK] $Msg" -ForegroundColor Green
    $script:globalOk++
}

function Write-Warn([string]$Msg) {
    Write-Host "  [WARN] $Msg" -ForegroundColor DarkYellow
    $script:globalWarn++
}

# ============================================
# 0. 检测环境
# ============================================
Write-Host "[0/5] 环境检测..." -ForegroundColor Yellow

$gradleHome = if ($env:GRADLE_USER_HOME) { $env:GRADLE_USER_HOME } else { "$env:USERPROFILE\.gradle" }
Write-Host "  GRADLE_USER_HOME = $gradleHome" -ForegroundColor DarkGray

$flutterHome = $env:FLUTTER_ROOT
if (-not $flutterHome) {
    $flutterCmd = Get-Command flutter -ErrorAction SilentlyContinue
    if ($flutterCmd) {
        $flutterHome = Split-Path (Resolve-Path $flutterCmd.Source)
    }
}
Write-Host "  FLUTTER_ROOT     = $flutterHome" -ForegroundColor DarkGray

$scriptDir = $PSScriptRoot
if (-not $scriptDir) { $scriptDir = Get-Location }
Write-Host "  脚本目录         = $scriptDir" -ForegroundColor DarkGray
Write-Host ""

# ============================================
# 1. Gradle 全局 init.d 镜像（所有 Gradle 项目自动生效）
# ============================================
Write-Host "[1/5] Gradle 全局镜像配置..." -ForegroundColor Yellow
Write-Host "  -> 所有 Gradle 项目（包括 Flutter Android）自动使用阿里云镜像" -ForegroundColor DarkGray

$initDir = "$gradleHome\init.d"
$initFile = "$initDir\china-mirrors.init.gradle.kts"

try {
    Ensure-Dir $initDir
    if (Test-Path $initFile) {
        Write-Host "  -> 已存在: $initFile" -ForegroundColor Gray
    } else {
        $initContent = @'
// Gradle 全局镜像 - 阿里云 Maven 镜像
// 位置: ~/.gradle/init.d/china-mirrors.init.gradle.kts
// 作用: 所有 Gradle 项目自动生效，无需每个项目单独配置

fun RepositoryHandler.aliyunMirrors() {
    maven { url = uri("https://maven.aliyun.com/repository/google") }
    maven { url = uri("https://maven.aliyun.com/repository/central") }
    maven { url = uri("https://maven.aliyun.com/repository/public") }
    maven { url = uri("https://maven.aliyun.com/repository/gradle-plugin") }
    maven { url = uri("https://maven.aliyun.com/repository/jcenter") }
}

settingsEvaluated {
    pluginManagement {
        repositories {
            aliyunMirrors()
        }
    }
}

allprojects {
    repositories {
        aliyunMirrors()
    }
}
'@
        Set-Content -Path $initFile -Value $initContent -Encoding UTF8
        Write-Host "  -> 已创建: $initFile" -ForegroundColor Green
    }
    Write-Ok "Gradle 全局镜像已配置（所有项目自动生效）"
} catch {
    Write-Warn "无法写入 Gradle 全局配置: $_"
    Write-Host "  -> 请手动创建文件: $initFile" -ForegroundColor DarkYellow
}
Write-Host ""

# ============================================
# 2. Flutter SDK 环境变量镜像（pub.dev）
# ============================================
Write-Host "[2/5] Flutter SDK 环境变量镜像..." -ForegroundColor Yellow
Write-Host "  -> pub.dev 和 storage.flutter-io.cn 使用国内镜像" -ForegroundColor DarkGray

$envVars = @{
    "PUB_HOSTED_URL"       = "https://pub.flutter-io.cn"
    "FLUTTER_STORAGE_BASE_URL" = "https://storage.flutter-io.cn"
}

$needRestart = $false
foreach ($kv in $envVars.GetEnumerator()) {
    $name = $kv.Key
    $value = $kv.Value
    $current = [System.Environment]::GetEnvironmentVariable($name, "User")
    if ($current -eq $value) {
        Write-Host "  -> $name = $value (已配置)" -ForegroundColor Gray
    } else {
        try {
            [System.Environment]::SetEnvironmentVariable($name, $value, "User")
            [System.Environment]::SetEnvironmentVariable($name, $value, "Process")
            Write-Host "  -> $name = $value (已设置)" -ForegroundColor Green
            $needRestart = $true
        } catch {
            Write-Warn "无法设置 $name`: $_"
        }
    }
}

if ($needRestart) {
    Write-Warn "环境变量已更新，请重启终端/IDE 使其生效"
} else {
    Write-Ok "Flutter SDK 镜像环境变量已配置"
}
Write-Host ""

# ============================================
# 3. sqlite3 全局本地源码缓存（所有 Flutter 项目共享）
# ============================================
Write-Host "[3/5] sqlite3 全局本地源码缓存..." -ForegroundColor Yellow
Write-Host "  -> 下载一次，所有 Flutter 项目的 Windows/Linux 构建共用" -ForegroundColor DarkGray

if ($SqliteCacheDir) {
    $cacheDir = $SqliteCacheDir
} else {
    $cacheDir = "$gradleHome\flutter-deps\sqlite3"
}

$sqliteVersion = "3520000"
$sqliteDir = "$cacheDir\sqlite-autoconf-$sqliteVersion"

if (Test-Path "$sqliteDir\sqlite3.c") {
    Write-Host "  -> sqlite3 源码已缓存: $sqliteDir" -ForegroundColor Gray
    Write-Ok "sqlite3 全局缓存已就绪"
} else {
    Write-Host "  -> 下载 sqlite3-autoconf-$sqliteVersion ..." -ForegroundColor Gray
    Ensure-Dir $cacheDir

    $tarUrl = "https://sqlite.org/2026/sqlite-autoconf-$sqliteVersion.tar.gz"
    $tarFile = "$cacheDir\sqlite-autoconf-$sqliteVersion.tar.gz"

    $downloadOk = $false

    $mirrors = @(
        @{ Url = "https://sqlite.org/2026/sqlite-autoconf-$sqliteVersion.tar.gz"; Name = "sqlite.org (官方)" },
        @{ Url = "https://cdn.jsdelivr.net/npm/sqlite3@$sqliteVersion.tar.gz"; Name = "jsdelivr CDN" },
        @{ Url = "https://ghp.ci/https://github.com/nicbarker/sqlite-autoconf/archive/refs/tags/v3.52.0.tar.gz"; Name = "GitHub 镜像" }
    )

    foreach ($mirror in $mirrors) {
        Write-Host "  -> 尝试: $($mirror.Name)" -ForegroundColor DarkGray
        try {
            Invoke-WebRequest -Uri $mirror.Url -OutFile $tarFile -UseBasicParsing -TimeoutSec 60
            if ((Get-Item $tarFile).Length -gt 1000) {
                Write-Host "  -> 下载成功" -ForegroundColor Green
                tar -xzf $tarFile -C $cacheDir
                Remove-Item $tarFile -Force -ErrorAction SilentlyContinue
                $downloadOk = $true
                break
            } else {
                Remove-Item $tarFile -Force -ErrorAction SilentlyContinue
            }
        } catch {
            Write-Host "  -> 失败: $($_.Exception.Message)" -ForegroundColor DarkGray
            Remove-Item $tarFile -Force -ErrorAction SilentlyContinue
        }
    }

    if ($downloadOk -and (Test-Path "$sqliteDir\sqlite3.c")) {
        Write-Ok "sqlite3 全局缓存已创建: $cacheDir"
    } else {
        Write-Warn "自动下载失败，请手动下载 sqlite3 源码"
        Write-Host "  -> 下载地址: $tarUrl" -ForegroundColor DarkYellow
        Write-Host "  -> 解压到: $cacheDir" -ForegroundColor DarkYellow
    }
}
Write-Host ""

# ============================================
# 4. flutter_bootstrap.js 全局模板
# ============================================
Write-Host "[4/5] flutter_bootstrap.js 全局模板..." -ForegroundColor Yellow
Write-Host "  -> 新项目 Web 构建时自动使用 CanvasKit CDN" -ForegroundColor DarkGray

$bootstrapTemplateDir = "$gradleHome\flutter-deps\templates\web"
Ensure-Dir $bootstrapTemplateDir

$bootstrapTemplateFile = "$bootstrapTemplateDir\flutter_bootstrap.js"
$bootstrapContent = @'
{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.loadEntrypoint({
  serviceWorker: {
    serviceWorkerVersion: {{flutter_service_worker_version}},
  },
  onEntrypointLoaded: async function(engineInitializer) {
    let appRunner = await engineInitializer.initializeEngine({
      canvasKitBaseUrl: "https://cdn.jsdelivr.net/npm/canvaskit-wasm/bin/",
    });
    await appRunner.runApp();
  }
});
'@

if (Test-Path $bootstrapTemplateFile) {
    Write-Host "  -> 模板已存在: $bootstrapTemplateFile" -ForegroundColor Gray
} else {
    Set-Content -Path $bootstrapTemplateFile -Value $bootstrapContent -Encoding UTF8
    Write-Host "  -> 已创建: $bootstrapTemplateFile" -ForegroundColor Green
}
Write-Ok "flutter_bootstrap.js 模板已就绪"
Write-Host ""

# ============================================
# 5. 创建 setup_project.ps1 项目配置工具
# ============================================
Write-Host "[5/5] 创建项目配置工具 setup_project.ps1..." -ForegroundColor Yellow

$setupToolFile = "$scriptDir\setup_project.ps1"

if (Test-Path $setupToolFile) {
    Write-Host "  -> 已存在: $setupToolFile" -ForegroundColor Gray
} else {
    Write-Warn "setup_project.ps1 不存在，请确保它与 init_flutter_env.ps1 在同一目录"
    Write-Host "  -> 该文件用于配置新项目，请从已有项目复制" -ForegroundColor DarkYellow
}
Write-Ok "项目配置工具 setup_project.ps1 已就绪"
Write-Host ""

# ============================================
# 总结
# ============================================
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  全局初始化完成!" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "已配置的全局基础设施：" -ForegroundColor White
Write-Host ""
Write-Host "  [1] Gradle 全局镜像" -ForegroundColor Green
Write-Host "      文件: $initFile" -ForegroundColor DarkGray
Write-Host "      作用: 所有 Gradle 项目自动使用阿里云 Maven 镜像" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  [2] Flutter SDK 镜像环境变量" -ForegroundColor Green
Write-Host "      PUB_HOSTED_URL = $env:PUB_HOSTED_URL" -ForegroundColor DarkGray
Write-Host "      FLUTTER_STORAGE_BASE_URL = $env:FLUTTER_STORAGE_BASE_URL" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  [3] sqlite3 全局本地缓存" -ForegroundColor Green
Write-Host "      位置: $cacheDir" -ForegroundColor DarkGray
Write-Host "      作用: 所有 Flutter Windows/Linux 构建共用，无需重复下载" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  [4] flutter_bootstrap.js 全局模板" -ForegroundColor Green
Write-Host "      位置: $bootstrapTemplateFile" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  [5] 项目配置工具" -ForegroundColor Green
Write-Host "      位置: $setupToolFile" -ForegroundColor DarkGray
Write-Host ""

if ($globalWarn -gt 0) {
    Write-Host "有 $globalWarn 个警告，请检查上方输出" -ForegroundColor DarkYellow
}

Write-Host "--------------------------------------------------------" -ForegroundColor Cyan
Write-Host "  新项目使用方法（只需 1 步）：" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. 复制 setup_project.ps1 到新项目根目录" -ForegroundColor White
Write-Host "  2. 在新项目根目录执行：" -ForegroundColor White
Write-Host "     powershell -ExecutionPolicy Bypass -File setup_project.ps1" -ForegroundColor White
Write-Host ""
Write-Host "  如果使用 Drift，可指定数据库名：" -ForegroundColor DarkGray
Write-Host "     powershell -ExecutionPolicy Bypass -File setup_project.ps1 -DbName myapp" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Android 镜像无需任何配置（全局自动生效）" -ForegroundColor DarkGray
Write-Host "  Flutter SDK 镜像无需任何配置（环境变量自动生效）" -ForegroundColor DarkGray
Write-Host "--------------------------------------------------------" -ForegroundColor Cyan
Write-Host ""
