<#
.SYNOPSIS
    Flutter 新项目国内镜像配置（项目级）
.DESCRIPTION
    为当前 Flutter 项目应用国内镜像配置。
    依赖 init_flutter_env.ps1 已运行完成。

    使用方法：在新项目根目录执行
    powershell -ExecutionPolicy Bypass -File setup_project.ps1

    如果使用 Drift，可指定数据库名：
    powershell -ExecutionPolicy Bypass -File setup_project.ps1 -DbName myapp
#>

param(
    [string]$DbName = "app",
    [switch]$SkipWindows,
    [switch]$SkipWeb
)

$ErrorActionPreference = "Stop"
$ProjectRoot = (Get-Location).Path

Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  Flutter 项目国内镜像配置" -ForegroundColor Cyan
Write-Host "  项目: $ProjectRoot" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

function Ensure-Dir([string]$Path) {
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Force -Path $Path | Out-Null
    }
}

$gradleHome = if ($env:GRADLE_USER_HOME) { $env:GRADLE_USER_HOME } else { "$env:USERPROFILE\.gradle" }

# ============================================
# 1. Windows CMake sqlite3 配置（引用全局缓存）
# ============================================
if (-not $SkipWindows) {
    Write-Host "[1/3] Windows CMake sqlite3 配置..." -ForegroundColor Yellow

    $windowsDir = "$ProjectRoot\windows"
    $cmakeFile = "$windowsDir\CMakeLists.txt"

    if (-not (Test-Path $windowsDir)) {
        Write-Host "  -> windows/ 目录不存在，跳过" -ForegroundColor Gray
    } else {
        $sqliteVersion = "3520000"
        $globalSqliteDir = "$gradleHome\flutter-deps\sqlite3\sqlite-autoconf-$sqliteVersion"

        if (-not (Test-Path "$globalSqliteDir\sqlite3.c")) {
            Write-Host "  [WARN] 全局 sqlite3 缓存不存在: $globalSqliteDir" -ForegroundColor DarkYellow
            Write-Host "  -> 请先运行 init_flutter_env.ps1 进行全局初始化" -ForegroundColor DarkYellow
        } else {
            Write-Host "  -> 全局缓存: $globalSqliteDir" -ForegroundColor Gray

            if (Test-Path $cmakeFile) {
                $cmakeContent = Get-Content $cmakeFile -Raw -Encoding UTF8
                if ($cmakeContent -notmatch "FETCHCONTENT_SOURCE_DIR_SQLITE3") {
                    $escapedDir = $globalSqliteDir -replace '\\', '\\'
                    $cmakePatch = @"

# China mirror: use cached sqlite3 source from global Gradle deps
if(EXISTS "$globalSqliteDir/sqlite3.c")
  set(FETCHCONTENT_SOURCE_DIR_SQLITE3 "$globalSqliteDir" CACHE PATH "Local sqlite3 source" FORCE)
endif()
"@
                    $cmakeContent = $cmakeContent -replace '(set\(FLUTTER_MANAGED_DIR\s+"[^"]*"\))', "`$1$cmakePatch"
                    $cmakeContent = $cmakeContent -replace '(add_subdirectory\(\$\{FLUTTER_MANAGED_DIR\}\))', "`n`$1"
                    Set-Content $cmakeFile -Value $cmakeContent -Encoding UTF8
                    Write-Host "  -> CMakeLists.txt 已修改（引用全局缓存）" -ForegroundColor Green
                } else {
                    Write-Host "  -> CMakeLists.txt 已配置，跳过" -ForegroundColor Gray
                }
            }
            Write-Host "  [OK] Windows sqlite3 已配置" -ForegroundColor Green
        }
    }
} else {
    Write-Host "[1/3] Windows: 跳过" -ForegroundColor Gray
}
Write-Host ""

# ============================================
# 2. Web flutter_bootstrap.js
# ============================================
if (-not $SkipWeb) {
    Write-Host "[2/3] Web flutter_bootstrap.js 配置..." -ForegroundColor Yellow

    $webDir = "$ProjectRoot\web"
    $bootstrapFile = "$webDir\flutter_bootstrap.js"
    $templateFile = "$gradleHome\flutter-deps\templates\web\flutter_bootstrap.js"

    if (-not (Test-Path $webDir)) {
        Write-Host "  -> web/ 目录不存在，跳过" -ForegroundColor Gray
    } elseif (Test-Path $bootstrapFile) {
        $content = Get-Content $bootstrapFile -Raw -Encoding UTF8
        if ($content -match "canvaskit") {
            Write-Host "  -> flutter_bootstrap.js 已配置 CanvasKit CDN，跳过" -ForegroundColor Gray
        } elseif (Test-Path $templateFile) {
            Copy-Item $templateFile $bootstrapFile -Force
            Write-Host "  -> 从全局模板复制 flutter_bootstrap.js" -ForegroundColor Green
        } else {
            Write-Host "  -> 全局模板不存在，请先运行 init_flutter_env.ps1" -ForegroundColor DarkYellow
        }
    }
    Write-Host "  [OK] Web CanvasKit 已配置" -ForegroundColor Green
} else {
    Write-Host "[2/3] Web: 跳过" -ForegroundColor Gray
}
Write-Host ""

# ============================================
# 3. Drift Web 条件导入文件（如果使用 Drift）
# ============================================
if (-not $SkipWeb) {
    Write-Host "[3/3] Drift Web 条件导入文件..." -ForegroundColor Yellow

    $dbDir = "$ProjectRoot\lib\data\database"

    if (-not (Test-Path $dbDir)) {
        Write-Host "  -> database 目录不存在，跳过（非 Drift 项目）" -ForegroundColor Gray
    } else {
        $nativeFile = "$dbDir\database_connection.dart"
        $webDbFile = "$dbDir\database_connection_web.dart"
        $stubFile = "$dbDir\database_connection_stub.dart"

        if ((Test-Path $nativeFile) -and (Test-Path $webDbFile) -and (Test-Path $stubFile)) {
            Write-Host "  -> Drift 条件导入文件已存在，跳过" -ForegroundColor Gray
        } else {
            if (-not (Test-Path $nativeFile)) {
                @"
import 'dart:io';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, '$DbName.db'));
    return NativeDatabase.createInBackground(file);
  });
}
"@ | Set-Content $nativeFile -Encoding UTF8
                Write-Host "  -> database_connection.dart (native)" -ForegroundColor Green
            }

            if (-not (Test-Path $webDbFile)) {
                @"
import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final db = await WasmDatabase.open(
      databaseName: '$DbName',
      sqlite3Uri: Uri.parse('https://cdn.jsdelivr.net/npm/sqlite-wasm-umd@0.1.18/sqlite3.wasm'),
      driftWorkerUri: Uri.parse('https://cdn.jsdelivr.net/npm/sqlite-wasm-umd@0.1.18/sqlite3.wasm'),
    );
    return db.resolvedExecutor;
  });
}
"@ | Set-Content $webDbFile -Encoding UTF8
                Write-Host "  -> database_connection_web.dart (web)" -ForegroundColor Green
            }

            if (-not (Test-Path $stubFile)) {
                @"
import 'package:drift/drift.dart';

LazyDatabase openConnection() {
  throw UnsupportedError('No database implementation for this platform');
}
"@ | Set-Content $stubFile -Encoding UTF8
                Write-Host "  -> database_connection_stub.dart" -ForegroundColor Green
            }

            Write-Host "  [提示] 请确保数据库类使用条件导入:" -ForegroundColor DarkYellow
            Write-Host "    import 'database_connection_stub.dart'" -ForegroundColor DarkYellow
            Write-Host "        if (dart.library.io) 'database_connection.dart'" -ForegroundColor DarkYellow
            Write-Host "        if (dart.library.js_interop) 'database_connection_web.dart';" -ForegroundColor DarkYellow
        }
        Write-Host "  [OK] Drift 条件导入文件已就绪" -ForegroundColor Green
    }
} else {
    Write-Host "[3/3] Drift Web: 跳过" -ForegroundColor Gray
}
Write-Host ""

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  项目配置完成!" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "全局基础设施（init_flutter_env.ps1 已配置）:" -ForegroundColor White
Write-Host "  [+] Gradle 全局镜像 -> 所有 Android 项目自动生效" -ForegroundColor DarkGray
Write-Host "  [+] Flutter SDK 镜像 -> pub get / flutter pub 自动生效" -ForegroundColor DarkGray
Write-Host "  [+] sqlite3 全局缓存 -> 所有 Windows/Linux 构建共用" -ForegroundColor DarkGray
Write-Host ""
Write-Host "项目级配置（本脚本已完成）:" -ForegroundColor White
Write-Host "  [+] Windows CMake 引用全局 sqlite3 缓存" -ForegroundColor DarkGray
Write-Host "  [+] Web CanvasKit CDN (flutter_bootstrap.js)" -ForegroundColor DarkGray
Write-Host "  [+] Drift Web 条件导入文件" -ForegroundColor DarkGray
Write-Host ""
