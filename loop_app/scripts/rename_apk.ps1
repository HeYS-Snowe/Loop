param(
    [string]$Status = "dev",
    [string]$Version = $null,
    [switch]$All = $false
)

$ErrorActionPreference = "Stop"

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptPath
$apkOutputDir = Join-Path $projectRoot "build\app\outputs\flutter-apk"
$pubspecPath = Join-Path $projectRoot "pubspec.yaml"

function Get-VersionFromPubspec {
    param([string]$pubspecPath)
    
    if (-not (Test-Path $pubspecPath)) {
        Write-Error "pubspec.yaml 文件不存在: $pubspecPath"
        exit 1
    }
    
    $content = Get-Content $pubspecPath -Raw
    if ($content -match "version:\s*(\d+\.\d+\.\d+)") {
        return $matches[1]
    }
    
    return "0.0.0"
}

function Get-BuildDate {
    return Get-Date -Format "yyyyMMdd"
}

function Get-BuildSequence {
    param([string]$apkOutputDir, [string]$buildDate, [string]$status, [string]$version)
    
    $existingFiles = Get-ChildItem -Path $apkOutputDir -Filter "*.apk" -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "Loop_${status}_${version}_${buildDate}_\d{2}\.apk" }
    
    if ($existingFiles.Count -eq 0) {
        return 1
    }
    
    $maxSequence = 0
    foreach ($file in $existingFiles) {
        if ($file.Name -match "Loop_${status}_${version}_${buildDate}_(\d{2})\.apk") {
            $sequence = [int]$matches[1]
            if ($sequence -gt $maxSequence) {
                $maxSequence = $sequence
            }
        }
    }
    
    return $maxSequence + 1
}

function Backup-OriginalAPK {
    param([string]$apkPath)
    
    $backupDir = Join-Path (Split-Path $apkPath) "backup"
    if (-not (Test-Path $backupDir)) {
        New-Item -ItemType Directory -Path $backupDir | Out-Null
    }
    
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupName = "app_$(Split-Path $apkPath -Leaf)_$timestamp.apk"
    $backupPath = Join-Path $backupDir $backupName
    
    Write-Host "备份: $(Split-Path $apkPath -Leaf) -> backup\$backupName" -ForegroundColor Yellow
    Copy-Item -Path $apkPath -Destination $backupPath -Force
}

function Rename-APK {
    param(
        [string]$apkPath,
        [string]$status,
        [string]$version,
        [string]$buildDate,
        [int]$sequence
    )
    
    $sequenceStr = $sequence.ToString("00")
    $newName = "Loop_${status}_${version}_${buildDate}_${sequenceStr}.apk"
    $newPath = Join-Path (Split-Path $apkPath) $newName
    
    if (Test-Path $newPath) {
        Write-Warning "目标文件已存在: $newPath"
        return $false
    }
    
    Write-Host "重命名: $(Split-Path $apkPath -Leaf) -> $newName" -ForegroundColor Green
    Rename-Item -Path $apkPath -NewName $newName -Force
    return $true
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Loop APK 重命名工具" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $apkOutputDir)) {
    Write-Error "APK 输出目录不存在: $apkOutputDir"
    Write-Host "请先运行构建命令: flutter build apk" -ForegroundColor Yellow
    exit 1
}

# 读取版本号
if ([string]::IsNullOrEmpty($Version)) {
    $Version = Get-VersionFromPubspec -pubspecPath $pubspecPath
}

Write-Host "版本号: $Version" -ForegroundColor Cyan
Write-Host "状态类型: $Status" -ForegroundColor Cyan
Write-Host ""

$buildDate = Get-BuildDate
$buildSequence = Get-BuildSequence -apkOutputDir $apkOutputDir -buildDate $buildDate -status $Status -version $Version

Write-Host "构建日期: $buildDate" -ForegroundColor Cyan
Write-Host "构建序号: $($buildSequence.ToString('00'))" -ForegroundColor Cyan
Write-Host ""

# 查找所有APK文件
$apkFiles = Get-ChildItem -Path $apkOutputDir -Filter "*.apk" -File | Where-Object { $_.Name -notmatch "^Loop_" }

# 如果指定了All参数，使用所有APK文件；否则，只使用第一个APK文件
if (-not $All -and $apkFiles.Count -gt 1) {
    $apkFiles = @($apkFiles[0])
}

if ($apkFiles.Count -eq 0) {
    Write-Warning "未找到需要重命名的 APK 文件"
    Write-Host "提示: 已按规范命名的文件会被跳过" -ForegroundColor Yellow
    exit 0
}

Write-Host "找到 $($apkFiles.Count) 个 APK 文件:" -ForegroundColor Cyan
$apkFiles | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Gray }
Write-Host ""

$renamedCount = 0
foreach ($apkFile in $apkFiles) {
    $apkPath = $apkFile.FullName
    
    Backup-OriginalAPK -apkPath $apkPath
    
    if (Rename-APK -apkPath $apkPath -status $Status -version $Version -buildDate $buildDate -sequence $buildSequence) {
        $renamedCount++
        $buildSequence++
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "重命名完成！" -ForegroundColor Green
Write-Host "成功重命名: $renamedCount 个文件" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
